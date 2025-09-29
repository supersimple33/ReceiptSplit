//
//  ParticipantOverview.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/29/25.
//

import SwiftUI
import MaterialUIKit

struct ParticipantOverview: View {
    let participant: Participant?
    let dismiss: () -> Void

    private let currencyCode = Locale.current.currency?.identifier ?? "USD"

    private var buyDescription: String {
        if let participant {
            let cost: String = participant.getTotalCost().formatted(.currency(code: currencyCode))
            let itemCount: String = participant.items.count.formatted(.number)
            let name: String = participant.firstName + " " + participant.lastName
            return name + " bought " + itemCount + " item" + (itemCount.count == 1 ? "" : "s")
                + (participant.payed ? " and owed " : " and owes ") + cost
        } else {
            return ""
        }
    }

    var body: some View {
        if let participant {
            VStack(spacing: 8.0) {
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
                if !participant.payed, let phoneNumber = participant.phoneNumber {
                    ActionButton("Request with Venmo", style: .filledStretched) {
                        participant.payed.toggle()
                        self.dismiss()
                        print("HII")
                    }
                }
            }
        } else {
            Text("Error: No Participant")
        }
    }
}
