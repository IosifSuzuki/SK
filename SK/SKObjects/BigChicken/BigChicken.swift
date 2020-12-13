//
//  BigChicken.swift
//  SK
//
//  Created by admin on 27.11.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import SpriteKit

class BigChicken: SKSpriteNode {
    
    var health = 5
    fileprivate var explodeEmitter: SKEmitterNode!
    static let name = "BigChicken"
    fileprivate let speedPerSecond = 700.0
    fileprivate let presentSpeedPerSeconds: Double = 200
    fileprivate let frequency = 0.5
    var timer: Timer!
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.name = BigChicken.name
        self.zPosition = 1
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width / 2, height: size.height))
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = CategoryMask.enemy.rawValue
        self.physicsBody?.contactTestBitMask = CategoryMask.spaceShip.rawValue
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.mass = 1000
        self.explodeEmitter = SKEmitterNode(fileNamed: "Explode")!
        self.setupAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        timer.invalidate()
    }
    
    //MARK: - Private
    
    fileprivate func setupAnimation() {
        let animationAtlas = SKTextureAtlas(named: "bigChicken")
        var animationTextures: [SKTexture] = []
        let numImages = animationAtlas.textureNames.count
        for i in 1...numImages {
            let birdTextureName = "bigChicken_\(i)"
            animationTextures.append(animationAtlas.textureNamed(birdTextureName))
        }
        texture = animationAtlas.textureNamed("bigChicken_\(1)")
        animationTextures += animationTextures.reversed()
        run(SKAction.repeatForever(
            SKAction.animate(with: animationTextures, timePerFrame: 0.04, resize: false, restore: true)
        ))
    }
    
    @objc
    fileprivate func givePresent(withCompletionBlock completionBlock:@escaping () -> Void) {
        guard let parent = parent else { return }
        let sizeOfPresent = CGSize(width: 50, height: 50)
        let present = SKSpriteNode(texture: SKTexture(imageNamed: "present"), size: sizeOfPresent)
        let targerPoint = CGPoint(x: position.x, y: -MainGameScene.sizeScreen.height / 2 - present.size.height / 2)
        let timePresentFall = distance(firstPoint: targerPoint, secondPoint: position, sizeScene: MainGameScene.sizeScreen) / presentSpeedPerSeconds
        let fallPresentAction = SKAction.move(to: targerPoint, duration: timePresentFall)
        let removeFromParent = SKAction.removeFromParent()
        present.zPosition = 1
        present.physicsBody = SKPhysicsBody(rectangleOf: present.size)
        present.physicsBody?.isDynamic = true
        present.physicsBody?.categoryBitMask = CategoryMask.present.rawValue
        present.physicsBody?.contactTestBitMask = CategoryMask.spaceShip.rawValue
        present.physicsBody?.allowsRotation = false
        self.removeFromParent()
        parent.addChild(present)
        present.run(SKAction.sequence([fallPresentAction, removeFromParent])) {
            completionBlock()
        }
    }
    
    //MARK: - Handler
    
    @objc
    func castEgg() {
        guard let parent = parent else { return }
        let eggTexture = SKTexture(imageNamed: "egg")
        let egg = SKSpriteNode(texture: eggTexture, size: CGSize(width: 50, height: 50))
        let offsetX = position.x - size.width / 4 + CGFloat(arc4random() % UInt32(size.width / 2))
        egg.position = CGPoint(x: offsetX, y: position.y - size.height / 2 - egg.size.height / 2)
        egg.physicsBody = SKPhysicsBody(rectangleOf: egg.size)
        egg.physicsBody?.categoryBitMask = CategoryMask.egg.rawValue
        egg.physicsBody?.contactTestBitMask = CategoryMask.spaceShip.rawValue
        egg.physicsBody?.isDynamic = true
        egg.physicsBody?.allowsRotation = false
        egg.zPosition = 1
        let targerPoint = CGPoint(x: offsetX, y: -MainGameScene.sizeScreen.height / 2 - egg.size.height / 2)
        let timeEggFall = distance(firstPoint: targerPoint, secondPoint: position, sizeScene: MainGameScene.sizeScreen) / speedPerSecond
        let fallEggAction = SKAction.move(to: targerPoint, duration: timeEggFall)
        let removeFromParent = SKAction.removeFromParent()
        egg.run(SKAction.sequence([fallEggAction, removeFromParent]))
        parent.addChild(egg)
    }
    
    
    //MARK: - Public
    
    func explode(withCompletionBlock completionBlock:@escaping () -> Void) {
        explodeEmitter.particleLifetime = 1
        explodeEmitter.zPosition = zPosition + 1
        explodeEmitter.targetNode = scene
        explodeEmitter.position = self.position
        explodeEmitter.particleScale = 2
        if explodeEmitter.parent == nil {
            parent?.addChild(explodeEmitter)
        }
        parent?.run(SKAction.sequence([ResourceManager.shared.actionSoundOfExplosion])) {
            self.givePresent(withCompletionBlock: completionBlock)
        }
    }
    
    func prepareCastEgg() {
        if let timer = self.timer {
            timer.invalidate()
        }
        self.timer = Timer.scheduledTimer(timeInterval: frequency, target: self, selector: #selector(castEgg), userInfo: nil, repeats: true)
    }
    
}
