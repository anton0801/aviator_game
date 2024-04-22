//
//  PlaneRescueGameView.swift
//  aviator_game
//
//  Created by Anton on 20/4/24.
//

import SwiftUI
import SpriteKit

struct PlaneRescueGameView: View {
    
    @Environment(\.presentationMode) var presentMode
    
    @EnvironmentObject var playerData: PlayerData
    @EnvironmentObject var levelsData: LevelsData
    
    var level: String
    
    @State var gameId = ""
    @State var coinAdId = ""
    var recordsData = RecordsData()
    
    private var planeRescueGameScene: PlaneRescueGameScene {
        get {
            let gameScene = PlaneRescueGameScene()
            gameScene.level = self.level
            return gameScene
        }
    }
    
    var body: some View {
        VStack {
            SpriteView(scene: planeRescueGameScene)
                .ignoresSafeArea()
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("NEW_RECORD"))) { notification in
                    if let gameId = notification.userInfo?["id"] as? String,
                       let time = notification.userInfo?["time"] as? Int {
                            if gameId != self.gameId {
                                recordsData.insertRecord(level: level, time: time)
                                self.gameId = gameId
                            }
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("BACK_ACTION"))) { notification in
                    presentMode.wrappedValue.dismiss()
                }
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("UNLOCK_LEVEL"))) { notification in
                    levelsData.unlockNextLevel(currentLevel: level)
                }
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("COIN_ADD"))) { notification in
                    if let id = notification.userInfo?["id"] as? String {
                        if coinAdId != id {
                            playerData.coins += 1
                            coinAdId = id
                        }
                    }
                }
        }.onAppear {
            AppDelegate.orientationLock = .landscape
        }
        .onDisappear {
            AppDelegate.orientationLock = .portrait
        }
    }
}

#Preview {
    PlaneRescueGameView(level: "level_1")
        .environmentObject(PlayerData())
        .environmentObject(LevelsData())
}
