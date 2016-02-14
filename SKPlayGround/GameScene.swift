//
//  GameScene.swift
//  SKPlayGround
//
//  Created by Jonathan Oh on 2/11/16.
//  Copyright (c) 2016 Jonathan Oh. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    //This variable is used to prvide better UX.  Will need a better solution.
    var touchesBeganCounter = 0
    var lilSpacey : PlayerSprite!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = SKColor.whiteColor()
        
        lilSpacey = PlayerSprite(parentFrame: self.frame)
        
        self.addChild(lilSpacey.playerSprite)
        
        //Needs to be refactored to its own class
        let map = SKSpriteNode(color: UIColor.redColor(), size: CGSizeMake(self.frame.width, self.frame.height/2))
        map.position = CGPointMake(self.frame.width/2, self.frame.height/2)
        self.addChild(map)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchesBeganCounter++
        lilSpacey.playerSprite.removeAllActions()
        lilSpacey.updatePlayerPosition(self, touches: touches)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchesBeganCounter--
        if touchesBeganCounter == 0 {
            lilSpacey.playerSprite.removeAllActions()
        }
    }
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
