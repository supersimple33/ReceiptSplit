//
//  Participant.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/6/25.
//

import Foundation
import SwiftData
import PhoneNumberKit

@Model
final class Participant {
    // Stored properties
    var createdAt: Date = Date()
    var firstName: String
    var lastName: String
    var phoneNumber: String?
    var check: Check
    @Relationship(deleteRule: .nullify, inverse: \Item.orderer) var items: [Item]

    // Domain-specific validation error
    enum ValidationError: Error, LocalizedError, Equatable {
        case emptyFirstName
        case emptyLastName
        case nameTooLong(field: String, max: Int)
        case invalidPhoneNumber

        var errorDescription: String? {
            switch self {
            case .emptyFirstName:
                return "First name cannot be empty."
            case .emptyLastName:
                return "Last name cannot be empty."
            case .nameTooLong(let field, let max):
                return "\(field) is too long. Maximum length is \(max) characters."
            case .invalidPhoneNumber:
                return "Phone number is invalid."
            }
        }
    }

    // Centralized constraints
    static let maxNameLength: Int = 50

    private static func validateName(_ name: String) throws {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw ValidationError.emptyFirstName }
        guard trimmed.count <= Self.maxNameLength else {
            throw ValidationError.nameTooLong(field: "Name", max: Self.maxNameLength)
        }
    }

    private static func validatePhoneNumber(_ phoneNumber: String) throws {
        let phoneNumberUtility = PhoneNumberUtility()
        guard phoneNumberUtility
            .isValidPhoneNumber(phoneNumber, ignoreType: true) else {
            throw ValidationError.invalidPhoneNumber
        }
    }

    func validate() throws {
        if let phoneNumber {
            try Participant.validatePhoneNumber(phoneNumber)
        }
        try Participant.validateName(self.firstName)
        try Participant.validateName(self.lastName)
    }

    // Throwing initializer that validates and normalizes input
    init(firstName: String, lastName: String, phoneNumber: String? = nil, check: Check) throws {
        // Validate names
        let trimmedFirst = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        try Participant.validateName(trimmedFirst)

        let trimmedLast = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        try Participant.validateName(trimmedLast)

        // Validate and normalize phone if provided
        if let phoneNumber {
            try Participant.validatePhoneNumber(phoneNumber)
            self.phoneNumber = phoneNumber
        } else {
            self.phoneNumber = nil
        }
        self.firstName = trimmedFirst
        self.lastName = trimmedLast
        self.check = check
        self.items = []
    }
}

