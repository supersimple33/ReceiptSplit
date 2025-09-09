//
//  HomeScreen.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/6/25.
//

import SwiftUI
import SwiftData

struct HomeScreen: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    return HomeScreen()
        .modelContainer(DataController.previewContainer)
}
