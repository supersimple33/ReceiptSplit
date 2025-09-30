//
//  VisionService.swift
//  RapidSplit
//
//  Created by Addison Hanrattie on 9/22/25.
//

import Foundation
import Vision
import CoreImage
import UIKit

actor VisionService {
    static let shared = VisionService()

    private init() { }

    func analyzeForText(
        image: CIImage,
        orientation: CGImagePropertyOrientation? = nil,
        progressHandler: VNRequestProgressHandler? = nil,
        handleError: ((Error) -> Void)? = nil,
        completion: sending @escaping ([String]) -> Void
    ) throws {
        let requestHandler = orientation == nil
            ? VNImageRequestHandler(ciImage: image)
            : VNImageRequestHandler(ciImage: image, orientation: orientation!)

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

extension CGImagePropertyOrientation {
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
            case .up: self = .up
            case .upMirrored: self = .upMirrored
            case .down: self = .down
            case .downMirrored: self = .downMirrored
            case .left: self = .left
            case .leftMirrored: self = .leftMirrored
            case .right: self = .right
            case .rightMirrored: self = .rightMirrored
        @unknown default:
            fatalError()
        }
    }
}
