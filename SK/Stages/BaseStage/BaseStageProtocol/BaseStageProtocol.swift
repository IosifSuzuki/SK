//
//  BaseStageProtocol.swift
//  SK
//
//  Created by admin on 14.11.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import SpriteKit

@objc
protocol BaseStageProtocol {
    func start()
    
    @objc
    optional func end()
}
