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
    @State private var showSnackbar = false
    @State private var snackbarMessage: String = ""

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
        }.task {
            do {
                try model.analyzeForText()
            } catch let err {
                self.snackbarMessage = "Error: \(err.localizedDescription)"
                self.showSnackbar.toggle()
            }
        }.task(id: model.recognizedStrings.count, {
            guard !model.recognizedStrings.isEmpty else { return }
            do {
                try await model.generateCheckStructure { items in
                    // TODO push onto navigation
                }
            } catch let err {
                self.snackbarMessage = "Error: \(err.localizedDescription)"
                self.showSnackbar.toggle()
            }
        })
        .snackbar(isPresented: $showSnackbar, message: snackbarMessage)
    }

    init(image: CIImage) {
        self.image = image
        _model = StateObject(wrappedValue: CheckAnalysisModel(image))
    }
}

#Preview {
    CheckAnalysisScreen(image: CIImage(image: UIImage(systemName: "paintpalette")!)!)
}
