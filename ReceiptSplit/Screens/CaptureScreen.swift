//
//  CaptureScreen.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/12/25.
//

import SwiftUI
import MaterialUIKit

struct CaptureScreen: View {
    

    var body: some View {
        NavigationContainer {
            Text("Hello, World!")
                .navigationContainerTopBar(title: "Capture", backButtonHidden: false, style: .inline)
        }
    }
}

#Preview {
    CaptureScreen()
}
