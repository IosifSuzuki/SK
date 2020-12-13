//
//  GameScene.swift
//  SK
//
//  Created by admin on 11.11.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import SpriteKit
import GameplayKit

class MainGameScene: BaseGameScene {
    
    static var sizeScreen: CGSize!
    
    var joistick: Joisktick!
    var spaceShip: SpaceShip!
    var scoreLabel: SKLabelNode!
    var heart: SKSpriteNode!
    var countOfheartLabel: SKLabelNode!
    
    var stages: [BaseStage]!
    
    var currentStageIndex = 0
    
    var beginUpdateJoistick: TimeInterval!
    var achieveFullSpeedThrough = 0.5
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
            guard let scoreLabel = scoreLabel  else { return }
            pulse(label: scoreLabel)
        }
    }
    var health = 3 {
        didSet {
            if health >= 0 {
                guard let countOfheartLabel = countOfheartLabel  else { return }
                countOfheartLabel.text = "x \(health)"
                pulse(label: countOfheartLabel)
            }
        }
    }
    
    override func didMove(to view: SKView) {
        
        prepareStages()
        setupObjects()
    }
    
    //MARK: - Private
    
    fileprivate func setupObjects() {
        MainGameScene.sizeScreen = size
        physicsWorld.gravity = CGVector(dx:0, dy:0)
        
        setupJoistick()
        setupSpaceShip()
        setupBackground()
        setupScoreLabel()
        setupHeartUI()
    }
    
    fileprivate func prepareStages() {
        stages = [
            FlyStage(gameScene: self),
            BigChickenStage(gameScene: self),
            FlyStage(gameScene: self),
            FallingMeteoriteStage(gameScene: self),
            FlyStage(gameScene: self),
            BirdAtackStage(gameScene: self),

        ]
        endRound()
    }
    
    fileprivate func setupSpaceShip() {
        spaceShip = SpaceShip(texture: SKTexture(imageNamed: "spaceShip"))
        spaceShip.zPosition = 1
        spaceShip.position = CGPoint(x: 0, y: spaceShip.screenRect.origin.y)
        addChild(spaceShip)
    }
    
    fileprivate func setupJoistick() {
        joistick = Joisktick(withRadius: 75, baseColor: AppColor.JoistickFillColor.color(), strokeColor: AppColor.JoystickBorderColor.color())
        joistick.delegate = self
        joistick.zPosition = 1
        let newX = -size.width / 2 + joistick.size.width / 2 + CGFloat(Constants.generalIndent)
        let newY = -size.height / 2 + joistick.size.height / 2 + CGFloat(Constants.generalIndent)
        joistick.position = CGPoint(x:newX, y:newY)
        addChild(joistick)
    }
    
    fileprivate func setupScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        score = 0
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: size.width / 2 - CGFloat(Constants.generalIndent), y: size.height / 2 -  CGFloat(Constants.generalIndent) - scoreLabel.fontSize)
        scoreLabel.fontColor = .white
        scoreLabel.zPosition = 1
        addChild(scoreLabel)
    }
    
    fileprivate func setupHeartUI() {
        heart = SKSpriteNode(imageNamed: "heart")
        heart.size = CGSize(width: 50, height: 50)
        heart.zPosition = 2
        let heartOffsetX = CGFloat(size.width / 2) - CGFloat(Constants.generalIndent) - CGFloat(heart.size.width / 2)
        let heartOffsetY = -size.height / 2 +  2 * CGFloat(Constants.generalIndent) + heart.size.height / 2
        heart.position = CGPoint(x: heartOffsetX, y: heartOffsetY)
        let scaleAction = SKAction.scale(to: CGSize(width: 60, height: 60), duration: 0.5)
        let reversedScaleAction = SKAction.scale(to: CGSize(width: 50, height: 50), duration: 0.5)
        heart.run(SKAction.repeatForever(SKAction.sequence([scaleAction, reversedScaleAction])))
        addChild(heart)
        
        let spaceBetweenLabelAndHeart: CGFloat = 20
        countOfheartLabel = SKLabelNode(fontNamed: "Chalkduster")
        countOfheartLabel.horizontalAlignmentMode = .right
        let countOfheartOffsetX = heart.position.x - (heart.size.width / 2) - spaceBetweenLabelAndHeart
        let countOfheartOffsetY = heart.position.y - countOfheartLabel.fontSize / 2
        countOfheartLabel.position = CGPoint(x: countOfheartOffsetX, y: countOfheartOffsetY)
        countOfheartLabel.fontColor = .white
        countOfheartLabel.zPosition = 2
        health = 3
        addChild(countOfheartLabel)
    }
    
    //MARK: - Handle
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentStageIndex != -1 {
            spaceShip.fire()
        } else {
            if let mainMenuScene = SKScene(fileNamed: "MainMenuScene") {
                let transition = SKTransition.doorway(withDuration: 1)
                self.view?.presentScene(mainMenuScene, transition: transition)
            }
        }
    }
}

extension MainGameScene: JoystickDelegate {
    func joistickBeginMove(joistick: Joisktick) {
        beginUpdateJoistick = Date().timeIntervalSinceReferenceDate
    }
    
    func joistickMoving(joistick: Joisktick, byAngle angle: CGFloat, directionVector: CGVector) {
        var speedKoef = (Date().timeIntervalSinceReferenceDate - beginUpdateJoistick) / achieveFullSpeedThrough
        if speedKoef > 1 {
            speedKoef = 1
        }
        let speedVector = directionVector * (spaceShip.speed * CGFloat(speedKoef))
        spaceShip.trackPosition = CGPoint(x: spaceShip.position.x + speedVector.dx , y: spaceShip.position.y + speedVector.dy)
    }
    
    func joistickEndMove(joistick: Joisktick) {
        beginUpdateJoistick = nil
    }
    
}

extension MainGameScene: StageProtocol {
    
    func startRound() {
        //toDo
    }
    
    func endRound() {
        currentStageIndex = (currentStageIndex + 1) % stages.count
        physicsWorld.contactDelegate = stages[currentStageIndex]
        stages[currentStageIndex].start()
    }
    
    func moveToStartPosition(withCompletionBlock completionBlock:@escaping () -> Void) {
        let startPosition = CGPoint(x: 0, y: spaceShip.screenRect.origin.y)
        let spaceShipPosition =  spaceShip.position
        let timeRunToStartPosition = distance(firstPoint: startPosition, secondPoint: spaceShipPosition, sizeScene: size) / spaceShip.speedPerSecond
        let moveToStartPositionAction = SKAction.move(to: startPosition, duration: timeRunToStartPosition)
        
        if spaceShip.isFire {
            spaceShip.fire()
        }
        
        spaceShip.run(moveToStartPositionAction, completion: completionBlock)
    }
    
    func addScore(score: Int) {
        self.score += score
    }
    
    func addHealth() {
        health += 1
    }
    
    func endGame() {
        health -= 1
        if currentStageIndex != -1 && health <= 0 {
            stages[currentStageIndex].end()
            currentStageIndex = -1
            let _ = RecordsManager.shared.addRecord(score: Int64(self.score))
            
            if spaceShip.isFire {
                spaceShip.fire()
            }
            
            shakeAndFlash()
        }
    }
    
}
