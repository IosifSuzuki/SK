//
//  GameScene.swift
//  SK
//
//  Created by admin on 11.11.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import SpriteKit
import GameplayKit

class MainGameScene: SKScene {
    var sizeScreen: CGSize!
    var joistick: Joisktick!
    var spaceShip: SpaceShip!
    var backgroundsContainer: SKNode!
    
    override func didMove(to view: SKView) {
        
        setupObjects()
    }
    
    //MARK: - Private
    
    fileprivate func setupObjects() {
        sizeScreen = UIScreen.main.bounds.size
        
        setupJoistick()
        setupSpaceShip()
        setupBackground()
    }
    
    fileprivate func setupSpaceShip() {
        let spaceShip = SpaceShip(texture: SKTexture(imageNamed: "spaceShip"))
        spaceShip.setScale(0.15)
        spaceShip.zPosition = 1
        spaceShip.position = CGPoint(x: 0, y: joistick.position.y)
        addChild(spaceShip)
    }
    
    fileprivate func setupJoistick() {
        joistick = Joisktick(withRadius: 75, baseColor: AppColor.JoistickFillColor.color(), strokeColor: AppColor.JoystickBorderColor.color())
        joistick.zPosition = 1
        joistick.position = CGPoint(x: -sizeScreen.width + joistick.size.width, y: -sizeScreen.height + joistick.size.height + CGFloat(Constants.generalIndent))
        addChild(joistick)
    }
    
    fileprivate func setupBackground() {
        backgroundsContainer = SKNode()
        let backgroundTexture = SKTexture(imageNamed: "background")
        let moveBackgroundAction = SKAction.moveBy(x: 0, y: -sizeScreen.height, duration: 3)
        let replaceBackgroundAction = SKAction.moveBy(x: 0, y: sizeScreen.height, duration: 0)
        let moveBackgroundForever = SKAction.repeatForever(SKAction.sequence([moveBackgroundAction, replaceBackgroundAction]))
        
        for i in 0..<3 {
            let background = SKSpriteNode(texture: backgroundTexture)
            background.position = CGPoint(x: 0, y: sizeScreen.height * CGFloat(i))
            background.size = sizeScreen
            background.setScale(2)
            background.run(moveBackgroundForever)
            backgroundsContainer.addChild(background)
        }
        addChild(backgroundsContainer)
    }
}

extension
