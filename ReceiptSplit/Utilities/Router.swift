//
//  Router.swift
//  ReceiptSplit
//
//  Created by Addison Hanrattie on 9/15/25.
//

import Foundation
import SwiftUI

@Observable
class Router {
    var navigationPath = NavigationPath()

    enum Route: Hashable {
        case capture
        case analysis(image: UIImage)
        case overview(title: String, items: [GeneratedItem])
        case participants(check: Check)
        case assignment(check: Check)
    }

    func navigateTo(route: Route) {
        navigationPath.append(route)
    }
}
