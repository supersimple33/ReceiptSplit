//
//  Item.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/6/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var createdAt: Date = Date()
    var name: String
    var price: Int // cents
	
    init(name: String, price: Int) {
        self.name = name
        self.price = price
    }
}
	
