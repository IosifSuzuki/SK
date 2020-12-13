//
//  JoystickDelegate.swift
//  SK
//
//  Created by admin on 12.11.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import SpriteKit

protocol JoystickDelegate {
    
    func joistickBeginMove(joistick: Joisktick)
    func joistickMoving(joistick: Joisktick, byAngle angle: CGFloat, directionVector: CGVector)
    func joistickEndMove(joistick: Joisktick)
    
}
