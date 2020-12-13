//
//  BaseStage.swift
//  SK
//
//  Created by admin on 14.11.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import SpriteKit

class BaseStage: NSObject {
    weak var gameScene: (SKScene & StageProtocol)?
    
    required init(gameScene: SKScene & StageProtocol) {
        self.gameScene = gameScene
    }
}

extension BaseStage: BaseStageProtocol {
    @objc
    func start() {}
    
    @objc
    func end() {}
}

extension BaseStage: SKPhysicsContactDelegate {
    
}
