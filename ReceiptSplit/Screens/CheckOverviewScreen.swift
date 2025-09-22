//
//  CheckOverviewScreen.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/22/25.
//

import SwiftUI

struct CheckOverviewScreen: View {
    let items: [GeneratedItem]

    var body: some View {
        VStack {
            ForEach(items, id: \.name) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Text("$\(item.price, specifier: "%.2f")")
                }
            }
        }
    }
}

#Preview {
    CheckOverviewScreen(items: [])
}
