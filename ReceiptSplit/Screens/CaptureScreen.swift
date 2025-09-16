//
//  CaptureScreen.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/12/25.
//

import SwiftUI
import PhotosUI
import MaterialUIKit
import CoreImage

struct CaptureScreen: View {
    @Environment(Router.self) private var router
    @State private var selectedItem: PhotosPickerItem?
    @State private var image: Image?
    @StateObject private var model = CameraModel()

    // TODO: add error snackbar

    var body: some View {
        Container {
            VStack(spacing: MaterialUIKit.configuration.verticalStackSpacing) {

                ImageView(image: model.previewImage )
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                HStack {
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images
                    ) {
                        IconButton(systemImage: "photo", style: .filled) {
                            Void()
                        }.allowsHitTesting(false)
                    }

                    ActionButton("Capture", style: .filledStretched) {
                        model.camera.takePhoto()
                    }

                    IconButton(systemImage: "arrow.trianglehead.2.clockwise.rotate.90.camera.fill", style: .filled) {
                        model.camera.switchCaptureDevice()
                    }
                }
            }
            .navigationContainerTopBar(title: "Scan A New Check / Receipt", backButtonHidden: false, style: .inline)
            .navigationDestination(item: $model.photo) { photo in
                CheckAnalysisScreen(image: CIImage(cgImage: photo))
            }

        }
        .onChange(of: selectedItem) { _, newItem in
            Task {
                guard let newItem else { return }
                // Load Data (Transferable) and convert to CIImage
                newItem.loadTransferable(type: Data.self) { result in
                    switch result {
                    case .success(let data?):
                        guard let ciImage = CIImage(data: data) else { return }
                        router.navigateTo(route: .analysis(image: ciImage))
                    case .success(nil):
                        print("Error loading image")
                    case .failure:
                        print("Error loading image")
                    }
                }
            }
        }
        .task {
            await model.camera.start()
        }
        .environmentObject(model)
    }
}

#Preview {
    CaptureScreen()
}
