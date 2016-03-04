//
//  LevelSelectScene.swift
//  Tap-Golf
//
//  Created by Sathvik Kadaveru on 2/20/16.
//  Copyright © 2016 Sathvik Kadaveru. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class LevelSelectScene: SKScene {
    
    let boxCategory: UInt32 = 0b1 << 0
    static let numLevels = 3
    
    override func didMoveToView(view: SKView) {
        GameScene.level = 0
        for i in 0..<LevelSelectScene.numLevels {
            addLevelButton(i)
        }
    }
    
    func addLevelButton(level: Int) {
        let boxSize: CGFloat = size.height / 6
        let col: CGFloat = CGFloat(level % 5)
        let row: CGFloat = CGFloat(Int(level / 5))
        print(String(col) + " " + String(row))
        let box = SKSpriteNode(color: UIColor.grayColor(), size: CGSizeMake(boxSize, boxSize))
        box.name = "Box" + String(level)
        box.physicsBody = SKPhysicsBody(rectangleOfSize: box.frame.size)
        box.physicsBody!.allowsRotation = false
        box.physicsBody!.affectedByGravity = false
        box.physicsBody!.dynamic = false
        box.physicsBody!.pinned = true
        box.physicsBody!.allowsRotation = false
        let xpos: CGFloat = col / 5 * size.width + boxSize
        let ypos: CGFloat = size.height - (row / 5 * size.height + boxSize)
        box.position = CGPoint(x: xpos, y: ypos)
        box.physicsBody!.categoryBitMask = boxCategory
        print(box.position)
        addChild(box)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        /*if !flamingo {
        return
        }*/
        
        let touch = touches.first as UITouch!
        let location = touch.locationInNode(self)
        
        if let body = self.physicsWorld.bodyAtPoint(location) {
            if (body.categoryBitMask == boxCategory) {
                let name = body.node!.name!
                print(name)
                let lc = name[name.startIndex.advancedBy(3)]
                GameScene.level = Int(String(lc))!
                let newScene = GameScene(fileNamed:"GameScene")
                newScene!.size.width = 2 * UIScreen.mainScreen().bounds.width
                newScene!.size.height = 2 * UIScreen.mainScreen().bounds.height
                newScene!.scaleMode = .AspectFill
                self.view?.presentScene(newScene!, transition: SKTransition.doorwayWithDuration(0.5))
            }
        }
        
    }
}