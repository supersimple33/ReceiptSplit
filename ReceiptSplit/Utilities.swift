//
//  Utilities.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/9/25.
//

import Foundation

public extension Collection {
  func enumeratedArray() -> Array<(offset: Int, element: Self.Element)> {
    return Array(self.enumerated())
  }
}