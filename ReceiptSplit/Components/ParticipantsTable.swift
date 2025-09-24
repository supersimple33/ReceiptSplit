//
//  ParticipantsTable.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/24/25.
//

import SwiftUI
import Tabler
import PhoneNumberKit

struct ParticipantsTable: View {
    private typealias Context = TablerContext<Participant>
    private typealias Sort = TablerSort<Participant>

    @Bindable var check: Check

    private var tablerConfig: TablerListConfig<Participant> {
        TablerListConfig<Participant>(onDelete: deleteRows)
    }

    private let gridItems: [GridItem] = [
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .trailing)
    ]

    private func header(ctx: Binding<Context>) -> some View {
        LazyVGrid(columns: gridItems) {
            HStack {
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
        LazyVGrid(columns: gridItems, alignment: .leading) {
            HStack {
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

