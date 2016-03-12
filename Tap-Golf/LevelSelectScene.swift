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
    static let numLevels = 4
    let rowSize = 5
    
    override func didMoveToView(view: SKView) {
        GameScene.level = 0
        for i in 0..<LevelSelectScene.numLevels {
            addLevelButton(i)
        }
    }
    
    func addLevelButton(level: Int) {
        let boxWidth: CGFloat = size.width / 8
        let boxHeight: CGFloat = size.height / 8
        //
        let col: CGFloat = CGFloat(level % rowSize)
        let row: CGFloat = CGFloat(Int(level / rowSize))
        print(String(col) + " " + String(row))
        //
        let box = SKSpriteNode(color: UIColor.grayColor(), size: CGSizeMake(boxWidth, boxHeight))
        let xpos: CGFloat = boxWidth + 3 * boxWidth / 2 * col
        let ypos: CGFloat = size.height - (boxHeight + 3 * boxHeight / 2 * row)
        box.position = CGPoint(x: xpos, y: ypos)
        box.name = "Box" + String(level)
        box.physicsBody = SKPhysicsBody(rectangleOfSize: box.frame.size)
        box.physicsBody!.allowsRotation = false
        box.physicsBody!.affectedByGravity = false
        box.physicsBody!.dynamic = false
        box.physicsBody!.pinned = true
        box.physicsBody!.allowsRotation = false
        //
        box.physicsBody!.categoryBitMask = boxCategory
        box.physicsBody!.contactTestBitMask = 0
        box.physicsBody!.collisionBitMask = 0
        print(box.position)
        addChild(box)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first as UITouch!
        let location = touch.locationInNode(self)
        print("\(location)")
        
        if let body = self.physicsWorld.bodyAtPoint(location) {
            if (body.categoryBitMask == boxCategory) {
                let name = body.node!.name!
                print(name)
                let st = name.startIndex.advancedBy(3)
                let lc = name.substringFromIndex(st)
                GameScene.level = Int(String(lc))!
                //
                let newScene = GameScene(fileNamed:"GameScene")
                newScene!.size.width = 2 * UIScreen.mainScreen().bounds.width
                newScene!.size.height = 2 * UIScreen.mainScreen().bounds.height
                newScene!.scaleMode = .AspectFill
                self.view?.presentScene(newScene!, transition: SKTransition.doorwayWithDuration(0.5))
            }
        }
        
    }
}