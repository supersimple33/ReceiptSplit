//
//  HomeScreen.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/6/25.
//

import SwiftUI
import SwiftData

struct HomeScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query var checks: [Check]

    var body: some View {
        VStack {
            Text("Hello, world!")
            Table(checks) {
                TableColumn("Name", value: \.name)
                TableColumn("Date", value: \.name)
            }.tableColumnHeaders(.visible)
            Text("Hello, world!")
        }
    }
}

#Preview {
    return HomeScreen()
        .modelContainer(DataController.previewContainer)
}
