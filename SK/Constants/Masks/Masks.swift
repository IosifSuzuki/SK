//
//  CategoryBitMask.swift
//  SK
//
//  Created by admin on 15.11.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import SpriteKit

enum CategoryMask: UInt32 {
    case spaceShip =   0b00001
    case enemy =       0b00010
    case egg =         0b00100
    case bullet =      0b01000
    case present =     0b10000
}
