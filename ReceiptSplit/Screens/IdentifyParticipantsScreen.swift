//
//  IdentifyParticipantsScreen.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/24/25.
//

import SwiftUI
import SwiftData
import MaterialUIKit
import Contacts

struct IdentifyParticipantsScreen: View {
    let check: Check

    @State private var showContactPicker: Bool = false

    @State private var showSnackbar = false
    @State private var snackbarMessage: String = ""

    private enum IdentifyParticipantsError: LocalizedError {
        case regionNotSet

        var errorDescription: String? {
            switch self {
            case .regionNotSet:
                return "No region is set for the current locale."
            }
        }
    }

    var body: some View {
        Container {
            ActionButton("Import from Contacts", style: .tonalStretched) {
                self.showContactPicker = true
            }
            ParticipantsTable(check: check)
            ActionButton("Manually Add", style: .tonalStretched) {
                print()
            }
            ActionButton("Continue", style: check.participants.isEmpty ? .outlineStretched : .filledStretched) {
                print()
            }.disabled(check.participants.isEmpty)
        }
        .contactPicker(isPresented: $showContactPicker, onDismiss: nil) { (contact, contactProperty) in
            do {
                if let contactProperty, let phoneNumber = contactProperty.value as? CNPhoneNumber {
                    check.participants.append(try Participant(
                        firstName: contact.givenName,
                        lastName: contact.familyName,
                        phoneNumber: phoneNumber.stringValue,
                        check: self.check
                    ))
                } else if let phoneNumber = contact.phoneNumbers.first?.value {
                    check.participants.append(try Participant(
                        firstName: contact.givenName,
                        lastName: contact.familyName,
                        phoneNumber: phoneNumber.stringValue,
                        check: self.check
                    ))
                } else {
                    check.participants.append(try Participant(
                        firstName: contact.givenName,
                        lastName: contact.familyName,
                        check: self.check
                    ))
                }
            } catch let error {
                print(error)
                self.showSnackbar = true
                self.snackbarMessage = error.localizedDescription
            }
        }
        .snackbar(isPresented: $showSnackbar, message: snackbarMessage)
    }
}

#Preview {
    // Build a context from the preview container
    let container = DataController.previewContainer
    let context = container.mainContext

    // Try to fetch a single Check
    var descriptor = FetchDescriptor<Check>()
    descriptor.fetchLimit = 1
    descriptor.sortBy = [SortDescriptor(\Check.name, order: .forward)]
    let fetchedCheck = try! context.fetch(descriptor).first!

    return IdentifyParticipantsScreen(check: fetchedCheck)
        .modelContainer(container)
}
