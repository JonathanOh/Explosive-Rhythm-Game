//
//  GameOver.swift
//  SKPlayGround
//
//  Created by Jonathan Oh on 2/15/16.
//  Copyright © 2016 Jonathan Oh. All rights reserved.
//

import SpriteKit

class GameOver: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.backgroundColor = SKColor.blackColor()
        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.color = SKColor.whiteColor()
        gameOverLabel.fontSize = self.frame.width/8
        gameOverLabel.position = CGPointMake(self.frame.width/2, self.frame.height/2)
        
        let tapAnywhere = SKLabelNode(text: "tap anywhere to play again")
        tapAnywhere.color = SKColor.whiteColor()
        tapAnywhere.fontSize = self.frame.width/15
        tapAnywhere.position = CGPointMake(self.frame.width/2, self.frame.height/2 - 50)
        
        self.addChild(gameOverLabel)
        self.addChild(tapAnywhere)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let scene = GameScene(fileNamed:"GameScene") {
            
            scene.size = self.size
            self.view?.presentScene(scene)
            let newGameTransition = SKTransition.doorsOpenHorizontalWithDuration(2.0)
            self.view?.presentScene(scene, transition: newGameTransition) //This transition is not working for some reason
        }
    }

    
}
