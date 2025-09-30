//
//  CustomCameraView.swift
//  RapidSplit
//
//  Created by Addison Hanrattie on 9/22/25.
//

import SwiftUI
import MijickCamera // TODO: raise a PR so testable isn't needed
import PhotosUI

struct CustomCameraView: MCameraScreen {
    @ObservedObject public var cameraManager: CameraManager
    public let namespace: Namespace.ID
    public let closeMCameraAction: () -> ()

    @State private var selectedPhoto: PhotosPickerItem?

    init(
        cameraManager: CameraManager,
        namespace: Namespace.ID,
        closeMCameraAction: @escaping () -> Void,
    ) {
        self.cameraManager = cameraManager
        self.namespace = namespace
        self.closeMCameraAction = closeMCameraAction
    }

    public var body: some View {
        ZStack {
            DefaultCameraScreen(
                cameraManager: cameraManager,
                namespace: namespace,
                closeMCameraAction: closeMCameraAction
            )
            .lightButtonAllowed(false)
            .cameraOutputSwitchAllowed(false)

            ZStack {
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Image(systemName: "photo.on.rectangle.angled.fill")
                        .resizable()
                        .frame(width: 26, height: 26)
                        .foregroundColor(.white)
                        .frame(width: 52, height: 52)
                        .background(.black)
                        .mask(Circle())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .transition(.scale)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 72)
            .padding(.bottom, 44)
            .padding(.horizontal, 32)
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .task(id: selectedPhoto) {
            do {
                guard let data = try await selectedPhoto?.loadTransferable(type: Data.self) else {
                    print("Error loading image data")
                    return
                }
                guard let media = MCameraMedia(data: UIImage(data: data)) else {
                    print("Error converting data to image")
                    return
                }
                await MainActor.run {
                    cameraManager.setCapturedMedia(media)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
