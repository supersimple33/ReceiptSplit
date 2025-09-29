//
//  CheckDetailsScreen.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/11/25.
//

import SwiftUI
import SwiftData
import MaterialUIKit

struct CheckDetailsScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Router.self) private var router

    var check: Check

    @State private var showDialogSheet = false
    @State private var selectedParticipant: Participant?

    @State private var showSnackbar = false
    @State private var snackbarMessage: String = ""

    var body: some View {
        Container {
            TotalsTable(check: check, handlePayout: { participant in
                self.selectedParticipant = participant
                self.showDialogSheet = true
            })
        }
        .dialogSheet(isPresented: $showDialogSheet) {
            ParticipantOverview(participant: selectedParticipant) {
                do {
                    try self.modelContext.save()
                } catch let error {
                    self.snackbarMessage = error.localizedDescription
                    self.showSnackbar = true
                }
                self.showDialogSheet = false
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
    let fetchedCheck = try! context.fetch(descriptor).first

    return CheckDetailsScreen(check: fetchedCheck!)
        .environment(Router())
        .modelContainer(container)
}
