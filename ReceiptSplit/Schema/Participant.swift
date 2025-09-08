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
    var firstName: String
    var lastName: String
    var phoneNumber: String?
    var createdAt: Date = Date()

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

    // Throwing initializer that validates and normalizes input
    init(firstName: String, lastName: String, phoneNumberAndRegion: (String, String)?) throws {
        // Validate names
        let trimmedFirst = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedFirst.isEmpty else { throw ValidationError.emptyFirstName }
        guard trimmedFirst.count <= Self.maxNameLength else {
            throw ValidationError.nameTooLong(field: "First name", max: Self.maxNameLength)
        }

        let trimmedLast = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedLast.isEmpty else { throw ValidationError.emptyLastName }
        guard trimmedLast.count <= Self.maxNameLength else {
            throw ValidationError.nameTooLong(field: "Last name", max: Self.maxNameLength)
        }

        self.firstName = trimmedFirst
        self.lastName = trimmedLast

        // Validate and normalize phone if provided
        if let phoneNumberAndRegion {
			let phoneNumberUtility = PhoneNumberUtility()
			guard phoneNumberUtility.isValidPhoneNumber(phoneNumberAndRegion.0, withRegion: phoneNumberAndRegion.1, ignoreType: true) else {
				throw ValidationError.invalidPhoneNumber
			}
        } else {
            self.phoneNumber = nil
        }
    }
}

