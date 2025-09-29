//
//  TotalsTable.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/29/25.
//

import SwiftUI
import Tabler
import MaterialUIKit

struct TotalsTable: View {
    private typealias Context = TablerContext<Participant>
    private typealias Sort = TablerSort<Participant>

    private let currencyCode = Locale.current.currency?.identifier ?? "USD"

    @Bindable var check: Check
    let handlePayout: (Participant) -> Void

    private var tablerConfig: TablerStackConfig<Participant> {
        TablerStackConfig<Participant>(
            tablePadding: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        )
    }

    private let gridItems: [GridItem] = [
        GridItem(.fixed(45), alignment: .center),
        GridItem(.fixed(60), alignment: .center),
        GridItem(.adaptive(minimum: 80, maximum: 150), alignment: .center),
        GridItem(.flexible(), alignment: .center)
    ]

    private func header(ctx: Binding<Context>) -> some View {
        LazyVGrid(columns: gridItems) {
            Text("")
            Text("# Items")
            Text("Price")
            Text("Payout")
        }
    }

    private func row(participant: Participant) -> some View {
        LazyVGrid(columns: gridItems) {
            InitialsIcon(participant: participant)
            Text(participant.items.count, format: .number)
            Text(participant.getTotalCost(), format: .currency(code: currencyCode))
            ActionButton(
                participant.payed ? "Subtotal" : "Payout",
                style: participant.payed ? .elevatedStretched : .filledStretched
            ) {
                handlePayout(participant)
            }
        }
    }

    var body: some View {
        TablerStack(tablerConfig, header: header, row: row, results: check.participants)
    }
}
