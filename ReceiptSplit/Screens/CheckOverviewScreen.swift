//
//  CheckOverviewScreen.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/22/25.
//

import SwiftUI
import MaterialUIKit

struct CheckOverviewScreen: View {
    let items: [GeneratedItem]

    var body: some View {
        Container {
            VStack {
                ForEach(items, id: \.name) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text(Double(item.price) / 100, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    }
                }
            }
        }
    }
}

#Preview {
    CheckOverviewScreen(items: [])
}
