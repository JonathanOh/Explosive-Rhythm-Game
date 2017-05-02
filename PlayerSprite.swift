//
//  PlayerSprite.swift
//  SKPlayGround
//
//  Created by Jonathan Oh on 2/13/16.
//  Copyright © 2016 Jonathan Oh. All rights reserved.
//

import SpriteKit

class PlayerSprite {

    fileprivate var _playerSpeed : Double = 500
    fileprivate var _playerSprite = SKSpriteNode(imageNamed: "circleTest")
    fileprivate var _playerSize = CGSize(width: 20, height: 20)
    fileprivate var _livesRemaining = 10
    fileprivate var _defaultPlayerPosition = CGPoint(x: 0, y: 0)
    fileprivate var _playerDestinationPos : CGPoint?
    
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
    
    var defaultPlayerPosition : CGPoint {
        get {
            return _defaultPlayerPosition
        }
    }
    
    var playerDestinationPos : CGPoint {
        get {
            if let _playerDestinationPos = _playerDestinationPos {
                return _playerDestinationPos
            } else {
                _playerDestinationPos = _defaultPlayerPosition
                return _playerDestinationPos!
            }
        } set {
            if newValue == _defaultPlayerPosition {
                _playerDestinationPos = newValue
            }
        }
    }
    
    init(parentFrame : CGRect, currentMap : GameMap) {
        //Initializing player speed and size relative to screen size for consistent game play experience
        _playerSpeed = Double(parentFrame.width)/2
        //_playerSprite.size = CGSize(width: Double(parentFrame.width)/21.0, height: Double(parentFrame.width)/21.0)
        _playerSprite.size = CGSize(width: 20, height: 20)
        
        setPlayerPosition(parentFrame, currentMap: currentMap)

        _playerSprite.zPosition = 5
        _playerSprite.physicsBody = SKPhysicsBody(circleOfRadius: _playerSize.width/2)
        _playerSprite.physicsBody?.categoryBitMask = GameScene.playerCategory
        _playerSprite.physicsBody?.contactTestBitMask = GameScene.squareCategory
        _playerSprite.physicsBody?.collisionBitMask = GameScene.finishLevelCategory
    }
    
    func setPlayerPosition(_ parentFrame: CGRect, currentMap: GameMap) {
        if currentMap.col % 2 == 1 && currentMap.row % 2 == 1 {
            _playerSprite.position = CGPoint(x: parentFrame.width/2, y: parentFrame.height/2 - (currentMap.halfOfMapHeight + currentMap.heightOfSquare/2))
        } else if currentMap.col % 2 == 0 && currentMap.row % 2 == 0 {
            _playerSprite.position = CGPoint(x: (parentFrame.width/2 - currentMap.widthOfSquare/2), y: (parentFrame.height/2 - (currentMap.halfOfMapHeight + currentMap.heightOfSquare/2)))
        } else if currentMap.col % 2 == 1 && currentMap.row % 2 == 0 {
            _playerSprite.position = CGPoint(x: parentFrame.width/2, y: parentFrame.height/2 - (currentMap.halfOfMapHeight + currentMap.heightOfSquare/2))
        } else {
            _playerSprite.position = CGPoint(x: parentFrame.width/2 - currentMap.widthOfSquare/2, y: parentFrame.height/2 - (currentMap.halfOfMapHeight + currentMap.heightOfSquare/2))
        }
        _defaultPlayerPosition = _playerSprite.position
        _playerDestinationPos = _playerSprite.position
    }
    
    func updatePlayerPosition(_ currentScene: GameScene, touches: Set<UITouch>) {
        if let location = touches.first?.location(in: currentScene) {
            let xDist = (self.playerSprite.position.x - location.x)
            let yDist = (self.playerSprite.position.y - location.y)
            let distanceOfPoints = sqrt(( xDist * xDist ) + ( yDist * yDist ))
            let dynamicDistance : Double = (Double(distanceOfPoints) / self.playerSpeed)
            let actionMove = SKAction.move(to: location, duration: dynamicDistance) //this may behave weird if playerSprite is blocked by walls
            self.playerSprite.run(actionMove)
        } else {
            print("No Location Found!")
        }
    }
    
    func isPlayerMoveable() -> Bool {
        if fabs(_playerSprite.position.x - (_playerDestinationPos?.x)!) < 0.001 && fabs(_playerSprite.position.y - (_playerDestinationPos?.y)!) < 0.001 {
            return true
        } else {
            return false
        }
    }
    
    func configureWithNewPos(_ position: CGPoint) -> SKAction {
        _playerDestinationPos = position
        let moveNodeAction = SKAction.move(to: position, duration: 0.1)
        return moveNodeAction
    }
    
    func moveUp(_ currentMap : GameMap) {
        if self.isPlayerMoveable() {
            let newPos = CGPoint(x: self.playerSprite.position.x, y: self.playerSprite.position.y + currentMap.heightOfSquare)
            let moveAction = configureWithNewPos(newPos)
            self.playerSprite.run(moveAction)
        }
    }
    func moveDown(_ currentMap : GameMap) {
        if self.isPlayerMoveable() {
            let newPos = CGPoint(x: self.playerSprite.position.x, y: self.playerSprite.position.y - currentMap.heightOfSquare)
            let moveAction = configureWithNewPos(newPos)
            self.playerSprite.run(moveAction)
        }
    }
    func moveLeft(_ currentMap : GameMap) {
        if self.isPlayerMoveable() {
            let newPos = CGPoint(x: self.playerSprite.position.x - currentMap.widthOfSquare, y: self.playerSprite.position.y)
            let moveAction = configureWithNewPos(newPos)
            self.playerSprite.run(moveAction)
        }
    }
    func moveRight(_ currentMap : GameMap) {
        if self.isPlayerMoveable() {
            let newPos = CGPoint(x: self.playerSprite.position.x + currentMap.widthOfSquare, y: self.playerSprite.position.y)
            let moveAction = configureWithNewPos(newPos)
            self.playerSprite.run(moveAction)
        }
    }
    
    func livesLeft() -> Int {
        _livesRemaining -= 1
        if _livesRemaining <= 0 {
            removePlayerFromGame()
        }
        return _livesRemaining
    }
    
    func removePlayerFromGame() {
        playerSprite.removeFromParent()
    }
    
}
