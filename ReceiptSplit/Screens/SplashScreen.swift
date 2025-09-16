//
//  SplashScreen.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/15/25.
//

import SwiftUI

struct SplashScreen: View {
    @State private var router = Router()

    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            HomeScreen()
                .environment(router)
                .navigationDestination(for: Router.Route.self) { route in
                    switch route {
                    case .capture:
                        CaptureScreen().environment(router)
                    case .analysis(let image):
                        CheckAnalysisScreen(image: image).environment(router)
                    }
                }
        }
    }
}

#Preview {
    SplashScreen()
}
