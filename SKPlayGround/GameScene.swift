//
//  GameScene.swift
//  SKPlayGround
//
//  Created by Jonathan Oh on 2/11/16.
//  Copyright (c) 2016 Jonathan Oh. All rights reserved.
//

import SpriteKit

//let playerCategory = 0x1

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //touchesBeganCounter is used to provide smoother player controls.  Will need a better solution.
    var touchesBeganCounter = 0
    var currentPlayer : PlayerSprite!
    var currentMap : GameMap!
    var currentLevel : LevelGenerator!
    
    //Define categories for contact notification to store in categoryBitMask (requires 32 bit unsigned)
    static let playerCategory : uint      = 0x1
    static let squareCategory : uint      = 0x1 << 1
    static let finishLevelCategory : uint = 0x1 << 2
    static let explosionCategory : uint   = 0x1 << 3
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = SKColor.whiteColor()
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0)
        self.physicsWorld.contactDelegate = self
        
        currentPlayer = PlayerSprite(parentFrame: self.frame)
        currentMap = GameMap(currentScene: self)
        
        currentLevel = LevelGenerator(currentMap: currentMap)
        
        self.addChild(currentPlayer.playerSprite)
        self.addChild(currentMap.mapContainer)
    }
    
    func killPlayerIfTouchNodeName(nodeName: String) {
        enumerateChildNodesWithName("//*") {
            node, stop in
            if (node.name == nodeName) {
                if (node.intersectsNode(self.currentPlayer.playerSprite) && !node.hidden) {
                    print("explode")
                }
            }
            
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchesBeganCounter++
        currentPlayer.playerSprite.removeAllActions()
        currentPlayer.updatePlayerPosition(self, touches: touches)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchesBeganCounter--
        if touchesBeganCounter == 0 {
            currentPlayer.playerSprite.removeAllActions()
        }
    }
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        killPlayerIfTouchNodeName("explosion")
    }
}
