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

    @State var check: Check?

    let title: String
    let items: [GeneratedItem]

    var body: some View {
        Container {
            if let check {
                Text(check.name)
                VStack {
                    ForEach(check.items, id: \.name) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text(Double(item.price) / 100, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        }
                    }
                }
            }
        }.task {
            do {
                self.check = try Check(name: title)
            } catch {
                // TODO: error stuff
                return
            }

            modelContext.insert(self.check!)

            for generatedItem in items {
                for i in 1...generatedItem.quantity {
                    modelContext.insert(
                        Item(name: generatedItem.name + " \(i)", price: generatedItem.price, forCheck: self.check!)
                    )
                }
            }
            print(self.check!.items.count)
        }
    }
}

#Preview {
    CheckOverviewScreen(title: "Empty Check", items: [])
}
