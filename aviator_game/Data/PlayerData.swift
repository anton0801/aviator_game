//
//  PlayerData.swift
//  aviator_game
//
//  Created by Anton on 20/4/24.
//

import Foundation

class PlayerData: ObservableObject {
    
    @Published var coins = UserDefaults.standard.integer(forKey: "coins") {
        didSet {
            UserDefaults.standard.set(coins, forKey: "coins")
        }
    }
    
    @Published var buyiedItems: [StoreItem] = []
    
    @Published var selectedPlane = UserDefaults.standard.string(forKey: "selected_plain") {
        didSet {
            UserDefaults.standard.set(selectedPlane, forKey: "selected_plain")
        }
    }
    @Published var selectedGameBack = UserDefaults.standard.string(forKey: "selected_game_back") {
        didSet {
            UserDefaults.standard.set(selectedGameBack, forKey: "selected_game_back")
        }
    }
    
    var allItems = [
        "game_back_1",
        "game_back_2",
        "game_back_3",
        "game_back_4",
        "game_back_5",
        "plane_1",
        "plane_2",
        "plane_3"
    ]
    
    var itemPrices = [
        "game_back_1": 0,
        "game_back_2": 100,
        "game_back_3": 100,
        "game_back_4": 100,
        "game_back_5": 100,
        "plane_1": 0,
        "plane_2": 100,
        "plane_3": 100
    ]
    
    init() {
        let storedBuyiedItems = UserDefaults.standard.string(forKey: "buyied_items_stored")?.components(separatedBy: ",") ?? []
        for storedItem in storedBuyiedItems {
            var typeItem: StoreType
            if storedItem.contains("game_back") {
                typeItem = .back
            } else {
                typeItem = .plane
            }
            buyiedItems.append(StoreItem(name: storedItem, type: typeItem))
        }
    }
    
    func buyItem(item: String) -> Bool {
        if coins >= itemPrices[item]! {
            var typeItem: StoreType
            if item.contains("game_back") {
                typeItem = .back
            } else {
                typeItem = .plane
            }
            buyiedItems.append(StoreItem(name: item, type: typeItem))
            UserDefaults.standard.set(buyiedItems.map { $0.name }.joined(separator: ","), forKey: "buyied_items_stored")
            return true
        }
        return false
    }
    
    func firstLaunchAndSetData() {
        buyiedItems.append(StoreItem(name: "game_back_1", type: .back))
        buyiedItems.append(StoreItem(name: "plane_1", type: .plane))
        selectedPlane = "plane_1"
        selectedGameBack = "game_back_1"
        UserDefaults.standard.set(buyiedItems.map { $0.name }.joined(separator: ","), forKey: "buyied_items_stored")
        UserDefaults.standard.set(true, forKey: "is_not_first_launch")
    }
    
    func selectItem(item: String) {
        if item.contains("game_back") {
            selectedGameBack = item
        } else {
            selectedPlane = item
        }
    }
    
}
