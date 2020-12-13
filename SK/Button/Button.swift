//
//  Button.swift
//  SK
//
//  Created by admin on 18.11.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import SpriteKit

class Button: SKSpriteNode {
    
    fileprivate var title: SKLabelNode!
    var delegate: ButtonProtocol?
    var tag: Int!
    
    
    var titleText: String? {
        willSet {
            if title != nil {
                title.text = newValue
            }
        }
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
       setupView()
    }
    
    //MARK: - Private
    
    fileprivate func setupView() {
        texture = drawTexture()
        isUserInteractionEnabled = true
        
        if let titleText = titleText {
            title.text = titleText
        }
        findChildren()
    }
    
    fileprivate func drawTexture() -> SKTexture {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rectPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: 8)
        rectPath.lineWidth = 5
        rectPath.addClip()
        
        SKColor.clear.set()
        rectPath.fill()
        SKColor.white.set()
        rectPath.stroke()
        
        let textureImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return SKTexture(image: textureImage)
        
    }
    
    fileprivate func findChildren() {
        title = (self.childNode(withName: "title") as! SKLabelNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = delegate {
            delegate?.tapToButton(tag: tag)
        }
    }
}
