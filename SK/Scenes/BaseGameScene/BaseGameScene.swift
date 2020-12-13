//
//  BaseGameScene.swift
//  SK
//
//  Created by admin on 22.11.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import SpriteKit
import AVFoundation

class BaseGameScene: SKScene {
    
    var backgroundsContainer: SKNode!
    
    //MARK: - Public
    
    func setupBackground() {
        backgroundsContainer = SKNode()
        let backgroundTexture = SKTexture(imageNamed: "background")
        let moveBackgroundAction = SKAction.moveBy(x: 0, y: -size.height, duration: 3)
        let replaceBackgroundAction = SKAction.moveBy(x: 0, y: size.height, duration: 0)
        let moveBackgroundForever = SKAction.repeatForever(SKAction.sequence([moveBackgroundAction, replaceBackgroundAction]))
        
        for i in 0..<3 {
            let background = SKSpriteNode(texture: backgroundTexture)
            background.position = CGPoint(x: 0, y: size.height * CGFloat(i))
            background.size = size
            background.run(moveBackgroundForever)
            background.zPosition = 0
            backgroundsContainer.addChild(background)
        }
        addChild(backgroundsContainer)
    }
    
}
