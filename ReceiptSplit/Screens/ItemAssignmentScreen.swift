//
//  ItemAssignmentScreen.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/25/25.
//

import SwiftUI
import SwiftData
import MaterialUIKit

struct ItemAssignmentScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Router.self) private var router

    let check: Check

    @State private var showSnackbar = false
    @State private var snackbarMessage: String = ""

    var body: some View {
        AssignmentTable(check: check)
        ActionButton("Finish Assignment") {
            do {
                try modelContext.save()
            } catch let error {
                snackbarMessage = error.localizedDescription
                showSnackbar = true
            }
            router.jumpToCheck(check: check)
        }
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

    return ItemAssignmentScreen(check: fetchedCheck)
        .environment(Router())
        .modelContainer(container)
}
