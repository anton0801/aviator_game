//
//  LevelsData.swift
//  aviator_game
//
//  Created by Anton on 20/4/24.
//

import Foundation

class LevelsData: ObservableObject {
    
    @Published var allLevels: [String] = []
    @Published var unlockedLevels: [String] = []
    
    init() {
        let unlockedLevelsSaved = UserDefaults.standard.string(forKey: "unlocked_levels") ?? "level_1,"
        let components = unlockedLevelsSaved.components(separatedBy: ",")
        for level in components {
            unlockedLevels.append(level)
        }
        if unlockedLevels.isEmpty {
            unlockedLevels.append("level_1")
        }
        
        for level in 1...12 {
            allLevels.append("level_\(level)")
        }
    }
    
    func unlockNextLevel(currentLevel: String) {
        let levelNum = Int(currentLevel.components(separatedBy: "_")[1])!
        let nextLevelNum = levelNum + 1
        if nextLevelNum < 12 {
            unlockedLevels.append("level_\(nextLevelNum)")
            UserDefaults.standard.set(unlockedLevels.joined(separator: ","), forKey: "unlocked_levels")
        }
    }
    
}
