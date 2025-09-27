//
//  ItemAssignmentScreen.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/25/25.
//

import SwiftUI
import SwiftData

struct ItemAssignmentScreen: View {
    let check: Check

    var body: some View {
        AssignmentTable(check: check)
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
        .modelContainer(container)
}
