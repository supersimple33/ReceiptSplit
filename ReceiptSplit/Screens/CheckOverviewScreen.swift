//
//  CheckOverviewScreen.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/22/25.
//

import SwiftUI
import MaterialUIKit

struct CheckOverviewScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Router.self) private var router

    let title: String
    let items: [GeneratedItem]

    @State private var check: Check?

    @State private var showSnackbar = false
    @State private var snackbarMessage: String = ""

    var body: some View {
        Container {
            if let check {
                ItemsTable(check: check)
                    .floatingActionButton(systemImage: "square.and.pencil", titleKey: "Add New Item") {
                        check.items.append(
                            Item(
                                name: "New Item",
                                price: 10.0,
                                forCheck: self.check!
                            )
                        )
                    }
                ActionButton("Continue", style: check.items.isEmpty ? .outlineStretched : .filledStretched) {
                    router.navigateTo(route: .participants(check: check))
                }.disabled(check.items.isEmpty)
            }
        }
        .task {
            do {
                self.check = try Check(name: title)
            } catch let error {
                print(error)
                self.snackbarMessage = error.localizedDescription
                self.showSnackbar = true
                return // TODO: this should push to a chat screen
            }

            modelContext.insert(self.check!)

            for generatedItem in items {
                if generatedItem.quantity == 1 {
                    modelContext.insert(
                        Item(item: generatedItem, forCheck: self.check!)
                    )
                } else {
                    for i in 1...generatedItem.quantity {
                        modelContext.insert(
                            Item(
                                name: generatedItem.name + " #\(i)/\(generatedItem.quantity)",
                                price: generatedItem.price / Decimal(generatedItem.quantity),
                                forCheck: self.check!
                            )
                        )
                    }
                }
            }
        }
        .snackbar(isPresented: $showSnackbar, message: snackbarMessage)
    }
}

#Preview {
    CheckOverviewScreen(title: "Lunch", items: [
        GeneratedItem(name: "Burger", price: 200, quantity: 1),
        GeneratedItem(name: "Salad", price: 100, quantity: 2),
        GeneratedItem(name: "Salad", price: 50, quantity: 2),
    ])
    .environment(Router())
    .modelContainer(for: [Check.self, Item.self])
}
