//
//  Check.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/6/25.
//

import Foundation
import SwiftData

@Model
final class Check: Identifiable {
    var createdAt: Date = Date()
    var name: String
    @Relationship(deleteRule: .cascade, inverse: \Participant.check) var participants: [Participant]
    @Relationship(deleteRule: .cascade, inverse: \Item.check) var items: [Item]

    // Centralized constraints
    static let maxNameLength: Int = 50

    // Domain-specific validation error
    private enum ValidationError: Error, LocalizedError, Equatable {
        case emptyName
        case nameTooLong(max: Int)

        var errorDescription: String? {
            switch self {
            case .emptyName:
                return "Check name cannot be empty."
            case .nameTooLong(let max):
                return "Check name is too long. Maximum length is \(max) characters."
            }
        }
    }

    // Throwing initializer that validates and normalizes input
    init(name: String, participants: [Participant] = [], items: [Item] = []) throws {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            throw ValidationError.emptyName
        }
        guard trimmedName.count <= Self.maxNameLength else {
            throw ValidationError.nameTooLong(max: Self.maxNameLength)
        }

        self.name = trimmedName
        self.participants = participants
        self.items = items
    }
}

enum SortingOptions: String, CaseIterable {
    case name = "Name"
    case date = "Date"
    case none = "None"

    var sortDescriptors: [SortDescriptor<Check>] {
        switch self {
        case .name:
            [SortDescriptor(\Check.name, order: .reverse)]
        case .date:
            [SortDescriptor(\Check.createdAt)]
        case .none:
            []
        }
    }
}
