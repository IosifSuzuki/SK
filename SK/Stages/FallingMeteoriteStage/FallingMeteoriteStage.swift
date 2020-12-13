//
//  FallingMeteorite.swift
//  SK
//
//  Created by admin on 14.11.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import SpriteKit

class FallingMeteoriteStage: BaseStage {
    
    static let LeftBoundMaxAngle: Double = 10
    static let RightBoundMaxAngle: Double = -10
    
    let timeDuration: TimeInterval = 30
    let timeInterval: TimeInterval = 0.3
    let meteorTexture: SKTexture!
    var mainTimer: Timer!
    var timer: Timer!
    var gradFall: Double!
    
    required init(gameScene: SKScene & StageProtocol) {
        self.meteorTexture = SKTexture(imageNamed: "meteor")
        super.init(gameScene: gameScene)
    }
    
    //MARK: - BaseStage
    
    override func start() {
        gradFall = [grad(toRadian: FallingMeteoriteStage.LeftBoundMaxAngle), grad(toRadian: 0), grad(toRadian: FallingMeteoriteStage.RightBoundMaxAngle)][Int(arc4random_uniform(3))]
        mainTimer = Timer.scheduledTimer(timeInterval: timeDuration, target: self, selector: #selector(stop), userInfo: nil, repeats: false)
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(handlerTimer), userInfo: nil, repeats: true)
    }
    
    override func end() {
        gameScene?.enumerateChildNodes(withName: Meteor.name) { (node, _) in
            node.removeFromParent()
        }
        mainTimer.invalidate()
        timer.invalidate()
        gameScene?.endRound()
    }
    
    //MARK: - Handler
    
    @objc
    fileprivate func stop() {
        timer.invalidate()
        gameScene?.addScore(score: 200)
        gameScene?.endRound()
    }
    
    @objc
    fileprivate func handlerTimer() {
        spawnMeteor()
    }
    
    @objc
    fileprivate func spawnMeteor() {
        guard let gameScene = gameScene else { return }
        let sizeOfMeteor = CGFloat(arc4random() % 80 + 80)
        let maxOffsetX = gameScene.size.width + CGFloat(offsetX(height: offsetX(height: Double(gameScene.size.height + 160), grad: gradFall), grad: gradFall))
        let rangeX = CGFloat(arc4random() % UInt32(2 * maxOffsetX))
        let startXPosition = rangeX - maxOffsetX
        let moveDuration = TimeInterval(arc4random() % 3)
        let endXPosition = Double(startXPosition) + offsetX(height: Double(gameScene.size.height + sizeOfMeteor), grad: gradFall)
        
        let meteor = Meteor(texture: meteorTexture, size: CGSize(width: sizeOfMeteor, height: sizeOfMeteor))
        meteor.name = Meteor.name
        meteor.position = CGPoint(x: startXPosition, y: gameScene.size.height / 2)
        gameScene.addChild(meteor)
        
        let moveMeteorAction = SKAction.move(to: CGPoint(x: CGFloat(endXPosition), y: -gameScene.size.height / 2 - meteor.size.height), duration: moveDuration)
        let rotationMeteorAction = SKAction.rotate(byAngle:CGFloat(2 * Double.pi), duration: 6)
        let coloraziAction = SKAction.colorize(with: .red, colorBlendFactor: 0.75, duration: moveDuration)
        let removeFromParentAction = SKAction.removeFromParent()
        meteor.run(SKAction.sequence([SKAction.group([coloraziAction, moveMeteorAction]), removeFromParentAction]))
        meteor.run(SKAction.repeatForever(rotationMeteorAction))
    }
    
    //MARK: - SKPhysicsContactDelegate
    
    func didBegin(_ contact: SKPhysicsContact) {
        switch contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask {
        case CategoryMask.enemy.rawValue | CategoryMask.bullet.rawValue:
            var meteor: Meteor!
            var bullet: SKSpriteNode!
            if contact.bodyA.categoryBitMask == CategoryMask.enemy.rawValue {
                meteor = (contact.bodyA.node as! Meteor)
                bullet = (contact.bodyB.node as! SKSpriteNode)
            } else {
                meteor = (contact.bodyB.node as! Meteor)
                bullet = (contact.bodyA.node as! SKSpriteNode)
            }
            meteor.explode()
            gameScene?.addScore(score: 5)
            bullet.removeFromParent()
        case CategoryMask.enemy.rawValue | CategoryMask.spaceShip.rawValue:
            var meteor: Meteor!
            if contact.bodyA.categoryBitMask == CategoryMask.enemy.rawValue {
                meteor = (contact.bodyA.node as! Meteor)
            } else {
                meteor = (contact.bodyB.node as! Meteor)
            }
            meteor.explode()
            self.gameScene?.endGame()
        default:
            break
        }
    }
}
