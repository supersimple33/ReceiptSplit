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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Check.self,
            Item.self,
            Participant.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            SplashScreen()
        }
        .modelContainer(sharedModelContainer)
    }

    init() {
//        MaterialUIKit.configuration.borderWidth = 2.0
    }
}
