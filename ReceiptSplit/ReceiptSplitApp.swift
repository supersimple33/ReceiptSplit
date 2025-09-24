//
//  ReceiptSplitApp.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/6/25.
//

import SwiftUI
import SwiftData
import MaterialUIKit

@main
struct ReceiptSplitApp: App {
    var body: some Scene {
        WindowGroup {
            SplashScreen()
        }
        .modelContainer(for: [Check.self, Item.self, Participant.self], inMemory: false, isAutosaveEnabled: true)
    }

    init() {
//        MaterialUIKit.configuration.borderWidth = 2.0
    }
}
