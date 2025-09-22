//
//  GenerationService.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/22/25.
//

import Foundation
import FoundationModels

let INSTRUCTIONS = """
    Please sort this description of the check into items using the supplied guidelines.
    Please ignore any junk descriptions such as the name of the merchant and any tax information
    or information about coupons or surveys. Be sure to include prices formatted as integers in cents ie ($1.15=115)
"""

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
