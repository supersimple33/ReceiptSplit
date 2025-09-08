//
//  Check.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/6/25.
//

import Foundation
import SwiftData

@Model
final class Check {
    var createdAt: Date = Date()
    @Relationship(deleteRule: .cascade) var participants: [Participant]
    @Relationship(deleteRule: .cascade) var items: [Item]
    
    init(participants: [Participant] = [], items: [Item] = []) {
        self.participants = participants
        self.items = items
    }
}
