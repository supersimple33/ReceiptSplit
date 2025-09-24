//
//  CaptureScreen.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/12/25.
//

import SwiftUI
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
                router.navigateTo(route: .analysis(image: image))
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
