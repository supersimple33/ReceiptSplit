//
//  GenerationService.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/22/25.
//

import Foundation
import FoundationModels

let INSTRUCTIONS = "Please sort this description of the check into items using the supplied guidelines"

actor GenerationService {
    static let shared = GenerationService()

    private init() { }

    func generateCheckStructure(
        recognizedStrings: [String],
        onPartial: (@Sendable ([GeneratedItem.PartiallyGenerated]) -> Void)? = nil
    ) async throws -> [GeneratedItem] {
        let session = LanguageModelSession(model: .default, instructions: INSTRUCTIONS)
        let prompt = "Here is the scanned check:\n" + recognizedStrings.joined(separator: "\n")
        let stream = session.streamResponse(to: prompt, generating: [GeneratedItem].self)

        if let onPartial {
            for try await items in stream {
                onPartial(items.content)
            }
        }

        let finalItems = try await stream.collect().content
        return finalItems
    }
}
