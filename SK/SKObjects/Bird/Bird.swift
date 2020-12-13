//
//  Bird.swift
//  SK
//
//  Created by admin on 25.11.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import SpriteKit

class Bird: SKSpriteNode {
    
    static let name = "Bird"
    fileprivate let speedPerSecond = 700.0
    
    var health = 2
    fileprivate var fallEggTimer: Timer!
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.name = Bird.name
        self.zPosition = 1
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = CategoryMask.enemy.rawValue
        self.physicsBody?.contactTestBitMask = CategoryMask.spaceShip.rawValue
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.mass = 1000
        
        self.setupAnimation()
        self.setupTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        fallEggTimer.invalidate()
    }
    
    //MARK: - Private
    
    fileprivate func setupAnimation() {
        let animationAtlas = SKTextureAtlas(named: "birdFlying")
        var animationTextures: [SKTexture] = []
        let numImages = animationAtlas.textureNames.count
        for i in 1...numImages {
            let birdTextureName = "bird_fly_\(i)"
            animationTextures.append(animationAtlas.textureNamed(birdTextureName))
        }
        texture = animationAtlas.textureNamed("bird_fly_\(1)")
        animationTextures += animationTextures.reversed()
        run(SKAction.repeatForever(
            SKAction.animate(with: animationTextures, timePerFrame: 0.01, resize: false, restore: true)
        ))
    }
    
    fileprivate func setupTimer() {
        fallEggTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(castEgg), userInfo: nil, repeats: true)
    }
    
    @objc
    func castEgg() {
        guard let parent = parent else { return }
        if arc4random() % 2 == 0 {
            return
        }
        let eggTexture = SKTexture(imageNamed: "egg")
        let egg = SKSpriteNode(texture: eggTexture, size: CGSize(width: 50, height: 50))
        egg.position = CGPoint(x: position.x, y: position.y - size.height / 2 - egg.size.height / 2)
        egg.physicsBody = SKPhysicsBody(rectangleOf: egg.size)
        egg.physicsBody?.categoryBitMask = CategoryMask.egg.rawValue
        egg.physicsBody?.contactTestBitMask = CategoryMask.spaceShip.rawValue
        egg.physicsBody?.isDynamic = true
        egg.physicsBody?.allowsRotation = false
        egg.zPosition = 1
        let targerPoint = CGPoint(x: position.x, y: -MainGameScene.sizeScreen.height / 2 - egg.size.height / 2)
        let timeEggFall = distance(firstPoint: targerPoint, secondPoint: position, sizeScene: MainGameScene.sizeScreen) / speedPerSecond
        let fallEggAction = SKAction.move(to: targerPoint, duration: timeEggFall)
        let removeFromParent = SKAction.removeFromParent()
        egg.run(SKAction.sequence([fallEggAction, removeFromParent]))
        parent.addChild(egg)
    }
    
    //MARK: - Public
    
    func die() {
        guard let parent = parent else { return }
        let meatTexture = SKTexture(imageNamed: "meat")
        let meat = SKSpriteNode(texture: meatTexture, color: .clear, size: CGSize(width: 50, height: 50))
        let targerPoint = CGPoint(x: position.x, y: -MainGameScene.sizeScreen.height / 2 - meat.size.height / 2)
        let timeMeatFall = distance(firstPoint: targerPoint, secondPoint: position, sizeScene: MainGameScene.sizeScreen) / speedPerSecond
        let fallMeatAction = SKAction.move(to: targerPoint, duration: timeMeatFall)
        let rotateMeatAction = SKAction.rotate(byAngle:CGFloat(2 * Double.pi), duration: timeMeatFall)
        let removeFromParent = SKAction.removeFromParent()
        
        meat.position = CGPoint(x: position.x, y: position.y - size.height / 2 - meat.size.height / 2)
        meat.run(SKAction.sequence([SKAction.group([rotateMeatAction, fallMeatAction]), removeFromParent]))
        parent.addChild(meat)
    }
}
