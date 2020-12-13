//
//  Resourcemanager.swift
//  SK
//
//  Created by admin on 11.12.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import SpriteKit

class ResourceManager {
    
    static let shared = ResourceManager()
    
    let actionSoundOfExplosion: SKAction
    
    init() {
        self.actionSoundOfExplosion = SKAction.playSoundFileNamed("Explosion.wav", waitForCompletion: false)
    }
}
