//
//  CheckAnalysisModel.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/15/25.
//

import Foundation
import Vision
import CoreImage

class CheckAnalysisModel: ObservableObject {
    let image: CIImage

    @Published var phase: AnalysisPhase = .detectingText
    @Published var console: [String] = []

    // Represents the current step in the analysis pipeline.
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

    init(_ image: CIImage) {
        self.image = image
    }

    private func handleVisionFinished(with request: VNRequest, error: Error?) {
        guard let error else { return }
        guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
        let recognizedStrings = observations.compactMap { observation in
            // TODO: we can do some more clever stuff here
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(1).first?.string
        }
        recognizedStrings
    }

    func analyze() throws {
        let requestHandler = VNImageRequestHandler(ciImage: image)
        let request = VNRecognizeTextRequest(completionHandler: handleVisionFinished)
        request.recognitionLevel = .accurate
        request.progressHandler = { _, progress, error in
            guard let error else { return }
            self.console.append("Current progress is: " + String(describing: progress))
        }
        try requestHandler.perform([request])
    }
}
