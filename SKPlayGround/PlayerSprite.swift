//
//  PlayerSprite.swift
//  SKPlayGround
//
//  Created by Jonathan Oh on 2/13/16.
//  Copyright © 2016 Jonathan Oh. All rights reserved.
//

import Foundation
import SpriteKit

class PlayerSprite {

    private var _playerSpeed : Double = 200
    private var _playerSprite = SKSpriteNode(imageNamed: "Spaceship")
    private var _playerSize = CGSize(width: 20, height: 20)
    
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
    
    init(parentFrame : CGRect) {
        _playerSprite.size = _playerSize
        self._playerSprite.position = CGPointMake(parentFrame.width/2, parentFrame.height/2)
    }

    func updatePlayerPosition(currentScene: GameScene, touches: Set<UITouch>) {
        let location = touches.first?.locationInNode(currentScene)
        let xDist = (self.playerSprite.position.x - location!.x)
        let yDist = (self.playerSprite.position.y - location!.y)
        let distanceOfPoints = sqrt(( xDist * xDist ) + ( yDist * yDist ))
        print(distanceOfPoints)
        let dynamicDistance : Double = (Double(distanceOfPoints) / self.playerSpeed)
        let actionMove = SKAction.moveTo(location!, duration: dynamicDistance)
        self.playerSprite.runAction(actionMove)
    }
    
}
