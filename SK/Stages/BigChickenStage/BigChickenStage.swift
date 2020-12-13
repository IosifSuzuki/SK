//
//  BigChickenStage.swift
//  SK
//
//  Created by admin on 27.11.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import SpriteKit

class BigChickenStage: BaseStage {
    
    var bigChicken: BigChicken!
    
    override func start() {
        spawnBigChicken()
        setupActions()
    }
    
    //MARK: - Private
    
    fileprivate func spawnBigChicken() {
        guard let gameScene = gameScene else { return }
        let sizeOfBigChicken = CGSize(width: 500, height: 500)
        bigChicken = BigChicken(texture: nil, color: .clear, size: sizeOfBigChicken)
        bigChicken.position = CGPoint(x: 0, y: gameScene.size.height / 2 + sizeOfBigChicken.height / 2)
        gameScene.addChild(bigChicken)
    }
    
    fileprivate func setupActions() {
        guard let gameScene = gameScene else { return }
        let yPosition = gameScene.size.height / 2 - bigChicken.size.height / 2
        let moveToLeft = SKAction.move(to: CGPoint(x: -(gameScene.size.width / 2 - bigChicken.size.width / 2), y: yPosition), duration: 2)
        let moveToRight = SKAction.move(to: CGPoint(x: (gameScene.size.width / 2 - bigChicken.size.width / 2), y: yPosition), duration: 2)
        bigChicken.run(SKAction.move(to: CGPoint(x: 0, y: yPosition), duration: 0.5)) {
            self.bigChicken.prepareCastEgg()
            self.bigChicken.run(SKAction.repeatForever(SKAction.sequence([moveToLeft, moveToRight])))
        }
    }
    
    override func end() {
        bigChicken.removeFromParent()
    }
    
    //MARK: - SKPhysicsContactDelegate
    
    func didBegin(_ contact: SKPhysicsContact) {
        switch contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask {
        case CategoryMask.spaceShip.rawValue | CategoryMask.present.rawValue:
            var present: SKSpriteNode!
            if let _ = contact.bodyA.node as? SpaceShip {
                present = (contact.bodyB.node as! SKSpriteNode)
            } else {
                present = (contact.bodyA.node as! SKSpriteNode)
            }
            self.gameScene?.addHealth()
            present.removeFromParent()
            self.gameScene?.endRound()
        case CategoryMask.egg.rawValue | CategoryMask.spaceShip.rawValue:
            var egg: SKSpriteNode!
            if let _ = contact.bodyA.node as? SpaceShip {
                egg = (contact.bodyB.node as! SKSpriteNode)
            } else {
                egg = (contact.bodyA.node as! SKSpriteNode)
            }
            egg.removeFromParent()
            self.gameScene?.endGame()
        case CategoryMask.bullet.rawValue | CategoryMask.enemy.rawValue:
            var bigChicken: BigChicken!
            var bullet: SKSpriteNode!
            if let selectedBigChicken = contact.bodyA.node as? BigChicken {
                bigChicken = selectedBigChicken
                bullet = (contact.bodyB.node as! SKSpriteNode)
            } else {
                bigChicken = (contact.bodyB.node as! BigChicken)
                bullet = (contact.bodyA.node as! SKSpriteNode)
            }
            bigChicken.health -= 1
            if (bigChicken.health <= 0) {
                bigChicken.explode {
                    self.gameScene?.addScore(score: 500)
                    self.gameScene?.endRound()
                }
            }
            bullet.removeFromParent()
        default:
        break
        }
    }
}
