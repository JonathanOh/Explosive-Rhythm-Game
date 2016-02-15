//
//  GameScene.swift
//  SKPlayGround
//
//  Created by Jonathan Oh on 2/11/16.
//  Copyright (c) 2016 Jonathan Oh. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    //touchesBeganCounter is used to provide smoother player controls.  Will need a better solution.
    var touchesBeganCounter = 0
    var currentPlayer : PlayerSprite!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = SKColor.whiteColor()
        
        currentPlayer = PlayerSprite(parentFrame: self.frame)
        
        self.addChild(currentPlayer.playerSprite)
        
        //MAP Needs to be refactored to its own class
        print(self.frame.width)
        print(self.frame.height)
        let map = SKSpriteNode(color: UIColor.blueColor(), size: CGSizeMake(self.frame.width, self.frame.width))
        map.position = CGPointMake(self.frame.width/2, self.frame.height/2)
        self.addChild(map)
        
        //CHECKER BOARD
        let row = 10
        let height = 10
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        let widthOfSquare = map.frame.width/CGFloat(row)
        let heightOfSquare = map.frame.height/CGFloat(height)
        let halfOfMapWidth = map.frame.width/2
        let halfOfMapHeight = map.frame.height/2
        
        print(map.frame.width)
        print(map.frame.height)
//        let checker = SKSpriteNode(color: UIColor.yellowColor(), size: CGSizeMake(map.frame.width/10, map.frame.height/10))
//        checker.position = CGPointMake(-map.frame.width/2 + checker.frame.width/2, -map.frame.height/2 + checker.frame.height/2)
//        map.addChild(checker)
        for numHeight in 1...height {
            for numRow in 1...row {
                let colorOfSquare = (numRow + numHeight) % 2 == 0 ? SKColor.redColor() : SKColor.blackColor()
                let singleSquare = SKSpriteNode(color: colorOfSquare, size: CGSizeMake(widthOfSquare, heightOfSquare))
                let xOffset = singleSquare.frame.width * CGFloat(numRow) - singleSquare.frame.width/2
                let yOffset = singleSquare.frame.height * CGFloat(numHeight) - singleSquare.frame.height/2
                singleSquare.name = "\(Array(alphabet.characters)[numRow - 1])\(String(numHeight))"
                singleSquare.position = CGPointMake(-halfOfMapWidth + xOffset , -halfOfMapHeight + yOffset)
                //singleSquare.alpha = 0.5
                map.addChild(singleSquare)
                
                print(singleSquare.name)
            }
        }
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
    }
}
