//
//  HomeScreen.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/10/25.
//

import SwiftUI
import MaterialUIKit
import AVFoundation

struct HomeScreen: View {
    @State private var model = TableOptions()
    @Environment(Router.self) private var router

    var body: some View {
        NavigationContainer {
            VStack(spacing: 16) {
                ChecksTable(model)
                    .navigationContainerTopBar(title: "Receipts", backButtonHidden: true, style: .large)

                ActionButton("Split New Receipt", style: .filledStretched) {
                    router.navigateTo(route: .capture)
                }
            }
        }.task {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            if status == .notDetermined {
                await AVCaptureDevice.requestAccess(for: .video)
            }
        }
    }
}

#Preview {
    return HomeScreen()
        .environment(Router())
        .modelContainer(DataController.previewContainer)
}
