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
    let durationOfDeathExplosion = SKAction.wait(forDuration: 0.1)
    let waitHalfSecond = SKAction.wait(forDuration: 2.50)

    var arrayOfSquareNodes = [SKSpriteNode]()
    var widthOfCurrentBoard : Int
    var lengthOfCurrentBoard : Int
    var explodeTextureArray = [SKTexture]()
    
    fileprivate var _leveltracker : Int = 0
    
    var levelTracker : Int {
        get {
            return _leveltracker
        }
    }
    
    // Need better solution for sound handling.  Multiple sound nodes playing at once, want to only play 1 instance of it at a time.
    var shouldHaveSound = true
    
    init(currentMap : GameMap) {
        
        widthOfCurrentBoard = currentMap.col
        lengthOfCurrentBoard = currentMap.row
        for node in currentMap.arrayOfSquareNodes {
            arrayOfSquareNodes.append(node)
        }
        
        //Blue Explosions
//        for var i = 1; i <= 7; i++ {
//            let texture = SKTexture(imageNamed: "blue\(i).png")
//            explodeTextureArray.append(texture)
//        }
        
        //Red Explosions
        for i in 1...9 {
            let texture = SKTexture(imageNamed: "red\(i).png")
            explodeTextureArray.append(texture)
        }
        
        levelZero()
    }
    
    func nextLevelHandler(_ currentScene: GameScene) {
        currentScene.enumerateChildNodes(withName: "//*") {
            node, stop in
            node.removeAllActions()
            if (node.name == "explosion") {
                node.isHidden = true
            }
        }
        _leveltracker += 1
        switch _leveltracker {
        case 1:
            levelOne()
        case 2:
            levelTwo()
        case 3:
            levelThree()
        case 4:
            levelFour()
        case 5:
            levelFive()
        case 6:
            levelSix()
        case 7:
            levelSeven()
        case 8:
            levelEight()
        case 9:
            levelNine()
        default:
            levelOne()
        }
    }
    
    func actionCreator(_ initialWait: TimeInterval, timeInterval: TimeInterval) -> SKAction {
        let waitFor = SKAction.wait(forDuration: timeInterval)
        let initialWaitFor = SKAction.wait(forDuration: initialWait)
        let arrayOfActions = SKAction.sequence([shouldHaveSound ? explosionSound:hideNodeAction,showNodeAction, durationOfDeathExplosion, hideNodeAction, waitFor])
        let repeater = SKAction.repeatForever(arrayOfActions)
        let finalAction = SKAction.sequence([initialWaitFor, repeater])
        shouldHaveSound = false
        return finalAction
    }
    
    func animationActionCreator(_ initialWait: TimeInterval, timeInterval: TimeInterval) -> SKAction {
        let waitFor = SKAction.wait(forDuration: timeInterval)
        let initialWaitFor = SKAction.wait(forDuration: initialWait)
        let explosionAnimation = SKAction.animate(with: explodeTextureArray, timePerFrame: 0.06, resize: false, restore: true)
        let arrayOfActions = SKAction.sequence([durationOfDeathExplosion, waitFor])
        let groupedActions = SKAction.group([explosionAnimation, arrayOfActions])
        let repeater = SKAction.repeatForever(groupedActions)
        let finalAction = SKAction.sequence([initialWaitFor, repeater])
        //shouldHaveSound = false
        return finalAction
    }
    
    func waitStagger(_ staggerTime : TimeInterval, times: TimeInterval) -> TimeInterval {
        let createdTime = staggerTime * times
        return createdTime
    }
    
    func explodeRow(_ rowNum: Int, initialWait: TimeInterval, timeInterval: TimeInterval) {
        for action in (widthOfCurrentBoard * rowNum - widthOfCurrentBoard)..<(widthOfCurrentBoard * rowNum) {
            let explodeRowAction = actionCreator(initialWait, timeInterval: timeInterval)
            let explosionAnimation = animationActionCreator(initialWait, timeInterval: timeInterval)
            arrayOfSquareNodes[action].run(explosionAnimation)
            arrayOfSquareNodes[action].childNode(withName: "explosion")!.run(explodeRowAction)
            
        }
        shouldHaveSound = true
    }
    func explodeCol(_ colNum: Int, initialWait: TimeInterval, timeInterval: TimeInterval) {
        
        for action in stride(from: colNum - 1, to: arrayOfSquareNodes.count, by: 10) {
            let explodeColAction = actionCreator(initialWait, timeInterval: timeInterval)
            let explosionAnimation = animationActionCreator(initialWait, timeInterval: timeInterval)
            arrayOfSquareNodes[action].run(explosionAnimation)
            arrayOfSquareNodes[action].childNode(withName: "explosion")!.run(explodeColAction)
        }
        shouldHaveSound = true
    }
    
    func levelZero() {
        
        explodeRow(6, initialWait: waitStagger(0.50, times: 0), timeInterval: 1)
        //return
    }
    
    func levelOne() {//Single rhythm + Single line
        explodeRow(1, initialWait: waitStagger(0.50, times: 0), timeInterval: 5)
        explodeRow(2, initialWait: waitStagger(0.50, times: 1), timeInterval: 5)
        explodeRow(3, initialWait: waitStagger(0.50, times: 2), timeInterval: 5)
        explodeRow(4, initialWait: waitStagger(0.50, times: 3), timeInterval: 5)
        explodeRow(5, initialWait: waitStagger(0.50, times: 4), timeInterval: 5)
        explodeRow(6, initialWait: waitStagger(0.50, times: 5), timeInterval: 5)
        explodeRow(7, initialWait: waitStagger(0.50, times: 6), timeInterval: 5)
        explodeRow(8, initialWait: waitStagger(0.50, times: 7), timeInterval: 5)
        explodeRow(9, initialWait: waitStagger(0.50, times: 8), timeInterval: 5)
        explodeRow(10, initialWait: waitStagger(0.50, times: 9), timeInterval: 5)
    }
    
    func levelTwo() {//Single rhythm + Double line
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
    
    func levelThree() {//Single rhythm + Single line + reverse
        explodeRow(1, initialWait: waitStagger(0.50, times: 9), timeInterval: 5)
        explodeRow(2, initialWait: waitStagger(0.50, times: 8), timeInterval: 5)
        explodeRow(3, initialWait: waitStagger(0.50, times: 7), timeInterval: 5)
        explodeRow(4, initialWait: waitStagger(0.50, times: 6), timeInterval: 5)
        explodeRow(5, initialWait: waitStagger(0.50, times: 5), timeInterval: 5)
        explodeRow(6, initialWait: waitStagger(0.50, times: 4), timeInterval: 5)
        explodeRow(7, initialWait: waitStagger(0.50, times: 3), timeInterval: 5)
        explodeRow(8, initialWait: waitStagger(0.50, times: 2), timeInterval: 5)
        explodeRow(9, initialWait: waitStagger(0.50, times: 1), timeInterval: 5)
        explodeRow(10, initialWait: waitStagger(0.50, times: 0), timeInterval: 5)
    }
    
    func levelFour() {
        explodeCol(1, initialWait: waitStagger(0.50, times: 0), timeInterval: 2)
        explodeCol(2, initialWait: waitStagger(0.50, times: 1), timeInterval: 2)
        explodeCol(3, initialWait: waitStagger(0.50, times: 2), timeInterval: 2)
        explodeCol(4, initialWait: waitStagger(0.50, times: 3), timeInterval: 2)
        explodeCol(5, initialWait: waitStagger(0.50, times: 4), timeInterval: 2)
        explodeCol(6, initialWait: waitStagger(0.50, times: 0), timeInterval: 2)
        explodeCol(7, initialWait: waitStagger(0.50, times: 1), timeInterval: 2)
        explodeCol(8, initialWait: waitStagger(0.50, times: 2), timeInterval: 2)
        explodeCol(9, initialWait: waitStagger(0.50, times: 3), timeInterval: 2)
        explodeCol(10, initialWait: waitStagger(0.50, times: 4), timeInterval: 2)
    }
    
    func levelFive() {//Single rhythm + double line + reverse
        explodeRow(1, initialWait: waitStagger(0.50, times: 4), timeInterval: 2.5)
        explodeRow(2, initialWait: waitStagger(0.50, times: 3), timeInterval: 2.5)
        explodeRow(3, initialWait: waitStagger(0.50, times: 2), timeInterval: 2.5)
        explodeRow(4, initialWait: waitStagger(0.50, times: 1), timeInterval: 2.5)
        explodeRow(5, initialWait: waitStagger(0.50, times: 0), timeInterval: 2.5)
        explodeRow(6, initialWait: waitStagger(0.50, times: 4), timeInterval: 2.5)
        explodeRow(7, initialWait: waitStagger(0.50, times: 3), timeInterval: 2.5)
        explodeRow(8, initialWait: waitStagger(0.50, times: 2), timeInterval: 2.5)
        explodeRow(9, initialWait: waitStagger(0.50, times: 1), timeInterval: 2.5)
        explodeRow(10, initialWait: waitStagger(0.50, times: 0), timeInterval: 2.5)
    }

    func levelSix() {//Single rhythm + 5 lines
        explodeRow(1, initialWait: waitStagger(0.50, times: 0), timeInterval: 1)
        explodeRow(2, initialWait: waitStagger(0.50, times: 1), timeInterval: 1)
        explodeRow(3, initialWait: waitStagger(0.50, times: 0), timeInterval: 1)
        explodeRow(4, initialWait: waitStagger(0.50, times: 1), timeInterval: 1)
        explodeRow(5, initialWait: waitStagger(0.50, times: 0), timeInterval: 1)
        explodeRow(6, initialWait: waitStagger(0.50, times: 1), timeInterval: 1)
        explodeRow(7, initialWait: waitStagger(0.50, times: 0), timeInterval: 1)
        explodeRow(8, initialWait: waitStagger(0.50, times: 1), timeInterval: 1)
        explodeRow(9, initialWait: waitStagger(0.50, times: 0), timeInterval: 1)
        explodeRow(10, initialWait: waitStagger(0.50, times: 1), timeInterval: 1)
    }
    
    func levelSeven() {
        explodeCol(1, initialWait: waitStagger(1, times: 0), timeInterval: 2)
        explodeCol(2, initialWait: waitStagger(1, times: 1), timeInterval: 2)
        explodeCol(3, initialWait: waitStagger(1, times: 0), timeInterval: 2)
        explodeCol(4, initialWait: waitStagger(1, times: 1), timeInterval: 2)
        explodeCol(5, initialWait: waitStagger(1, times: 0), timeInterval: 2)
        explodeCol(6, initialWait: waitStagger(1, times: 1), timeInterval: 2)
        explodeCol(7, initialWait: waitStagger(1, times: 0), timeInterval: 2)
        explodeCol(8, initialWait: waitStagger(1, times: 1), timeInterval: 2)
        explodeCol(9, initialWait: waitStagger(1, times: 0), timeInterval: 2)
        explodeCol(10, initialWait: waitStagger(1, times: 1), timeInterval: 2)
    }
    
    func levelEight() {//Double rhythm + 2 lines
        explodeRow(1, initialWait: waitStagger(0.50, times: 0), timeInterval: 2)
        explodeRow(2, initialWait: waitStagger(0.50, times: 1), timeInterval: 2)
        explodeRow(3, initialWait: waitStagger(0.50, times: 2), timeInterval: 2)
        explodeRow(4, initialWait: waitStagger(0.50, times: 1), timeInterval: 2)
        explodeRow(5, initialWait: waitStagger(0.50, times: 0), timeInterval: 2)
        explodeRow(6, initialWait: waitStagger(0.50, times: 0), timeInterval: 2)
        explodeRow(7, initialWait: waitStagger(0.50, times: 1), timeInterval: 2)
        explodeRow(8, initialWait: waitStagger(0.50, times: 2), timeInterval: 2)
        explodeRow(9, initialWait: waitStagger(0.50, times: 1), timeInterval: 2)
        explodeRow(10, initialWait: waitStagger(0.50, times: 0), timeInterval: 2)
    }
    
    func levelNine() { // Hard Rhythm
        explodeRow(1, initialWait: waitStagger(0.50, times: 0), timeInterval: 1)
        explodeRow(2, initialWait: waitStagger(0.50, times: 1), timeInterval: 1)
        explodeRow(3, initialWait: waitStagger(0.50, times: 2), timeInterval: 1)
        explodeRow(4, initialWait: waitStagger(0.50, times: 0), timeInterval: 1)
        explodeRow(5, initialWait: waitStagger(0.50, times: 1), timeInterval: 1)
        explodeRow(6, initialWait: waitStagger(0.50, times: 2), timeInterval: 1)
        explodeRow(7, initialWait: waitStagger(0.50, times: 0), timeInterval: 1)
        explodeRow(8, initialWait: waitStagger(0.50, times: 1), timeInterval: 1)
        explodeRow(9, initialWait: waitStagger(0.50, times: 2), timeInterval: 1)
        explodeRow(10, initialWait: waitStagger(0.50, times: 0), timeInterval: 1)
    }
    
}
