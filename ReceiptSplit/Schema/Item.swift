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
    var price: Decimal { get set }
}

@Model
final class Item: Purchasable {
    var createdAt: Date = Date()
    var name: String
    var price: Decimal // cents
    @Relationship(deleteRule: .nullify) var orderers: [Participant]
    var check: Check

    init(name: String, price: Decimal, forCheck check: Check) {
        self.name = name
        self.price = price
        self.orderers = []
        self.check = check
    }

    init(item: any Purchasable, forCheck check: Check) {
        self.name = item.name
        self.price = item.price
        self.orderers = []
        self.check = check
    }
}

@Generable(description: "A single item from the check")
struct GeneratedItem: Purchasable {
    @Guide(description: "The name of the item") // TODO: add regex
    var name: String
    @Guide(description: "The price of a the given item", .minimum(0))
    var price: Decimal
    @Guide(description: "The quantity of this item bought", .minimum(0))
    var quantity: Int
}
