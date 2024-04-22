//
//  PauseNode.swift
//  aviator_game
//
//  Created by Anton on 21/4/24.
//

import Foundation
import SpriteKit

class PauseNode: SKSpriteNode {
    
    private var backgroundPause: SKSpriteNode!
    private var backToLevelsBtn: SKSpriteNode!
    private var continuePlayBtn: SKSpriteNode!
    private var retryBtn: SKSpriteNode!
    
    var backToLevels: (() -> Void)?
    var continuePlay: (() -> Void)?
    var retry: (() -> Void)?
    
    init(color: UIColor, size: CGSize) {
        super.init(texture: nil, color: color, size: size)
        
        backgroundPause = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.5), size: CGSize(width: size.width, height: size.height))
        backgroundPause.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundPause.zPosition = 5
        addChild(backgroundPause)
        
        backToLevelsBtn = SKSpriteNode(imageNamed: "back_btn")
        backToLevelsBtn.position = CGPoint(x: size.width / 2 - 250, y: size.height / 2)
        backToLevelsBtn.size = CGSize(width: 250, height: 200)
        backToLevelsBtn.zPosition = 6
        addChild(backToLevelsBtn)
        
        continuePlayBtn = SKSpriteNode(imageNamed: "play_btn")
        continuePlayBtn.position = CGPoint(x: size.width / 2, y: size.height / 2)
        continuePlayBtn.size = CGSize(width: 250, height: 200)
        continuePlayBtn.zPosition = 6
        addChild(continuePlayBtn)
        
        retryBtn = SKSpriteNode(imageNamed: "retry_btn")
        retryBtn.position = CGPoint(x: size.width / 2 + 250, y: size.height / 2)
        retryBtn.size = CGSize(width: 250, height: 200)
        retryBtn.zPosition = 6
        addChild(retryBtn)
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        let location = touch.location(in: self)
        let objects = nodes(at: location)

        guard !objects.contains(backToLevelsBtn) else {
            backToLevels?()
            return
        }
        guard !objects.contains(continuePlayBtn) else {
            continuePlay?()
            return
        }
        guard !objects.contains(retryBtn) else {
            retry?()
            return
        }
    }
    
}
