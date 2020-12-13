//
//  RecordsScene.swift
//  SK
//
//  Created by admin on 22.11.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import SpriteKit

class RecordsScene: BaseGameScene {
    
    var backButton: Button!
    
    var firstPlaceLabel: SKLabelNode!
    var secondPlaceLabel: SKLabelNode!
    var thirdPlaceLabel: SKLabelNode!
    var fourthPlaceLabel: SKLabelNode!
    var fivethPlaceLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        setupScene()
//        RecordsManager.shared.addRecord(score: 300)
//        RecordsManager.shared.addRecord(score: 250)
//        RecordsManager.shared.addRecord(score: 200)
//        RecordsManager.shared.addRecord(score: 150)
//        RecordsManager.shared.addRecord(score: 100)
//        RecordsManager.shared.addRecord(score: 50)

    }
    
    //MARK: - Private
    
    fileprivate func setupScene() {
        backButton = (childNode(withName: "backButton") as! Button)
        backButton.position = CGPoint(x: -size.width / 2 + backButton.size.width / 2 , y: size.height / 2 - backButton.size.height / 2)
        backButton.texture = nil
        backButton.tag = 0
        backButton.delegate = self
        
        if let containerNode = childNode(withName: "containerLabels") {
            firstPlaceLabel = (containerNode.childNode(withName: "firstPlaceLabel") as! SKLabelNode)
            secondPlaceLabel = (containerNode.childNode(withName: "secondPlaceLabel") as! SKLabelNode)
            thirdPlaceLabel = (containerNode.childNode(withName: "thirdPlaceLabel") as! SKLabelNode)
            fourthPlaceLabel = (containerNode.childNode(withName: "fourthPlaceLabel") as! SKLabelNode)
            fivethPlaceLabel = (containerNode.childNode(withName: "fivethPlaceLabel") as! SKLabelNode)
        } else {
            fatalError("Dont linked container")
        }
        
        setupBackground()
        fetchRecords()
    }
    
    fileprivate func fetchRecords() {
        let records = RecordsManager.shared.getRecords()
        let labels = [
            firstPlaceLabel,
            secondPlaceLabel,
            thirdPlaceLabel,
            fourthPlaceLabel,
            fivethPlaceLabel,
        ]
        
        for idx in 0 ..< labels.count {
            if records.count > idx {
                labels[idx]?.text = "#\(idx + 1) \(records[idx].score)"
            } else {
                labels[idx]?.isHidden = true
            }
        }
    }
}

extension RecordsScene: ButtonProtocol {
    func tapToButton(tag: Int) {
        if let mainMenuScene = SKScene(fileNamed: "MainMenuScene") {
            let transition = SKTransition.push(with: .right, duration: 0.3)
            view?.presentScene(mainMenuScene, transition: transition)
        }
    }
}
