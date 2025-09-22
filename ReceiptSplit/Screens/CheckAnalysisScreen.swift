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
    @Environment(Router.self) private var router

    let image: CIImage
    private let context = CIContext()

    @State private var showSnackbar = false
    @State private var snackbarMessage: String = ""

    @State private var phase: AnalysisPhase = .setup
    @State private var progress: Double = 0

    enum AnalysisPhase: Hashable {
        case setup
        case detectingText
        case runningAIAnalysis
        case buildingCheckItems

        var displayTitle: String {
            switch self {
                case .setup: return "Setting up"
                case .detectingText: return "Detecting text"
                case .runningAIAnalysis: return "Running AI analysis"
                case .buildingCheckItems: return "Building check items"
            }
        }
    }

    enum AnalysisError: LocalizedError {
        case noRecognizedText

        var errorDescription: String? {
            switch self {
            case .noRecognizedText:
                return "No text was detected in the image."
            }
        }
    }

    private func convertCIImageToUIImage(_ ciImage: CIImage) -> UIImage? {
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }

    var body: some View {
        Container {
            HStack(spacing: 12) {
                Image(uiImage: convertCIImageToUIImage(image)!)
                // Progress indicator and current phase
//                Separator(orientation: .vertical)
                VStack(spacing: 16) {
                    ProgressBar(lineWidth: 5)
                    Text(phase.displayTitle)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .task {
            do {
                phase = .detectingText
                try await VisionService.shared
                    .analyzeForText(image: image, progressHandler: handleProgess, handleError: handleError) { recognizedStrings in
                        DispatchQueue.main.async {
                            phase = .runningAIAnalysis
                        }
                        Task {
                            await handleVisionFinished(recognizedStrings: recognizedStrings)
                        }
                    }
            } catch let err {
                self.snackbarMessage = "Error: \(err.localizedDescription)"
                self.showSnackbar.toggle()
            }
        }
        .snackbar(isPresented: $showSnackbar, message: snackbarMessage)
    }

    nonisolated private func handleError(error: Error) {
        DispatchQueue.main.async {
            self.snackbarMessage = "Error: \(error.localizedDescription)"
            self.showSnackbar.toggle()
        }
    }

    nonisolated private func handleProgess(with request: VNRequest, progress: Double, error: Error?) {
        if let error {
            handleError(error: error)
        }
        DispatchQueue.main.async {
            self.progress = progress
        }
    }

    nonisolated private func handlePartialCheck(partialItems: [GeneratedItem.PartiallyGenerated]) {
        if !partialItems.isEmpty {
            DispatchQueue.main.async {
                self.phase = .buildingCheckItems
                // TODO: output the check status
            }
        }
    }

    nonisolated private func handleVisionFinished(recognizedStrings: [String]) async {
        guard !recognizedStrings.isEmpty else {
            handleError(error: AnalysisError.noRecognizedText)
            return
        }

        do {
            let items = try await GenerationService.shared.generateCheckStructure(
                recognizedStrings: recognizedStrings,
                onPartial: handlePartialCheck
            )
            await MainActor.run {
                router.navigateTo(route: .overview(items: items))
            }
        } catch let err {
            handleError(error: err)
        }
    }
}

#Preview {
    CheckAnalysisScreen(image: CIImage(image: UIImage(systemName: "paintpalette")!)!).environment(Router())
}

