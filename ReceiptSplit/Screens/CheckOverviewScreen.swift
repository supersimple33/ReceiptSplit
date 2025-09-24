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

    let title: String
    let items: [GeneratedItem]

    @State private var check: Check?

    @State private var showSnackbar = false
    @State private var snackbarMessage: String = ""

    var body: some View {
        Container {
            if let check {
                ItemsTable(check: check)
            }
        }.task {
            do {
                self.check = try Check(name: title)
            } catch let error {
                print(error)
                self.snackbarMessage = error.localizedDescription
                self.showSnackbar = true
            }

            modelContext.insert(self.check!)

            for generatedItem in items {
                if generatedItem.quantity == 1 {
                    modelContext.insert(
                        Item(name: generatedItem.name, price: generatedItem.price, forCheck: self.check!)
                    )
                } else {
                    for i in 1...generatedItem.quantity {
                        modelContext.insert(
                            Item(
                                name: generatedItem.name + " #\(i)/\(generatedItem.quantity)",
                                price: generatedItem.price / generatedItem.quantity,
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
    .modelContainer(for: [Check.self, Item.self])
}
