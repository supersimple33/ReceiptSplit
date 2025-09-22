//
//  CustomCameraScreen.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/22/25.
//

import SwiftUI
import MijickCamera

struct CustomCameraScreen<Label: View>: MCameraScreen {
    @ObservedObject public var cameraManager: CameraManager
    public let namespace: Namespace.ID
    public let closeMCameraAction: () -> ()
    public let button: Label

    init(
        cameraManager: CameraManager,
        namespace: Namespace.ID,
        closeMCameraAction: @escaping () -> Void,
        @ViewBuilder button: @escaping () -> Label
    ) {
        self.cameraManager = cameraManager
        self.namespace = namespace
        self.closeMCameraAction = closeMCameraAction
        self.button = button()
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
                button
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
    }
}
