//
//  PlaneRescueGameScene.swift
//  aviator_game
//
//  Created by Anton on 21/4/24.
//

import Foundation
import SpriteKit
import SwiftUI

class PlaneRescueGameScene: SKScene, SKPhysicsContactDelegate {
    
    private var gameUniqId = UUID().uuidString
    
    var level = "level_1"
    private var gameObstaclesCountMax: Int {
        get {
            return GameDataLevels.countLevelObstacles[level]!
        }
    }
    private var obstaclesPresented = 0
    
    var coinSpawnTimer = Timer()
    var gameTimer = Timer()
    
    var plane: SKSpriteNode!
    
    var timeLabel: SKLabelNode!
    var timePassed: Int = 0
    var timeLeft: Int = 120 {
        didSet {
            timeLabel.text = "\(self.secondsToMinutesAndSeconds(timeLeft))"
        }
    }
    
    var allCoinsLabel: SKLabelNode!
    var allCoins = UserDefaults.standard.integer(forKey: "coins") {
        didSet {
            UserDefaults.standard.set(allCoins, forKey: "coins")
            allCoinsLabel.text = "\(allCoins)"
        }
    }
    
    var coinsGainedInGameLabel: SKLabelNode!
    var coinsGainedInGame = 0 {
        didSet {
            coinsGainedInGameLabel.text = "\(coinsGainedInGame)"
        }
    }
    
    private var planeBtnUp: SKSpriteNode!
    private var planeBtnDown: SKSpriteNode!
    private var pauseBtn: SKSpriteNode!
    
    private var prevObstaclePosX: Int = -1
    private var obstacles: [SKNode] = []
    private var coin: SKSpriteNode? = nil
    
    private func secondsToMinutesAndSeconds(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        size = CGSize(width: 1335, height: 750)
        
        drawBackground()
        drawSubItems()
        createPlane()
        
        timeLeft = gameObstaclesCountMax * 15 + 30
        gameTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(gameTimeUp), userInfo: nil, repeats: true)
    }
    
    @objc private func gameTimeUp() {
        if !isPaused {
            timePassed += 1
            timeLeft -= 1
            if timeLeft == 0 {
                loseGame()
            }
        }
    }
    
    private func drawSubItems() {
        timeLabel = SKLabelNode(text: "02:00")
        timeLabel.fontName = "jsMath-cmbx10"
        timeLabel.fontSize = 72
        timeLabel.fontColor = .white
        timeLabel.position = CGPoint(x: size.width / 2, y: size.height - 100)
        addChild(timeLabel)
        
        allCoinsLabel = SKLabelNode(text: "\(allCoins)")
        allCoinsLabel.fontName = "jsMath-cmbx10"
        allCoinsLabel.fontSize = 42
        allCoinsLabel.fontColor = .white
        allCoinsLabel.position = CGPoint(x: size.width - 200, y: size.height - 90)
        addChild(allCoinsLabel)
        
        let coinsIconNode = SKSpriteNode(imageNamed: "ic_coin")
        coinsIconNode.position = CGPoint(x: size.width - 120, y: size.height - 80)
        coinsIconNode.size = CGSize(width: 102, height: 122)
        addChild(coinsIconNode)
        
        coinsGainedInGameLabel = SKLabelNode(text: "\(coinsGainedInGame)")
        coinsGainedInGameLabel.fontName = "jsMath-cmbx10"
        coinsGainedInGameLabel.fontSize = 42
        coinsGainedInGameLabel.fontColor = .white
        coinsGainedInGameLabel.position = CGPoint(x: size.width / 2 - 20, y: size.height - 165)
        addChild(coinsGainedInGameLabel)
        
        let coinsIconNode2 = SKSpriteNode(imageNamed: "ic_coin")
        coinsIconNode2.position = CGPoint(x: size.width / 2 + 30, y: size.height - 150)
        coinsIconNode2.size = CGSize(width: 52, height: 72)
        addChild(coinsIconNode2)
        
        pauseBtn = SKSpriteNode(imageNamed: "pause_btn")
        pauseBtn.position = CGPoint(x: 140, y: size.height - 100)
        pauseBtn.size = CGSize(width: 180, height: 160)
        addChild(pauseBtn)
        
        planeBtnUp = SKSpriteNode(imageNamed: "btn_up")
        planeBtnUp.position = CGPoint(x: size.width - 150, y: 80)
        planeBtnUp.size = CGSize(width: 150, height: 130)
        addChild(planeBtnUp)
        
        planeBtnDown = SKSpriteNode(imageNamed: "btn_down")
        planeBtnDown.position = CGPoint(x: 150, y: 80)
        planeBtnDown.size = CGSize(width: 150, height: 130)
        addChild(planeBtnDown)
    }
    
    private func createPlane() {
        plane = SKSpriteNode(imageNamed: UserDefaults.standard.string(forKey: "selected_plain") ?? "plane_1")
        plane.size = CGSize(width: 250, height: 190)
        plane.position = CGPoint(x: 100, y: size.height / 2)
        plane.physicsBody = SKPhysicsBody(rectangleOf: plane.size)
        plane.physicsBody?.isDynamic = false
        plane.physicsBody?.affectedByGravity = false
        plane.physicsBody?.categoryBitMask = PlaneRescueData.plane
        plane.physicsBody?.contactTestBitMask = PlaneRescueData.obstacle | PlaneRescueData.coin
        plane.physicsBody?.collisionBitMask = PlaneRescueData.obstacle | PlaneRescueData.coin
        plane.name = "plane"
        addChild(plane)
        
        movePlane()
    }
    
    private func movePlane() {
        for obstacle in obstacles {
            obstacle.removeFromParent()
        }
        obstacles = []
        coin?.removeFromParent()
        coin = nil
        
        if obstaclesPresented >= gameObstaclesCountMax {
            let flag = SKSpriteNode(imageNamed: "ic_flag")
            flag.position = CGPoint(x: Int(size.width) - 200, y: Int.random(in: 250...Int(size.height - 300)))
            flag.size = CGSize(width: 150, height: 150)
            addChild(flag)
            
            let finishFlagField = SKSpriteNode(color: .green, size: CGSize(width: 120, height: 10))
            finishFlagField.position = CGPoint(x: flag.position.x - flag.size.width / 4, y: flag.position.y - flag.size.height / 2)
            addChild(finishFlagField)
            
            let movingPlaneAction = SKAction.moveTo(x: flag.position.x, duration: 7.0)
            plane.position = CGPoint(x: -100, y: size.height / 2)
            plane.run(movingPlaneAction) { [weak self] in
                self?.winGame()
            }
        } else {
            let movingPlaneAction = SKAction.moveTo(x: size.width + 100, duration: Double(Int.random(in: 12...16)))
            plane.position = CGPoint(x: -100, y: size.height / 2)
            plane.run(movingPlaneAction) { [weak self] in
                self?.prevObstaclePosX = -1
                self?.movePlane()
            }
            
            createObstacles()
            createObstacles()
            spawnCoinIfNeeded()
            
            obstaclesPresented += 1
        }
    }
    
    private func spawnCoinIfNeeded() {
        if Bool.random() {
            coin = SKSpriteNode(imageNamed: "ic_coin")
            coin!.position = CGPoint(x: Int.random(in: Int(obstacles[0].position.x)...Int(obstacles[1].position.x) - 100), y: Int.random(in: 250...Int(size.height) - 250))
            coin!.size = CGSize(width: 90, height: 110)
            let radius = coin!.size.width / 2
            coin!.physicsBody = SKPhysicsBody(circleOfRadius: radius)
            coin!.physicsBody?.isDynamic = true
            coin!.physicsBody?.affectedByGravity = false
            coin!.physicsBody?.categoryBitMask = PlaneRescueData.coin
            coin!.physicsBody?.contactTestBitMask = PlaneRescueData.plane
            coin!.physicsBody?.collisionBitMask = PlaneRescueData.plane
            addChild(coin!)
        }
    }
    
    private func drawBackground() {
        let background = SKSpriteNode(imageNamed: UserDefaults.standard.string(forKey: "selected_game_back") ?? "game_back_1")
        background.zPosition = -1
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.alpha = 0.8
        addChild(background)
        
        let blackSprite = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.2), size: CGSize(width: size.width, height: size.height))
        blackSprite.position = CGPoint(x: size.width / 2, y: size.height / 2)
        blackSprite.zPosition = 0
        addChild(blackSprite)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        
        guard !objects.contains(planeBtnUp) else {
            let moveUp = SKAction.moveTo(y: plane.position.y + 50, duration: 0.2)
            let rotateAction = SKAction.rotate(toAngle: 0.35, duration: 0.2)
            let sequence = SKAction.sequence([rotateAction, moveUp])
            plane.run(sequence)
            return
        }
        
        guard !objects.contains(planeBtnDown) else {
            let moveDown = SKAction.moveTo(y: plane.position.y - 50, duration: 0.2)
            let rotateAction = SKAction.rotate(toAngle: -0.35, duration: 0.2)
            let sequence = SKAction.sequence([rotateAction, moveDown])
            plane.run(sequence)
            return
        }
        
        guard !objects.contains(pauseBtn) else {
            isPaused = true
            createPauseMenu()
            return
        }
    }
    
    private func createObstacles() {
        let obstacle = SKSpriteNode(color: .green, size: CGSize(width: 10, height: 160))
        obstacle.position = CGPoint(x: prevObstaclePosX + 250 + Int.random(in: 200...300), y: Int.random(in: 250...Int(size.height) - 250))
        prevObstaclePosX = Int(obstacle.position.x)
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = true
        obstacle.physicsBody?.affectedByGravity = false
        obstacle.physicsBody?.categoryBitMask = PlaneRescueData.obstacle
        obstacle.physicsBody?.contactTestBitMask = PlaneRescueData.plane
        obstacle.physicsBody?.collisionBitMask = PlaneRescueData.plane
        obstacle.name = "obstacle"
        addChild(obstacle)
        obstacles.append(obstacle)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if contact.bodyA.categoryBitMask == PlaneRescueData.plane && contact.bodyB.categoryBitMask == PlaneRescueData.coin {
            nodeB.removeFromParent()
            coinsGainedInGame += 1
            let claimCoinId = UUID().uuidString
            NotificationCenter.default.post(name: Notification.Name("COIN_ADD"), object: nil, userInfo: ["id": claimCoinId])
            allCoins += 1
            
            if UserDefaults.standard.bool(forKey: "sounds_enabled") {
              addSoundEffect(for: .claim)
            }
        }
        
        if contact.bodyA.categoryBitMask == PlaneRescueData.plane && contact.bodyB.categoryBitMask == PlaneRescueData.obstacle {
            nodeA.removeFromParent()
            nodeB.removeFromParent()
            
            if let fileParticles = SKEmitterNode(fileNamed: "Expl") {
                fileParticles.position.x = nodeA.position.x
                fileParticles.position.y = nodeA.position.y
                addChild(fileParticles)
                
                if UserDefaults.standard.bool(forKey: "sounds_enabled") {
                    addSoundEffect(for: .explosion)
                }
                
                loseGame()
            }
        }
    }
    
    private func loseGame() {
        isPaused = true
        let loseNode = LoseNode(color: .clear, size: size, gainedPointsInGame: coinsGainedInGame, timePassed: timePassed)
        loseNode.retry = {
            self.retryLevelGame()
        }
        loseNode.backToLevels = {
            NotificationCenter.default.post(name: Notification.Name("BACK_ACTION"), object: nil, userInfo: nil)
        }
        addChild(loseNode)
    }
    
    private func winGame() {
        isPaused = true
        let winGame = WinNode(color: .clear, size: size, gainedPointsInGame: coinsGainedInGame, timePassed: timePassed)
        winGame.retry = {
            self.retryLevelGame()
        }
        winGame.backToLevels = {
            NotificationCenter.default.post(name: Notification.Name("BACK_ACTION"), object: nil, userInfo: nil)
        }
        NotificationCenter.default.post(name: Notification.Name("UNLOCK_LEVEL"), object: nil, userInfo: nil)
        if timePassed < UserDefaults.standard.integer(forKey: "record_\(level)") || UserDefaults.standard.integer(forKey: "record_\(level)") == 0 {
            NotificationCenter.default.post(name: Notification.Name("NEW_RECORD"), object: nil, userInfo: ["time": timePassed, "id": gameUniqId])
        }
        addChild(winGame)
    }
    
    private func addSoundEffect(for file: GameAudio) {
        let soundAction = SKAction.playSoundFileNamed(file.rawValue, waitForCompletion: false)
        run(soundAction)
    }
    
    private var pauseNode: PauseNode?
    
    private func createPauseMenu() {
        pauseNode = PauseNode(color: .clear, size: size)
        pauseNode?.continuePlay = {
            self.isPaused = false
            self.closePauseMenu()
        }
        pauseNode?.retry = {
            self.retryLevelGame()
        }
        pauseNode?.backToLevels = {
            NotificationCenter.default.post(name: Notification.Name("BACK_ACTION"), object: nil, userInfo: nil)
        }
        addChild(pauseNode!)
    }
    
    private func closePauseMenu() {
        pauseNode?.removeFromParent()
        pauseNode = nil
    }
    
    private func retryLevelGame() {
        let newScene = PlaneRescueGameScene()
        newScene.level = self.level
        newScene.size = CGSize(width: 1335, height: 750)
        newScene.scaleMode = .fill
        self.view?.presentScene(newScene)
    }
    
}

struct PlaneRescueData {
    static let plane: UInt32 = 0x101
    static let obstacle: UInt32 = 0x101001
    static let coin: UInt32 = 0x01100
}

enum GameAudio: String {
    case claim = "claimCoins"
    case explosion = "explosionSound"
}

#Preview {
    VStack {
        SpriteView(scene: PlaneRescueGameScene())
            .ignoresSafeArea()
    }
}
