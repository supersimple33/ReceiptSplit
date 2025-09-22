//
//  Item.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/6/25.
//

import Foundation
import SwiftData
import FoundationModels

// A lightweight common interface that both persisted and generated items can share.
protocol Purchasable: Hashable {
    var name: String { get set }
    var price: Int { get set }
}

@Model
final class Item: Purchasable {
    var createdAt: Date = Date()
    var name: String
    var price: Int // cents
    var orderer: Participant?
    var check: Check

    init(name: String, price: Int, forCheck check: Check) {
        self.name = name
        self.price = price
        self.orderer = nil
        self.check = check
    }

    func setOrderer(_ orderer: Participant) {
        self.orderer = orderer
    }
}

@Generable(description: "A single item from the check")
struct GeneratedItem: Purchasable {
    @Guide(description: "The name of the item") // TODO: add regex
    var name: String
    @Guide(description: "The price of a quantity of this item in cents")
    var price: Int // cents
}
