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
        
        //Finish Node
        let backGroundFinishNode = SKSpriteNode(color: SKColor.yellowColor(), size: CGSizeMake(self.frame.width/3, self.frame.height/20))
        let finishNode = SKLabelNode(text: "Move Here!")
        backGroundFinishNode.position = CGPointMake(self.frame.width/2, self.frame.height/1.05)
        backGroundFinishNode.name = "finished"
        finishNode.fontColor = SKColor.blackColor()
        finishNode.fontName = "Verdana-Bold"
        finishNode.fontSize = 20
        finishNode.position = CGPointMake(0, -7)
        self.addChild(backGroundFinishNode)
        backGroundFinishNode.addChild(finishNode)
        
//        for familyName:AnyObject in UIFont.familyNames() {
//            print("Family Name: \(familyName)")
//            for fontName:AnyObject in UIFont.fontNamesForFamilyName(familyName as! String) {
//                print("--Font Name: \(fontName)")
//            }
//        }
        
    }
    
    func killPlayerIfTouchNodeName(nodeName: String) {
        var playerDied = false
        enumerateChildNodesWithName("//*") {
            node, stop in
            if (node.name == nodeName) {
                if (node.intersectsNode(self.currentPlayer.playerSprite) && !node.hidden) {
                    print("explode")
                    playerDied = true
                    stop.memory = true
                }
            }
            if (node.name == "finished") {
                if (node.intersectsNode(self.currentPlayer.playerSprite)) {
                    //trigger next level
                    self.currentPlayer.playerSprite.position = CGPointMake(self.frame.width/2, self.frame.height/10)
                    self.currentLevel.nextLevelHandler(self)
                    stop.memory = true
                }
            }
        }
        if playerDied {
            let bloodSplat = SKSpriteNode(imageNamed: "playerSplat")
            bloodSplat.size = CGSizeMake(90, 90)
            bloodSplat.position = self.currentPlayer.playerSprite.position
            bloodSplat.zPosition = 1
            self.addChild(bloodSplat)
            self.currentPlayer.playerHasDied()
            
            let gameOver = GameOver(size: self.size)
            gameOver.scaleMode = .AspectFill
            gameOver.backgroundColor = SKColor.blackColor()
            let newTransition = SKTransition.doorsCloseHorizontalWithDuration(1.5)
            self.view?.presentScene(gameOver, transition: newTransition)
            
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
