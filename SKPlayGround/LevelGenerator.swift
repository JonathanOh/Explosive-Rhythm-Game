//
//  LevelGenerator.swift
//  SKPlayGround
//
//  Created by Jonathan Oh on 2/15/16.
//  Copyright © 2016 Jonathan Oh. All rights reserved.
//

import SpriteKit

class LevelGenerator {
    
    let hideNodeAction = SKAction.hide()
    let showNodeAction = SKAction.unhide()
    let explosionSound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    //let showNodeAction = SKAction.group([showNode, explosionSound])
    let durationOfDeathExplosion = SKAction.waitForDuration(0.1)
    let waitHalfSecond = SKAction.waitForDuration(2.50)

    var arrayOfSquareNodes = [SKSpriteNode]()
    var widthOfCurrentBoard : Int
    var lengthOfCurrentBoard : Int
    
    // Need better solution for sound handling.  Multiple sound nodes playing at once, want to only play 1 instance of it at a time.
    var shouldHaveSound = true
    
    init(currentMap : GameMap) {
        
        widthOfCurrentBoard = currentMap.row
        lengthOfCurrentBoard = currentMap.height
        for node in currentMap.arrayOfSquareNodes {
            arrayOfSquareNodes.append(node)
        }
        print("\(arrayOfSquareNodes)")
        
        levelOne()
        
    }
    
    func actionCreator(initialWait: NSTimeInterval, timeInterval: NSTimeInterval) -> SKAction {
        let waitFor = SKAction.waitForDuration(timeInterval)
        let initialWaitFor = SKAction.waitForDuration(initialWait)
        let arrayOfActions = SKAction.sequence([shouldHaveSound ? explosionSound:hideNodeAction,showNodeAction, durationOfDeathExplosion, hideNodeAction, waitFor])
        let repeater = SKAction.repeatActionForever(arrayOfActions)
        let finalAction = SKAction.sequence([initialWaitFor, repeater])
        shouldHaveSound = false
        return finalAction
    }
    
    func waitStagger(staggerTime : NSTimeInterval, times: NSTimeInterval) -> NSTimeInterval {
        let createdTime = staggerTime * times
        return createdTime
    }
    
    func explodeRow(rowNum: Int, initialWait: NSTimeInterval, timeInterval: NSTimeInterval) {
        for action in (widthOfCurrentBoard * rowNum - widthOfCurrentBoard)..<(widthOfCurrentBoard * rowNum) {
            let explodeRowAction = actionCreator(initialWait, timeInterval: timeInterval)
            arrayOfSquareNodes[action].childNodeWithName("explosion")!.runAction(explodeRowAction)
        }
        shouldHaveSound = true
    }
    
    func levelOne() {
        explodeRow(1, initialWait: waitStagger(0.50, times: 0), timeInterval: 2.5)
        explodeRow(2, initialWait: waitStagger(0.50, times: 1), timeInterval: 2.5)
        explodeRow(3, initialWait: waitStagger(0.50, times: 2), timeInterval: 2.5)
        explodeRow(4, initialWait: waitStagger(0.50, times: 3), timeInterval: 2.5)
        explodeRow(5, initialWait: waitStagger(0.50, times: 4), timeInterval: 2.5)
        explodeRow(6, initialWait: waitStagger(0.50, times: 0), timeInterval: 2.5)
        explodeRow(7, initialWait: waitStagger(0.50, times: 1), timeInterval: 2.5)
        explodeRow(8, initialWait: waitStagger(0.50, times: 2), timeInterval: 2.5)
        explodeRow(9, initialWait: waitStagger(0.50, times: 3), timeInterval: 2.5)
        explodeRow(10, initialWait: waitStagger(0.50, times: 4), timeInterval: 2.5)
    }
    
}