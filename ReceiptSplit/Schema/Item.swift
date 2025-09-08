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
	
