//
//  AssignmentTable.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/27/25.
//

import SwiftUI
import Tabler
import MaterialUIKit

struct AssignmentTable: View {
    private typealias Context = TablerContext<Item>
    private typealias Sort = TablerSort<Item>
    private let systemCurrencyCode = Locale.current.currency?.identifier ?? "USD"

    @Bindable var check: Check

    private var tablerConfig: TablerStackConfig<Item> {
        TablerStackConfig<Item>()
    }

    private let descriptionGridItems: [GridItem] = [
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .trailing)
    ]

    private func participantGridItems() -> [GridItem] {
        return Array(repeating:  GridItem(.flexible(), alignment: .center), count: self.check.participants.count)
    }

    private func header(ctx: Binding<Context>) -> some View {
        LazyVGrid(columns: participantGridItems()) {
            ForEach(self.check.participants) { participant in
                InitialsIcon(participant: participant)
            }
        }
    }

    let integerFormatter = CurrencyFormatter()

    private func deleteRows(offsets: IndexSet) {
        check.items.remove(atOffsets: offsets)
    }

    private func row(item: Item) -> some View {
        VStack {
            LazyVGrid(columns: descriptionGridItems, alignment: .leading) {
                Text(item.name).lineLimit(1)
                Text(item.price, format: .currency(code: systemCurrencyCode))
                    .lineLimit(1)
            }
            LazyVGrid(columns: participantGridItems(), alignment: .center) {
                ForEach(self.check.participants) { participant in
                    Toggle("", isOn: Binding(get: {
                        item.orderers.contains(participant)
                    }, set: { on in
                        if on {
                            item.orderers.append(participant)
                        } else {
                            item.orderers.removeAll { $0 == participant }
                        }
                    })).toggleStyle(CheckboxStyle())
                }
            }
        }
    }

    var body: some View {
        TablerStack(tablerConfig, header: header, row: row, results: check.items)
    }
}
