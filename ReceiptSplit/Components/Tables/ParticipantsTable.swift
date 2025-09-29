//
//  ParticipantsTable.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/24/25.
//

import SwiftUI
import Tabler
import PhoneNumberKit

fileprivate let HORIZONTAL_SPACING = CGFloat(4)

struct ParticipantsTable: View {
    private typealias Context = TablerContext<Participant>
    private typealias Sort = TablerSort<Participant>

    @Bindable var check: Check

    private var tablerConfig: TablerListConfig<Participant> {
        TablerListConfig<Participant>(
            onDelete: deleteRows,
            tablePadding: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        )
    }

    private let gridItems: [GridItem] = [
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .trailing)
    ]

    private func header(ctx: Binding<Context>) -> some View {
        LazyVGrid(columns: gridItems, spacing: HORIZONTAL_SPACING) {
            HStack(spacing: HORIZONTAL_SPACING) {
                Text("First").frame(maxWidth: .infinity, alignment: .leading)
                Text("Last").frame(maxWidth: .infinity, alignment: .leading)
            }
            Text("Phone Number")
        }
    }

    let phoneFormatter = PhoneNumberFormatter()

    private func deleteRows(offsets: IndexSet) {
        check.participants.remove(atOffsets: offsets)
    }

    private func row(participant: Binding<Participant>) -> some View {
        LazyVGrid(columns: gridItems, alignment: .leading, spacing: HORIZONTAL_SPACING) {
            HStack(spacing: HORIZONTAL_SPACING) {
                TextField("First Name", text: participant.firstName)
                TextField("Last Name", text: participant.lastName)
            }
            TextField("Phone", value: participant.phoneNumber, formatter: phoneFormatter)
                .multilineTextAlignment(.trailing)
        }
    }

    var body: some View {
        TablerListB(tablerConfig, header: header, row: row, results: $check.participants)
    }
}

