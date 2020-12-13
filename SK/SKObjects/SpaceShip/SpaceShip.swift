//
//  SpaceShip.swift
//  SK
//
//  Created by admin on 11.11.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import SpriteKit

class SpaceShip: SKSpriteNode {
    
    let speedPerSecond: Double = 1300
    
    var screenRect: CGRect!
    var rightEmitter: SKEmitterNode!
    var leftEmitter: SKEmitterNode!
    let bulletTexture: SKTexture
    let spaceShipTexture: SKTexture?
    
    var trackPosition: CGPoint {
        set {
            let positionX = CGPoint(x: newValue.x, y: 0)
            let positionY = CGPoint(x: 0, y: newValue.y)
            if screenRect.contains(positionX) {
                position.x = newValue.x
            }
            if screenRect.contains(positionY) {
                position.y = newValue.y
            }
        }
        get {
            return self.position
        }
    }
    
    var isFire = false
    var fireTimer: Timer!
    let speedOfFire: TimeInterval = 0.4
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        self.spaceShipTexture = texture
        self.bulletTexture = SKTexture(imageNamed: "bullet")
        super.init(texture: texture, color: color, size: size)
        self.setupEmmiters()
        self.speed = 0.15
        self.setScale(0.15)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody!.categoryBitMask = CategoryMask.spaceShip.rawValue
        self.physicsBody!.isDynamic = true
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.mass = 100000
        self.physicsBody!.allowsRotation = false
        
        self.screenRect = CGRect(x: -MainGameScene.sizeScreen.width / 2 + self.size.width / 2, y: -MainGameScene.sizeScreen.height / 2 + self.size.height, width: MainGameScene.sizeScreen.width - self.size.width, height: MainGameScene.sizeScreen.height - self.size.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public
    
    func fire() {
        isFire.toggle()
        if isFire {
            fireTimer = Timer.scheduledTimer(timeInterval: speedOfFire, target: self, selector: #selector(makeFire), userInfo: nil, repeats: true)
        } else {
            fireTimer.invalidate()
        }
    }
    
    //MARK: - Private
    
    @objc
    fileprivate func makeFire() {
        let bullet = SKSpriteNode(texture: bulletTexture, size: CGSize(width: 15, height: 37.5))
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.categoryBitMask = CategoryMask.bullet.rawValue
        bullet.physicsBody?.contactTestBitMask = CategoryMask.enemy.rawValue
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.allowsRotation = false
        bullet.zPosition = 1
        bullet.position = CGPoint(x: position.x, y: position.y + self.size.width / 2 + 10)
        let targerPoint = CGPoint(x: position.x, y: MainGameScene.sizeScreen.height / 2 + bullet.size.height / 2)
        let timeOfTheShot = distance(firstPoint: targerPoint, secondPoint: position, sizeScene: MainGameScene.sizeScreen) / speedPerSecond
        let moveBulletAction = SKAction.move(to: targerPoint, duration: timeOfTheShot)
        let removeFromParent = SKAction.removeFromParent()
        bullet.run(SKAction.sequence([moveBulletAction, removeFromParent]))
        guard let parent = parent else { return }
        parent.addChild(bullet)
    }
    
    fileprivate func setupEmmiters() {
        if let leftEmmiterFOT = SKEmitterNode(fileNamed: "FireOfTurbine") {
            let leftEmmiterPosition = CGPoint(x: -0.12 * size.width, y: -size.height / 2 - 5)
            leftEmmiterFOT.position = leftEmmiterPosition
            leftEmmiterFOT.zPosition = 0
            leftEmitter = leftEmmiterFOT
            self.addChild(leftEmmiterFOT)
        }
        
        if let rightEmmiterFOT = SKEmitterNode(fileNamed: "FireOfTurbine") {
            let rightEmmiterPosition = CGPoint(x: 0.12 * size.width, y: -size.height / 2 - 5)
            rightEmmiterFOT.position = rightEmmiterPosition
            rightEmmiterFOT.zPosition = 0
            rightEmitter = rightEmmiterFOT
            self.addChild(rightEmmiterFOT)
            
        }
    }
    
}

