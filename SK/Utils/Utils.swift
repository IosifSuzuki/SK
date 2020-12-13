//
//  Utils.swift
//  SK
//
//  Created by admin on 12.11.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import SpriteKit

extension CGVector {
    static func * (left: CGVector, right: CGFloat) -> CGVector {
        return CGVector(dx: left.dx * right, dy: left.dy * right)
    }
}

extension SKScene {
    func shakeAndFlash() {
        guard let view = view else { return }
        let flashView = UIView(frame: view.frame)
        flashView.backgroundColor = .white
        view.addSubview(flashView)
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut) {
            flashView.alpha = 0
        } completion: { (completed) in
            if completed {
                flashView.removeFromSuperview()
            }
        }
        let shakeAnimation = CAKeyframeAnimation(keyPath: "transform")
        shakeAnimation.values = [
            NSValue(caTransform3D: CATransform3DMakeTranslation(-15, 5, 5)),
            NSValue(caTransform3D: CATransform3DMakeTranslation(15, 5, 5)),
        ]
        shakeAnimation.autoreverses = true
        shakeAnimation.repeatCount = 2
        shakeAnimation.duration = 0.1
        view.layer.add(shakeAnimation, forKey: nil)
    }
    
    func pulse(label: SKLabelNode) {
        let scaleAction = SKAction.scale(by: 0.9, duration: 0.2)
        let reversedScaleAction =  SKAction.scale(by: 1.1, duration: 0.2)
        label.run(SKAction.sequence([scaleAction, reversedScaleAction]))
    }
}

func distance(firstPoint: CGPoint, secondPoint: CGPoint, sizeScene: CGSize) -> Double {
    let xDist = abs((firstPoint.x + sizeScene.width / 2) - (secondPoint.x + sizeScene.width / 2))
    let yDist = abs((firstPoint.y + sizeScene.height / 2) - (secondPoint.y + sizeScene.height / 2))
    return Double(sqrt(xDist * xDist + yDist * yDist))
}

func grad(toRadian grad: Double) -> Double {
    return grad * Double.pi / 180
}

func offsetX(height: Double, grad: Double) -> Double {
    return sin(grad) * height
}
