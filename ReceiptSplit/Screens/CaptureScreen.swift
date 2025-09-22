//
//  CaptureScreen.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/12/25.
//

import SwiftUI
import MaterialUIKit
import MijickCamera

struct CaptureScreen: View {
    @Environment(Router.self) private var router

    // TODO: add error snackbar

    var body: some View {
        MCamera()
            .setAudioAvailability(false)
            .setCameraOutputType(.photo)
            .setResolution(.photo)
            .setCameraHDRMode(.on)
            .setFlashMode(.auto)
            .onImageCaptured { image, controller in
                if let ciImage = CIImage(image: image) {
                    router.navigateTo(route: .analysis(image: ciImage))
                } else {
                    // TODO: error handling
                }
            }
            .setCameraScreen({ cameraManager, namespace, closeMCameraAction in
                CustomCameraView(
                    cameraManager: cameraManager,
                    namespace: namespace,
                    closeMCameraAction: closeMCameraAction
                )
            })
            .setCloseMCameraAction {
                router.navigationPath.removeLast()
            }
            .startSession()
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    CaptureScreen().environment(Router())
}
