//
//  StoreItem.swift
//  aviator_game
//
//  Created by Anton on 20/4/24.
//

import Foundation

struct StoreItem {
    let name: String
    let type: StoreType
}

enum StoreType {
    case plane, back
}
