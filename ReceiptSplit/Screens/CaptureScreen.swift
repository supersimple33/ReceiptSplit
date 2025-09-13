//
//  CaptureScreen.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/12/25.
//

import SwiftUI
import PhotosUI
import MaterialUIKit

struct CaptureScreen: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var image: Image?
    @StateObject private var model = CameraModel()

    var body: some View {
        NavigationContainer {
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
            }.navigationContainerTopBar(title: "Scan A New Check / Receipt", backButtonHidden: false, style: .inline)

        }.onChange(of: selectedItem) { prevItem, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        image = Image(uiImage: uiImage)
                    }
                }
            }
        }.task {
            await model.camera.start()
        }
        .environmentObject(model)
    }
}

#Preview {
    CaptureScreen()
}
