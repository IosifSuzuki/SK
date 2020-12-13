//
//  FlyStage.swift
//  SK
//
//  Created by admin on 14.11.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import SpriteKit

class FlyStage: BaseStage {
    var mainTimer: Timer!
    let timeDuration: TimeInterval = 10
    
    override func start() {
        mainTimer = Timer.scheduledTimer(timeInterval: timeDuration, target: self, selector: #selector(stop), userInfo: nil, repeats: false)
    }
    
    //MARK: - Handler
    
    @objc
    func stop() {
        mainTimer.invalidate()
        gameScene?.moveToStartPosition {
            self.gameScene?.endRound()
        }
    }
}
