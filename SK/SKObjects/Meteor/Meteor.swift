//
//  Meteor.swift
//  SK
//
//  Created by admin on 14.11.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import SpriteKit


class Meteor: SKSpriteNode {
    
    static let name = "Meteor"
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = CategoryMask.enemy.rawValue
        self.physicsBody?.contactTestBitMask = CategoryMask.spaceShip.rawValue
        self.physicsBody?.allowsRotation = false
        self.zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public
    
    func explode() {
        let explodeEmitter = SKEmitterNode(fileNamed: "Explode")!
        explodeEmitter.zPosition = zPosition + 1
        explodeEmitter.position = .zero
        explodeEmitter.targetNode = self.parent?.scene
        addChild(explodeEmitter)
        let actionSoundOfExplosion = SKAction.playSoundFileNamed("Explosion.wav", waitForCompletion: false)
        run(SKAction.sequence([actionSoundOfExplosion, SKAction.wait(forDuration: 0.15), SKAction.removeFromParent()]))
    }
    
}
