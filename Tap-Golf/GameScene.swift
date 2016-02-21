//
//  GameScene.swift
//
//  Created by Sathvik Kadaveru on 2/6/16.
//  Copyright (c) 2016 Sathvik Kadaveru. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate { //KurtNiemi@air-watch.com
    
    let ballCategory: UInt32 = 0b1 << 0
    let bunkerCategory: UInt32 = 0b1 << 1
    let roughCategory: UInt32 = 0b1 << 2
    let edgeCategory: UInt32 = 0b1 << 3
    let goalCategory: UInt32 = 0b1 << 4
    
    let edgeColor: UIColor = UIColor(red: 0.3, green: 0, blue: 0.8, alpha: 1)
    let bunkerColor: UIColor = UIColor.yellowColor()
    let playerColor: UIColor = UIColor.redColor()
    let goalColor: UIColor = UIColor.whiteColor()
    
    var flamingo: Bool = false //flamingo is true if the game is paused
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.physicsWorld.contactDelegate = self
        
        let level = 1;
        
        if level == 0 {
            addBunker("bunker1", size: [size.width / 5, size.height], pos: [size.width / 2, size.height / 2])
            addPlayer("ball", size: [32, 32], pos: [size.width / 4, size.height / 2])
            addGoal("goal", size: [32, 32], pos:[size.width / 4 * 3, size.height / 2])
        } else if level == 1 {
            addSolid("barrier", size: [size.width / 4 * 3, size.height / 6], pos: [size.width / 8 * 3, size.height / 2], color: UIColor.blueColor())
            addBunker("bunker1", size: [size.width / 4, size.height], pos: [size.width / 8 * 7, size.height / 2]);
            addPlayer("ball", size: [32, 32], pos: [size.width / 8, size.height / 4])
            addGoal("goal", size: [32, 32], pos:[size.width / 8, size.height / 4 * 3])
        }
        else {
            addPlayer("ball", size: [32, 32], pos: [size.width / 2, size.height / 2])
            addGoal("goal", size: [32, 32], pos:[size.width / 4 * 3, size.height / 2])
        }
        
        addSolid("topEdge", size: [size.width, size.height / 20], pos: [size.width / 2, 39 * size.height / 40], color: edgeColor)
        addSolid("botEdge", size: [size.width, size.height / 20], pos: [size.width / 2, size.height / 40], color: edgeColor)
        addSolid("rightEdge", size: [size.width / 30, size.height], pos: [size.width / 60, size.height / 2], color: edgeColor)
        addSolid("leftEdge", size: [size.width / 30, size.height], pos: [59 * size.width / 60, size.height / 2], color: edgeColor)
    }
    
    func addSprite(name: String, color: UIColor, size: [CGFloat], frla: [CGFloat], adpa: [Bool], pos: [CGFloat], bits: [UInt32]) {
        let newSprite = SKSpriteNode(color: color, size: CGSizeMake(size[0], size[1]))
        newSprite.name = name
        newSprite.physicsBody = SKPhysicsBody(rectangleOfSize: newSprite.frame.size)
        newSprite.physicsBody!.allowsRotation = false
        newSprite.physicsBody!.friction = frla[0]
        newSprite.physicsBody!.restitution = frla[1]
        newSprite.physicsBody!.linearDamping = frla[2]
        newSprite.physicsBody!.angularDamping = frla[3]
        newSprite.physicsBody!.affectedByGravity = adpa[0]
        newSprite.physicsBody!.dynamic = adpa[1]
        newSprite.physicsBody!.pinned = adpa[2]
        newSprite.physicsBody!.allowsRotation = adpa[3]
        newSprite.position = CGPoint(x: pos[0], y: pos[1])
        newSprite.physicsBody!.categoryBitMask = bits[0]
        newSprite.physicsBody!.collisionBitMask = bits[1]
        newSprite.physicsBody!.contactTestBitMask = bits[2]
        addChild(newSprite)
    }
    
    func addBunker(name: String, size: [CGFloat], pos:[CGFloat]) {
        addSprite(name, color: bunkerColor, size: size, frla: [0, 0.5, 0, 0], adpa: [false, true, true, false], pos: pos, bits: [bunkerCategory, 0, 0])
    }
    
    func addPlayer(name: String, size: [CGFloat], pos:[CGFloat]) {
        addSprite(name, color: playerColor, size: size, frla: [0, 0.6, 0.3, 0], adpa: [false, true, false, false], pos: pos, bits: [ballCategory, edgeCategory, bunkerCategory | roughCategory | goalCategory])
    }
    
    func addGoal(name: String, size: [CGFloat], pos:[CGFloat]) {
        addSprite(name, color: goalColor, size: size, frla: [0, 0.5, 0, 0], adpa: [false, true, true, false], pos: pos, bits: [goalCategory, 0, 0])
    }
    
    func addSolid(name: String, size: [CGFloat], pos:[CGFloat], color: UIColor) {
        addSprite(name, color: color, size: size, frla: [0, 1, 0, 0], adpa: [false, true, true, false], pos: pos, bits: [edgeCategory, 0, 0])
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        /*if !flamingo {
        return
        }*/
        
        let touch = touches.first as UITouch!
        let location = touch.locationInNode(self)
        
        let ball = childNodeWithName("ball") as! SKSpriteNode
        //
        var velx = location.x - ball.position.x
        var vely = location.y - ball.position.y
        //
        if (velx > size.width / 3) {
            velx = size.width / 3
        } else if (velx < -size.width / 3) {
            velx = -size.width / 3
        }
        //
        if (vely > size.height / 3) {
            vely = size.height / 3
        } else if (vely < -size.height / 3) {
            vely = -size.height / 3
        }
        //
        ball.physicsBody!.velocity.dx = velx * 1.1
        ball.physicsBody!.velocity.dy = vely * 1.1
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var first: SKPhysicsBody
        var second: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            first = contact.bodyA
            second = contact.bodyB
        } else {
            first = contact.bodyB
            second = contact.bodyA
        }
        
        if first.categoryBitMask == ballCategory && second.categoryBitMask == bunkerCategory {
            let ball = self.childNodeWithName("ball") as! SKSpriteNode
            ball.physicsBody!.linearDamping = 0.99999
        }
        
        //print("begin contact")
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        var first: SKPhysicsBody
        var second: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            first = contact.bodyA
            second = contact.bodyB
        } else {
            first = contact.bodyB
            second = contact.bodyA
        }
        
        if first.categoryBitMask == ballCategory && second.categoryBitMask == bunkerCategory {
            let ball = self.childNodeWithName("ball") as! SKSpriteNode
            ball.physicsBody!.linearDamping = 0.3
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
