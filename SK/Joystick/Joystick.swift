//
//  Joystick.swift
//  SK
//
//  Created by admin on 12.11.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import SpriteKit

class Joisktick: SKSpriteNode {
    var joistickBall: SKSpriteNode!
    let radius: CGFloat
    let baseColor: SKColor
    let strokeColor: SKColor
    var angle: CGFloat
    var delegate: JoystickDelegate? {
        didSet {
            displayLink = CADisplayLink(target: self, selector: #selector(listen))
        }
    }
    var displayLink: CADisplayLink!
    
    init(withRadius radius: CGFloat, baseColor: SKColor, strokeColor: SKColor) {
        self.radius = radius
        self.baseColor = baseColor
        self.strokeColor = strokeColor
        self.angle = 0
        let size = CGSize(width: radius * 2, height: radius * 2)
        super.init(texture: nil, color: UIColor.clear, size: size)
        self.isUserInteractionEnabled = true
        drawTextures()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        displayLink.invalidate()
    }
    
    //MARK: - Private
    
    private func drawTextures() {
        texture = redrawTexture(withDiameter: radius * 2, lineWidth: 10, fillColor: .clear, strokeColor: strokeColor)
        joistickBall = SKSpriteNode(texture: redrawTexture(withDiameter: radius, lineWidth: 10, fillColor: baseColor, strokeColor: baseColor))
        joistickBall.zPosition = zPosition + 1
        addChild(joistickBall)
    }
    
    private func redrawTexture(withDiameter diameter: CGFloat, lineWidth: CGFloat, fillColor: SKColor, strokeColor: SKColor) -> SKTexture {
        let scale = UIScreen.main.scale
        let needSize = CGSize(width: diameter, height: diameter)

        UIGraphicsBeginImageContextWithOptions(needSize, false, scale)
        let rectPath = UIBezierPath(ovalIn: CGRect(origin: .zero, size: needSize))
        rectPath.lineWidth = lineWidth
        rectPath.addClip()
        
        fillColor.set()
        rectPath.fill()
        strokeColor.set()
        rectPath.stroke()
        
        let textureImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return SKTexture(image: textureImage)
    }
    
    //MARK: - Handler
    
    @objc
    func listen() {
        if let delegate = delegate {
            delegate.joistickMoving(joistick: self, byAngle: angle, directionVector: CGVector(dx: joistickBall.position.x, dy: joistickBall.position.y))
        }
    }
    
    //MARK: - Override
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let delegate = delegate {
            delegate.joistickBeginMove(joistick: self)
            displayLink.add(to: .main, forMode: .common)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches as Set<UITouch>) {
            let location = touch.location(in: self)
            angle = atan2(location.y, location.x)
            let offset = radius / 2
            let newXPosition = cos(angle) * offset
            let newYPosition = sin(angle) * offset
            joistickBall.position = CGPoint(x: newXPosition, y: newYPosition)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        joistickBall.position = .zero
        
        if let delegate = delegate {
            delegate.joistickEndMove(joistick: self)
            displayLink.remove(from: .main, forMode: .common)
        }
    }
}
