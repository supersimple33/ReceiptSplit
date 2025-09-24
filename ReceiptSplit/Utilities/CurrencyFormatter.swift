//
//  CurrencyFormatter.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/23/25.
//

import Foundation

class CurrencyFormatter: NumberFormatter, @unchecked Sendable {
    override init() {
        super.init()
        self.numberStyle = .currency
    }

    override func string(for obj: Any?) -> String? {
        if let number = obj as? NSNumber {
            return super.string(for: number.doubleValue / 100)
        }
        return super.string(for: obj)
    }

    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, range rangep: UnsafeMutablePointer<NSRange>?) throws {
        try unsafe super.getObjectValue(obj, for: string, range: rangep)
        if let obj = unsafe obj {
            if unsafe obj.pointee != nil {
                unsafe obj.pointee = unsafe NSNumber(value: (obj.pointee as! NSNumber).doubleValue * 100)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
