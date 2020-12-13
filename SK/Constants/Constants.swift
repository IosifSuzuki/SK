//
//  Constants.swift
//  SK
//
//  Created by admin on 12.11.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import SpriteKit

enum AppColor {
    case JoystickBorderColor
    case JoistickFillColor
    
    func color() -> SKColor {
        switch self {
        case .JoistickFillColor:
            return color(red: 240, green: 240, blue: 240, alpha: 1)
        case .JoystickBorderColor:
            return color(red: 60, green: 60, blue: 60, alpha: 1)
        default:
            return .white
        }
    }
    
    fileprivate func color(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> SKColor {
        return SKColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
}

struct Constants {
    static let generalIndent: Float64 = 15
}
