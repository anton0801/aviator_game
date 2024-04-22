//
//  LoseNode.swift
//  aviator_game
//
//  Created by Anton on 22/4/24.
//

import Foundation
import SpriteKit

class LoseNode: SKSpriteNode {
    
   private var backgroundPause: SKSpriteNode!
   private var retryBtn: SKSpriteNode!
   private var timeLeftLabel: SKLabelNode!
   private var gainedPointsLabel: SKLabelNode!
   private var backBtn: SKSpriteNode!
   
   private var points: Int
   private var timePassed: Int
   
    var backToLevels: (() -> Void)?
    var retry: (() -> Void)?
    
   init(color: UIColor, size: CGSize, gainedPointsInGame: Int, timePassed: Int) {
       self.points = gainedPointsInGame
       self.timePassed = timePassed
       
       super.init(texture: nil, color: color, size: size)
       
       backgroundPause = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.5), size: CGSize(width: size.width, height: size.height))
       backgroundPause.position = CGPoint(x: size.width / 2, y: size.height / 2)
       backgroundPause.zPosition = 5
       addChild(backgroundPause)
       
       let backgroundWin = SKSpriteNode(imageNamed: "lose_window")
       backgroundWin.position = CGPoint(x: size.width / 2, y: size.height / 2)
       backgroundWin.size = CGSize(width: 800, height: 500)
       backgroundWin.zPosition = 6
       addChild(backgroundWin)
       
       timeLeftLabel = SKLabelNode(text: "+\(gainedPointsInGame)")
       timeLeftLabel.fontName = "jsMath-cmbx10"
       timeLeftLabel.fontSize = 42
       timeLeftLabel.fontColor = .white
       timeLeftLabel.zPosition = 7
       timeLeftLabel.position = CGPoint(x: size.width / 2 - 300, y: size.height / 2 - 95)
       addChild(timeLeftLabel)
       
       let iconCoin = SKSpriteNode(imageNamed: "ic_coin")
       iconCoin.size = CGSize(width: 60, height: 82)
       iconCoin.position = CGPoint(x: size.width / 2 - 210, y: size.height / 2 - 80)
       iconCoin.zPosition = 7
       addChild(iconCoin)
       
       retryBtn = SKSpriteNode(imageNamed: "retry_btn")
       retryBtn.size = CGSize(width: 100, height: 82)
       retryBtn.position = CGPoint(x: size.width / 2 + 260, y: size.height / 2 - 80)
       retryBtn.zPosition = 7
       addChild(retryBtn)
       
       let timePassedBg = SKSpriteNode(imageNamed: "time_lose_bg")
       timePassedBg.position = CGPoint(x: size.width / 2, y: size.height / 2 - 80)
       timePassedBg.zPosition = 7
       timePassedBg.alpha = 0.7
       addChild(timePassedBg)
       
       let timePassedLabel = SKLabelNode(text: "\(self.secondsToMinutesAndSeconds(timePassed))")
       timePassedLabel.fontName = "jsMath-cmbx10"
       timePassedLabel.fontSize = 42
       timePassedLabel.fontColor = .white
       timePassedLabel.zPosition = 8
       timePassedLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 - 95)
       addChild(timePassedLabel)
       
       backBtn = SKSpriteNode(imageNamed: "back_large")
       backBtn.position = CGPoint(x: size.width / 2, y: 100)
       backBtn.zPosition = 7
       backBtn.size = CGSize(width: 200, height: 80)
       
       addChild(backBtn)
       
       isUserInteractionEnabled = true
   }
   
   required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
   
   private func secondsToMinutesAndSeconds(_ seconds: Int) -> String {
       let minutes = seconds / 60
       let seconds = seconds % 60
       return String(format: "%02d:%02d", minutes, seconds)
   }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        let location = touch.location(in: self)
        let objects = nodes(at: location)

        guard !objects.contains(backBtn) else {
            backToLevels?()
            return
        }
        guard !objects.contains(retryBtn) else {
            retry?()
            return
        }
    }
    
}
