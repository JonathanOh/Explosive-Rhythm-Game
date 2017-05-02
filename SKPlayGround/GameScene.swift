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
    fileprivate var levelLabel : SKLabelNode!
    fileprivate var livesRemaininglabel : SKLabelNode!
    
    
    //Define categories for contact notification to store in categoryBitMask (requires 32 bit unsigned)
    static let playerCategory : uint      = 0x1
    static let squareCategory : uint      = 0x1 << 1
    static let finishLevelCategory : uint = 0x1 << 2
    static let explosionCategory : uint   = 0x1 << 3
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = SKColor.black
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self
        
        currentMap = GameMap(currentScene: self)
        currentPlayer = PlayerSprite(parentFrame: self.frame, currentMap: currentMap)
        
        currentLevel = LevelGenerator(currentMap: currentMap)
        
        self.addChild(currentPlayer.playerSprite)
        self.addChild(currentMap.mapContainer)
        
        //Finish Node
        let backGroundFinishNode = SKSpriteNode(color: SKColor.yellow, size: CGSize(width: self.frame.width/3, height: self.frame.height/20))
        let finishNode = SKLabelNode(text: "Move Here!")
        backGroundFinishNode.position = CGPoint(x: self.frame.width/2, y: self.frame.height/1.05)
        backGroundFinishNode.name = "finished"
        finishNode.fontColor = SKColor.black
        finishNode.fontName = "Verdana-Bold"
        finishNode.fontSize = 20
        finishNode.position = CGPoint(x: 0, y: -7)
        self.addChild(backGroundFinishNode)
        backGroundFinishNode.addChild(finishNode)
        
        //Current Level Node
        levelLabel = SKLabelNode(text: "Level: \(currentLevel.levelTracker)")
        levelLabel.position = CGPoint(x: self.frame.width/7.5, y: self.frame.height/1.25)
        levelLabel.fontSize = 30
        levelLabel.fontColor = SKColor.white
        self.addChild(levelLabel)
        
        //Lives Remaining Label
        livesRemaininglabel = SKLabelNode(text: "Lives: 10")
        livesRemaininglabel.position = CGPoint(x: self.frame.width/6.5, y: self.frame.height/5.50)
        livesRemaininglabel.fontSize = 30
        livesRemaininglabel.fontColor = SKColor.white
        self.addChild(livesRemaininglabel)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view!.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view!.addGestureRecognizer(swipeDown)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view!.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view!.addGestureRecognizer(swipeUp)
        
//        for familyName:AnyObject in UIFont.familyNames() {
//            print("Family Name: \(familyName)")
//            for fontName:AnyObject in UIFont.fontNamesForFamilyName(familyName as! String) {
//                print("--Font Name: \(fontName)")
//            }
//        }
        
    }
    
    func reconfigurePositionVariables() {
        self.currentPlayer.playerSprite.position = self.currentPlayer.defaultPlayerPosition
        self.currentPlayer.playerDestinationPos = self.currentPlayer.defaultPlayerPosition
    }
    
    func checkIfPlayerTouched(_ explosionNode: String, finishedNode: String) {
        var playerDied = false
        enumerateChildNodes(withName: "//*") {
            node, stop in
            if (node.name == explosionNode) {
                if (node.intersects(self.currentPlayer.playerSprite) && !node.isHidden) {
                    self.currentPlayer.playerSprite.removeAllActions()
                    print("explode")
                    playerDied = true
                    stop.pointee = true
                }
            }
            if (node.name == finishedNode) {
                if (node.intersects(self.currentPlayer.playerSprite)) {
                    //trigger next level
                    self.reconfigurePositionVariables()
                    self.currentLevel.nextLevelHandler(self)
                    self.levelLabel.text = "Level: \(self.currentLevel.levelTracker)"
                    stop.pointee = true
                }
            }
        }
        if playerDied {
            let bloodSplat = SKSpriteNode(imageNamed: "playerSplat")
            bloodSplat.size = CGSize(width: 90, height: 90)
            bloodSplat.position = self.currentPlayer.playerSprite.position
            bloodSplat.alpha = 0.60
            bloodSplat.zPosition = 1
            let fadeOut = SKAction.fadeOut(withDuration: 2)
            self.addChild(bloodSplat)
            bloodSplat.run(fadeOut)
            bloodSplat
            let liveRemaining = self.currentPlayer.livesLeft()
            if liveRemaining > 0 {
                self.livesRemaininglabel.text = "Lives: \(liveRemaining)"
                self.reconfigurePositionVariables()
            } else {
                let gameOver = GameOver(size: self.size)
                gameOver.scaleMode = .aspectFill
                gameOver.backgroundColor = SKColor.black
                let newTransition = SKTransition.doorsCloseHorizontal(withDuration: 1.5)
                self.view?.presentScene(gameOver, transition: newTransition)
            }
            
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if (currentPlayer.playerSprite.position.y < self.frame.height - currentMap.heightOfSquare) {
//            currentPlayer.moveUp(currentMap)
//        }
    }
    
    func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                if (currentPlayer.playerSprite.position.x < self.frame.width - currentMap.widthOfSquare) {
                    currentPlayer.moveRight(currentMap)
                }
            case UISwipeGestureRecognizerDirection.down:
                if (currentPlayer.playerSprite.position.y > currentMap.heightOfSquare) {
                    currentPlayer.moveDown(currentMap)
                }
            case UISwipeGestureRecognizerDirection.left:
                if (currentPlayer.playerSprite.position.x > currentMap.widthOfSquare) {
                    currentPlayer.moveLeft(currentMap)
                }
            case UISwipeGestureRecognizerDirection.up:
                if (currentPlayer.playerSprite.position.y < self.frame.height - currentMap.heightOfSquare) {
                    currentPlayer.moveUp(currentMap)
                }
            default:
                break
            }
        }
    }
    
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        checkIfPlayerTouched("explosion", finishedNode: "finished")
    }
}
