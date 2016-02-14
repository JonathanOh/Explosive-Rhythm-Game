//
//  GameScene.swift
//  SKPlayGround
//
//  Created by Jonathan Oh on 2/11/16.
//  Copyright (c) 2016 Jonathan Oh. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    
    var lilSpacey : PlayerSprite!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.view?.multipleTouchEnabled = false
        self.backgroundColor = SKColor.whiteColor()
        
        lilSpacey = PlayerSprite(parentFrame: self.frame)
        
        //lilSpacey.playerSprite.position = CGPointMake(self.frame.width/2, self.frame.height/2)
        self.addChild(lilSpacey.playerSprite)
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        lilSpacey.updatePlayerPosition(self, touches: touches)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        lilSpacey.updatePlayerPosition(self, touches: touches)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        lilSpacey.playerSprite.removeAllActions()
    }
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
