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
    @State private var selection: Route?

    // A simple route enum to drive navigation
    fileprivate enum Route: Hashable, Identifiable {
        case capture

        var id: String {
            switch self {
            case .capture: return "capture"
            }
        }
    }

    var body: some View {
        NavigationContainer {
            VStack(spacing: MaterialUIKit.configuration.verticalStackSpacing) {
                ChecksTable(model)
                    .navigationContainerTopBar(title: "Receipts", backButtonHidden: true, style: .large)

                ActionButton("Split New Receipt", style: .filledStretched) {
                    selection = .capture
                }
            }
            .modifier(NavigationDestinations(selection: $selection))
        }.task {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            if status == .notDetermined {
                await AVCaptureDevice.requestAccess(for: .video)
            }
        }
    }
}

// A view modifier to host navigation destinations cleanly
private struct NavigationDestinations: ViewModifier {
    @Binding var selection: HomeScreen.Route?

    func body(content: Content) -> some View {
        content
            .navigationDestination(item: $selection) { route in
                switch route {
                case .capture:
                    CaptureScreen()
                }
            }
    }
}

#Preview {
    HomeScreen().modelContainer(DataController.previewContainer)
}
