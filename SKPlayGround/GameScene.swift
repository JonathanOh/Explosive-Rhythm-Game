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
    //var touchesBeganCounter = 0
    var currentPlayer : PlayerSprite!
    var currentMap : GameMap!
    var currentLevel : LevelGenerator!
    private var levelLabel : SKLabelNode!
    private var livesRemaininglabel : SKLabelNode!
    
    
    //Define categories for contact notification to store in categoryBitMask (requires 32 bit unsigned)
    static let playerCategory : uint      = 0x1
    static let squareCategory : uint      = 0x1 << 1
    static let finishLevelCategory : uint = 0x1 << 2
    static let explosionCategory : uint   = 0x1 << 3
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = SKColor.blackColor()
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0)
        self.physicsWorld.contactDelegate = self
        
        currentMap = GameMap(currentScene: self)
        currentPlayer = PlayerSprite(parentFrame: self.frame, currentMap: currentMap)
        
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
        
        //Current Level Node
        levelLabel = SKLabelNode(text: "Level: \(currentLevel.levelTracker)")
        levelLabel.position = CGPointMake(self.frame.width/7.5, self.frame.height/1.25)
        levelLabel.fontSize = 30
        levelLabel.fontColor = SKColor.whiteColor()
        self.addChild(levelLabel)
        
        //Lives Remaining Label
        livesRemaininglabel = SKLabelNode(text: "Lives: 10")
        livesRemaininglabel.position = CGPointMake(self.frame.width/6.5, self.frame.height/5.50)
        livesRemaininglabel.fontSize = 30
        livesRemaininglabel.fontColor = SKColor.whiteColor()
        self.addChild(livesRemaininglabel)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view!.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view!.addGestureRecognizer(swipeDown)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view!.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.view!.addGestureRecognizer(swipeUp)
        
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
                    self.currentPlayer.playerSprite.removeAllActions()
                    print("explode")
                    playerDied = true
                    stop.memory = true
                }
            }
            if (node.name == "finished") {
                if (node.intersectsNode(self.currentPlayer.playerSprite)) {
                    //trigger next level
                    self.currentPlayer.playerSprite.position = self.currentPlayer.defaultPlayerPosition
                    self.currentLevel.nextLevelHandler(self)
                    self.levelLabel.text = "Level: \(self.currentLevel.levelTracker)"
                    stop.memory = true
                }
            }
        }
        if playerDied {
            let bloodSplat = SKSpriteNode(imageNamed: "playerSplat")
            bloodSplat.size = CGSizeMake(90, 90)
            bloodSplat.position = self.currentPlayer.playerSprite.position
            bloodSplat.alpha = 0.60
            bloodSplat.zPosition = 1
            let fadeOut = SKAction.fadeOutWithDuration(2)
            self.addChild(bloodSplat)
            bloodSplat.runAction(fadeOut)
            bloodSplat
            let liveRemaining = self.currentPlayer.livesLeft()
            if liveRemaining > 0 {
                self.livesRemaininglabel.text = "Lives: \(liveRemaining)"
                self.currentPlayer.playerSprite.position = self.currentPlayer.defaultPlayerPosition
            } else {
                let gameOver = GameOver(size: self.size)
                gameOver.scaleMode = .AspectFill
                gameOver.backgroundColor = SKColor.blackColor()
                let newTransition = SKTransition.doorsCloseHorizontalWithDuration(1.5)
                self.view?.presentScene(gameOver, transition: newTransition)
            }
            
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (currentPlayer.playerSprite.position.y < self.frame.height - currentMap.heightOfSquare) {
            currentPlayer.moveUp(currentMap)
        }
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                if (currentPlayer.playerSprite.position.x < self.frame.width - currentMap.widthOfSquare) {
                    currentPlayer.moveRight(currentMap)
                }
            case UISwipeGestureRecognizerDirection.Down:
                if (currentPlayer.playerSprite.position.y > currentMap.heightOfSquare) {
                    currentPlayer.moveDown(currentMap)
                }
            case UISwipeGestureRecognizerDirection.Left:
                if (currentPlayer.playerSprite.position.x > currentMap.widthOfSquare) {
                    currentPlayer.moveLeft(currentMap)
                }
            case UISwipeGestureRecognizerDirection.Up:
                if (currentPlayer.playerSprite.position.y < self.frame.height - currentMap.heightOfSquare) {
                    currentPlayer.moveUp(currentMap)
                }
            default:
                break
            }
        }
    }
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        killPlayerIfTouchNodeName("explosion")
    }
}
