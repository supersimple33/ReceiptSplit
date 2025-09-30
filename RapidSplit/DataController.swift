//
//  DataController.swift
//  RapidSplit
//
//  Created by Addison Hanrattie on 9/9/25.
//

import Foundation
import SwiftData

@MainActor
class DataController {
    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(
                for: Check.self, Item.self, Participant.self, configurations: config)

            let check1 = try Check(name: "Friday Dinner")
            let alice = try Participant(firstName: "Alice", lastName: "Johnson", check: check1)
            let bob = try Participant(firstName: "Bob", lastName: "Smith", check: check1)

            let item1 = Item(name: "Margherita Pizza", price: 12.99, forCheck: check1)
            item1.orderers.append(alice)
            let item2 = Item(name: "Soda", price: 2.99, forCheck: check1)
            item2.orderers.append(bob)

            check1.participants = [alice, bob]
            check1.items = [item1, item2]

            container.mainContext.insert(check1)
            container.mainContext.insert(alice)
            container.mainContext.insert(bob)
            container.mainContext.insert(item1)
            container.mainContext.insert(item2)


            let check2 = try Check(name: "Lunch at Cafe")
            let charlie = try Participant(firstName: "Charlie", lastName: "Nguyen", check: check2)
            let dana = try Participant(firstName: "Dana", lastName: "Lee", check: check2)

            let item3 = Item(name: "Burger", price: 14.99, forCheck: check2)
            item3.orderers.append(charlie)
            let item4 = Item(name: "Fries", price: 4.99, forCheck: check2)
            item4.orderers.append(dana)
            let item5 = Item(name: "Milkshake", price: 5.99, forCheck: check2)
            item5.orderers.append(charlie)

            check2.participants = [charlie, dana]
            check2.items = [item3, item4, item5]


            container.mainContext.insert(check2)
            container.mainContext.insert(charlie)
            container.mainContext.insert(dana)
            container.mainContext.insert(item3)
            container.mainContext.insert(item4)
            container.mainContext.insert(item5)


            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
}
