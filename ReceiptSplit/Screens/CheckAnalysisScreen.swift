//
//  CheckAnalysisScreen.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/13/25.
//

import SwiftUI
import Vision
import MaterialUIKit

struct CheckAnalysisScreen: View {
    let image: CIImage
    private let context = CIContext()

    @StateObject private var model: CheckAnalysisModel

    private func convertCIImageToUIImage(_ ciImage: CIImage) -> UIImage? {
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }

    var body: some View {
        NavigationContainer {
            HStack(spacing: MaterialUIKit.configuration.horizontalStackSpacing) {
                Image(uiImage: convertCIImageToUIImage(image)!)
                // Progress indicator and current phase
//                Separator(orientation: .vertical)
                VStack(spacing: MaterialUIKit.configuration.verticalStackSpacing) {
                    ProgressBar(lineWidth: 5)
                    Text(model.phase.displayTitle)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationContainerTopBar(title: "Analyzing Receipt", backButtonHidden: false, style: .inline)
        }
    }

    init(image: CIImage) {
        self.image = image
        _model = StateObject(wrappedValue: CheckAnalysisModel(image))
    }
}

#Preview {
    CheckAnalysisScreen(image: CIImage(image: UIImage(systemName: "paintpalette")!)!)
}
