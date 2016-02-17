//
//  PlayerSprite.swift
//  SKPlayGround
//
//  Created by Jonathan Oh on 2/13/16.
//  Copyright © 2016 Jonathan Oh. All rights reserved.
//

import SpriteKit

class PlayerSprite {

    private var _playerSpeed : Double = 500
    private var _playerSprite = SKSpriteNode(imageNamed: "circleTest")
    private var _playerSize = CGSize(width: 20, height: 20)
    private var _livesRemaining = 10
    
    var playerSpeed : Double {
        get {
            return _playerSpeed
        }
        set {
            if newValue == 100 || newValue == 150 || newValue == 200 || newValue == 500 {
                _playerSpeed = newValue
            }
        }
    }
    
    var playerSprite : SKSpriteNode {
        get {
            return _playerSprite
        }
    }
    
    var playerSize : CGSize {
        get {
            return _playerSize
        }
    }
    
    init(parentFrame : CGRect) {
        //Initializing player speed and size relative to screen size for consistent game play experience
        _playerSpeed = Double(parentFrame.width)/2
        //_playerSprite.size = CGSize(width: Double(parentFrame.width)/21.0, height: Double(parentFrame.width)/21.0)
        _playerSprite.size = CGSize(width: 20, height: 20)
        _playerSprite.position = CGPointMake(parentFrame.width/2, parentFrame.height/10)
        _playerSprite.zPosition = 5
        _playerSprite.physicsBody = SKPhysicsBody(circleOfRadius: _playerSize.width/2)
        _playerSprite.physicsBody?.categoryBitMask = GameScene.playerCategory
        _playerSprite.physicsBody?.contactTestBitMask = GameScene.squareCategory
        _playerSprite.physicsBody?.collisionBitMask = GameScene.finishLevelCategory
    }

    func updatePlayerPosition(currentScene: GameScene, touches: Set<UITouch>) {
        if let location = touches.first?.locationInNode(currentScene) {
            let xDist = (self.playerSprite.position.x - location.x)
            let yDist = (self.playerSprite.position.y - location.y)
            let distanceOfPoints = sqrt(( xDist * xDist ) + ( yDist * yDist ))
            let dynamicDistance : Double = (Double(distanceOfPoints) / self.playerSpeed)
            let actionMove = SKAction.moveTo(location, duration: dynamicDistance) //this may behave weird if playerSprite is blocked by walls
            self.playerSprite.runAction(actionMove)
        } else {
            print("No Location Found!")
        }
    }
    
    func livesLeft() -> Int {
        _livesRemaining--
        if _livesRemaining <= 0 {
            removePlayerFromGame()
        }
        return _livesRemaining
    }
    
    func removePlayerFromGame() {
        playerSprite.removeFromParent()
    }
    
}
