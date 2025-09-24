//
//  IdentifyParticipantsScreen.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/24/25.
//

import SwiftUI
import SwiftData

struct IdentifyParticipantsScreen: View {
    let check: Check
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
