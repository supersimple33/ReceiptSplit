//
//  VisionService.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/22/25.
//

import Foundation
import Vision
import CoreImage

actor VisionService {
    static let shared = VisionService()

    private init() { }

    func analyzeForText(
        image: CIImage,
        progressHandler: VNRequestProgressHandler? = nil,
        handleError: ((Error) -> Void)? = nil,
        completion: @escaping ([String]) -> Void
    ) throws {
        let requestHandler = VNImageRequestHandler(ciImage: image)

        let request = VNRecognizeTextRequest { request, error in
            if let error {
                // You may want to surface this error to the UI.
                handleError?(error)
                return
            }

            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            let recognizedStrings = observations.compactMap { observation in
                // TODO: we can do some more clever stuff here
                // Return the string of the top VNRecognizedText instance.
                return observation.topCandidates(1).first?.string
            }

            completion(recognizedStrings)
        }

        request.recognitionLevel = .accurate
        if let progressHandler {
            request.progressHandler = progressHandler
        }

        try requestHandler.perform([request])
    }
}
