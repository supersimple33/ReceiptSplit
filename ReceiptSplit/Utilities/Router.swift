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
        case analysis(image: CIImage)
        case overview(items: [GeneratedItem])
    }

    func navigateTo(route: Route) {
        navigationPath.append(route)
    }
}
