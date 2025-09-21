//
//  CaptureScreen.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/12/25.
//

import SwiftUI
import PhotosUI
import MaterialUIKit
import MijickCamera

struct CaptureScreen: View {
    @Environment(Router.self) private var router
    @State private var selectedItem: PhotosPickerItem?

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
                DefaultCameraScreen(
                    cameraManager: cameraManager,
                    namespace: namespace,
                    closeMCameraAction: closeMCameraAction,
                )
                .cameraOutputSwitchAllowed(false)
            })
            .setCloseMCameraAction {
                router.navigationPath.removeLast()
            }
            .startSession()
        .navigationBarBackButtonHidden(true)
        .onChange(of: selectedItem) { _, newItem in
            Task {
                guard let newItem else { return }
                // Load Data (Transferable) and convert to CIImage
                newItem.loadTransferable(type: Data.self) { result in
                    switch result {
                    case .success(let data?):
                        guard let ciImage = CIImage(data: data) else { return }
                        DispatchQueue.main.async {
                            router.navigateTo(route: .analysis(image: ciImage))
                        }
                    case .success(nil):
                        print("Error loading image")
                    case .failure:
                        print("Error loading image")
                    }
                }
            }
        }
    }
}

#Preview {
    CaptureScreen().environment(Router())
}

