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
    var check: Check

    var body: some View {
        NavigationContainer {
            Text(check.items.count.description + " items")
                .navigationContainerTopBar(title: check.name, backButtonHidden: false, style: .inline)
            Text(check.items.map(\.name).joined(separator: ", "))
            Text(check.items.map(\.price.description).joined(separator: ", "))
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
    let fetchedCheck = try! context.fetch(descriptor).first

    return CheckDetailsScreen(check: fetchedCheck!)
        .modelContainer(container)
}
