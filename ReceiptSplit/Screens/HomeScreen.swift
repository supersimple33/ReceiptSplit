//
//  HomeScreen.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/6/25.
//

import SwiftUI
import SwiftData
import Tabler
import MaterialUIKit

struct HomeScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var checks: [Check]

    private typealias Context = TablerContext<Check>
    private typealias Sort = TablerSort<Check>

    private var gridItems: [GridItem] {
        [GridItem(.flexible(), alignment: .leading), GridItem(.flexible(), alignment: .trailing)]

    }

    private func row(check: Check) -> some View {
        LazyVGrid(columns: gridItems) {
            Text(check.name)
            Text(check.createdAt.description).multilineTextAlignment(.trailing)
        }
    }

    private func header(ctx: Binding<Context>) -> some View {
        LazyVGrid(columns: gridItems) {
            Text("Name")
            Text("Date")
        }
    }

    private var tablerConfig: TablerStackConfig<Check> {
        TablerStackConfig<Check>()
    }

    var body: some View {
        NavigationContainer {
            TablerStack(tablerConfig, header: header, row: row, results: checks)
        }
    }
}

#Preview {
    return HomeScreen()
        .modelContainer(DataController.previewContainer)
}
