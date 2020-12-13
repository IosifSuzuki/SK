//
//  BirdAtackStage.swift
//  SK
//
//  Created by admin on 25.11.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import SpriteKit

class BirdAtackStage: BaseStage {
    var mainTimer: Timer!
    let timeDuration: TimeInterval = 30
    var timer: Timer!
    let timeInterval: TimeInterval = 4
    
    override func start() {
        mainTimer = Timer.scheduledTimer(timeInterval: timeDuration, target: self, selector: #selector(stop), userInfo: nil, repeats: false)
        timer = Timer.scheduledTimer(timeInterval: drand48() * timeInterval, target: self, selector: #selector(handlerTimer), userInfo: nil, repeats: false)
    }
    
    override func end() {
        gameScene?.enumerateChildNodes(withName: Bird.name) { (node, _) in
            node.removeFromParent()
        }
        mainTimer.invalidate()
        timer.invalidate()
        gameScene?.endRound()
    }
    
    //MARK: - Private
    
    fileprivate func spawnBird() {
        guard let gameScene = gameScene else { return }
        let sizeOfBird = CGSize(width: 150, height: 150)
        let bird = Bird(texture: nil, color: .clear, size: sizeOfBird)
        let minOffsetY = MainGameScene.sizeScreen.height / 4 - sizeOfBird.height
        let offsetY = CGFloat(arc4random() % UInt32(MainGameScene.sizeScreen.height / 4)) + minOffsetY
        let duration: TimeInterval = (timeInterval - 1) + TimeInterval(arc4random() % 50) / 50
        
        bird.position = CGPoint(x: -MainGameScene.sizeScreen.width / 2 - sizeOfBird.width, y: offsetY)
        let flyActionBird = SKAction.move(to: CGPoint(x: MainGameScene.sizeScreen.width / 2 + sizeOfBird.width, y: offsetY), duration: duration)
        let removeFromParentAction = SKAction.removeFromParent()
        gameScene.addChild(bird)
        bird.run(SKAction.sequence([flyActionBird, removeFromParentAction]))
        timer = Timer.scheduledTimer(timeInterval: drand48() * timeInterval, target: self, selector: #selector(handlerTimer), userInfo: nil, repeats: false)
    }
    
    //MARK: - Handler
    
    @objc
    fileprivate func handlerTimer() {
        spawnBird()
    }
    
    
    @objc
    func stop() {
        mainTimer.invalidate()
        timer.invalidate()
        gameScene?.addScore(score: 200)
        self.gameScene?.endRound()
    }
    
    //MARK: - SKPhysicsContactDelegate
    
    func didBegin(_ contact: SKPhysicsContact) {
        switch contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask {
        case CategoryMask.egg.rawValue | CategoryMask.spaceShip.rawValue:
            var egg: SKSpriteNode?
            if let _ = contact.bodyA.node as? SpaceShip {
                egg = (contact.bodyB.node as! SKSpriteNode)
            } else {
                egg = (contact.bodyA.node as! SKSpriteNode)
            }
            egg?.removeFromParent()
            self.gameScene?.endGame()
        case CategoryMask.bullet.rawValue | CategoryMask.enemy.rawValue:
            var bird: Bird?
            var bullet: SKSpriteNode?
            if let selectedBird = contact.bodyA.node as? Bird {
                bird = selectedBird
                bullet = (contact.bodyB.node as? SKSpriteNode)
            } else {
                bird = (contact.bodyB.node as? Bird)
                bullet = (contact.bodyA.node as? SKSpriteNode)
            }
            bird?.health -= 1
            if let bird = bird, bird.health <= 0 {
                gameScene?.addScore(score: 20)
                bird.die()
                bird.removeFromParent()
            }
            bullet?.removeFromParent()
        case CategoryMask.spaceShip.rawValue | CategoryMask.enemy.rawValue:
            self.gameScene?.endGame()
        default:
            break
        }
    }
}
