//
//  HomeScreen.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/10/25.
//

import SwiftUI
import MaterialUIKit

struct HomeScreen: View {
    @State private var model = TableOptions()

    var body: some View {
        NavigationContainer {
            ChecksTable(model)
        }
    }
}

#Preview {
    HomeScreen().modelContainer(DataController.previewContainer)
}
