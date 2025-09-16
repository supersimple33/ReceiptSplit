//
//  CheckAnalysisModel.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/15/25.
//

import Foundation
import Vision
import CoreImage
import FoundationModels

let INSTRUCTIONS = "Please sort this description of the check into items using the supplied guidelines"

class CheckAnalysisModel: ObservableObject {
    let image: CIImage

    @Published var phase: AnalysisPhase = .detectingText
    @Published var progress: Double = 0
    @Published var recognizedStrings: [String] = []
    @Published var partialCheckItems: [GeneratedItem.PartiallyGenerated] = []
    @Published var finalCheckItems: [GeneratedItem] = []

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

    func generateCheckStructure(finalizedCheckItems: @escaping ([GeneratedItem]) -> Void) async throws {
        let session = LanguageModelSession(model: .default, instructions: INSTRUCTIONS)
        let prompt = "Here is the scanned check:\n" + self.recognizedStrings.joined(separator: "\n")
        let stream = session.streamResponse(to: prompt, generating: [GeneratedItem].self)

        for try await items in stream {
            self.partialCheckItems = items.content
        }

        let items = try await stream.collect().content
        finalizedCheckItems(items)
    }

    private func handleVisionFinished(with request: VNRequest, error: Error?) {
        if let error {
            // You may want to surface this error to the UI.
            print("Vision request failed: \(error)")
            return
        }
        guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
        self.recognizedStrings = observations.compactMap { observation in
            // TODO: we can do some more clever stuff here
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(1).first?.string
        }
    }

    func analyzeForText() throws {
        let requestHandler = VNImageRequestHandler(ciImage: image)
        let request = VNRecognizeTextRequest(completionHandler: handleVisionFinished)
        request.recognitionLevel = .accurate
        request.progressHandler = { _, progress, _ in
            self.progress = progress
        }
        try requestHandler.perform([request])
    }
}
