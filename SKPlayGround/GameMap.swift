//
//  map.swift
//  SKPlayGround
//
//  Created by Jonathan Oh on 2/14/16.
//  Copyright © 2016 Jonathan Oh. All rights reserved.
//

import SpriteKit

class GameMap {
    
    let mapContainer : SKSpriteNode
    
    //Constants for Square creation
    let row = 10 //Row should not exceed alphabet.length
    let height = 10
    let alphabet = "abcdefghijklmnopqrstuvwxyz"
    let widthOfSquare : CGFloat
    let heightOfSquare : CGFloat
    let sizeOfSquare : CGSize
    let halfOfMapWidth : CGFloat
    let halfOfMapHeight : CGFloat
    var arrayOfSquareNodes = [SKSpriteNode]()
    
    init(currentScene : SKScene) {
        //Create, Configure, and Add mapContainer Node
        mapContainer = SKSpriteNode(color: UIColor.blueColor(), size: CGSizeMake(currentScene.frame.width, currentScene.frame.width))
        mapContainer.position = CGPointMake(currentScene.frame.width/2, currentScene.frame.height/2)
        
        //Create, Configure, and Add Individual Square Nodes
        widthOfSquare = mapContainer.frame.width/CGFloat(row)
        heightOfSquare = mapContainer.frame.height/CGFloat(height)
        sizeOfSquare = CGSizeMake(widthOfSquare, heightOfSquare)
        halfOfMapWidth = mapContainer.frame.width/2
        halfOfMapHeight = mapContainer.frame.height/2
        
        //Generates a grid of nodes with an explosion node overlayed
        for numHeight in 1...height {
            for numRow in 1...row {
                let colorOfSquare = (numRow + numHeight) % 2 == 0 ? SKColor.grayColor() : SKColor.blackColor()
                let singleSquare = SKSpriteNode(color: colorOfSquare, size: sizeOfSquare)
                let xOffset = singleSquare.frame.width * CGFloat(numRow) - singleSquare.frame.width/2
                let yOffset = singleSquare.frame.height * CGFloat(numHeight) - singleSquare.frame.height/2
                singleSquare.name = "\(Array(alphabet.characters)[numRow - 1])\(String(numHeight))"
                singleSquare.position = CGPointMake(-halfOfMapWidth + xOffset , -halfOfMapHeight + yOffset)
                singleSquare.physicsBody = SKPhysicsBody(rectangleOfSize: sizeOfSquare)
                singleSquare.physicsBody?.dynamic = false
                singleSquare.physicsBody?.categoryBitMask = GameScene.squareCategory
                arrayOfSquareNodes.append(singleSquare)
                
                let explosionNode = SKSpriteNode(color: SKColor.redColor(), size: sizeOfSquare)
                explosionNode.name = "explosion"
                explosionNode.hidden = true
                explosionNode.physicsBody = SKPhysicsBody(rectangleOfSize: sizeOfSquare)
                explosionNode.physicsBody?.dynamic = false
                explosionNode.physicsBody?.categoryBitMask = GameScene.explosionCategory
                //singleSquare.alpha = 0.5
                mapContainer.addChild(singleSquare)
                singleSquare.addChild(explosionNode)
                
                //print(singleSquare.name)
            }
        }
    }
    
    func squareNodeNamed(nodeName : String, isExplosion : Bool) -> SKSpriteNode! {
        if !isExplosion {
            let squareNode = self.mapContainer.childNodeWithName(nodeName) as? SKSpriteNode
            return squareNode
        } else {
            let explosionNode = self.mapContainer.childNodeWithName(nodeName)?.childNodeWithName("explosion") as? SKSpriteNode
            return explosionNode
        }
    }
    
}
