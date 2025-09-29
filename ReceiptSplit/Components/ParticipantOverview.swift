//
//  ParticipantOverview.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/29/25.
//

import SwiftUI
import MaterialUIKit
import PhoneNumberKit

struct ParticipantOverview: View {
    @Environment(\.openURL) private var openURL

    let participant: Participant?
    let dismiss: () -> Void

    @State private var showSnackbar = false
    @State private var snackbarMessage: String = ""

    private var buyDescription: String {
        if let participant {
            let cost: String = participant.getTotalCost().formatted(.currency(code: getCurrencyCode()))
            let itemCount: String = participant.items.count.formatted(.number)
            let name: String = participant.firstName + " " + participant.lastName
            return name + " bought " + itemCount + " item" + (itemCount.count == 1 ? "" : "s")
                + (participant.payed ? " and owed " : " and owes ") + cost
        } else {
            return ""
        }
    }

    private var venmoLink: URL? {
        guard let participant, let phoneNumber = participant.phoneNumber else {
            return nil
        }
        let totalCost = participant.getTotalCost()
        guard totalCost.isNormal && totalCost >= 0 else {
            return nil
        }
        let phoneNumberUtility = PhoneNumberUtility()
        do {
            let formattedPhone = try phoneNumberUtility.parse(phoneNumber, ignoreType: true).adjustedNationalNumber()
            return URL(string: "venmo://paycharge?txn=request&recipients=\(formattedPhone)&note=ReceiptSplitBill&amount=\(totalCost)")
        } catch let error {
            snackbarMessage = error.localizedDescription
            showSnackbar = true
            return nil
        }
    }

    var body: some View {
        VStack(spacing: 8.0) {
            if let participant {

                Text(self.buyDescription)
                Text("Items Included: ")
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(participant.items) { item in
                            Text(item.name)
                        }
                    }
                }.scrollBounceBehavior(.basedOnSize)
                ActionButton("Mark As " + (participant.payed ? "Unpaid" : "Paid"), style: .filledStretched) {
                    participant.payed.toggle()
                    self.dismiss()
                }
                if !participant.payed, participant.phoneNumber != nil {
                    ActionButton("Request with Venmo", style: .filledStretched) {
                        guard let venmoLink else {
                            snackbarMessage = "Could not create venmo url"
                            showSnackbar = true
                            return
                        }
                        openURL(venmoLink) { accepted in
                            if accepted {
                                participant.payed.toggle()
                                self.dismiss()
                            } else {
                                self.snackbarMessage = "Venmo URL was not accepted"
                                self.showSnackbar = true
                            }
                        }
                    }
                }
            } else {
                Text("Error: No Participant")
            }
        }.snackbar(isPresented: $showSnackbar, message: snackbarMessage)
    }
}
