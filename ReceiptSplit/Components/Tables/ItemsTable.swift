//
//  ItemsTable.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/23/25.
//

import SwiftUI
import Tabler

struct ItemsTable: View {
    private typealias Context = TablerContext<Item>
    private typealias Sort = TablerSort<Item>

    @Bindable var check: Check

    private var tablerConfig: TablerListConfig<Item> {
        TablerListConfig<Item>(
            onDelete: deleteRows,
            tablePadding: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        )
    }

    private let gridItems: [GridItem] = [
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .trailing)
    ]

    private func header(ctx: Binding<Context>) -> some View {
        LazyVGrid(columns: gridItems) {
            Text("Name")
            Text("Price")
        }
    }

    private func deleteRows(offsets: IndexSet) {
        check.items.remove(atOffsets: offsets)
    }

    private func row(item: Binding<Item>) -> some View {
        LazyVGrid(columns: gridItems, alignment: .leading) {
            TextField("Item Name", text: item.name)
            TextField("Item Price", value: item.price, format: .currency(code: getCurrencyCode()))
                .multilineTextAlignment(.trailing).keyboardType(.decimalPad)
        }
    }

    var body: some View {
        TablerListB(tablerConfig, header: header, row: row, results: $check.items)
    }
}

