//
//  MainMenuScene.swift
//  SK
//
//  Created by admin on 18.11.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import SpriteKit

class MainMenuScene: BaseGameScene {
    
    enum MainMenuButton: Int {
        case newGame
        case records
        case sound
        case exit
    }
    
    static let keyIsEnableAudio = "keyIsEnableAudio"
    
    var container: SKNode!
    var newGameButton: Button!
    var recordButton: Button!
    var soundButton: Button!
    var exitButton: Button!
    
    var isEnableSound: Bool? {
        willSet {
            if let newValue = newValue {
                UserDefaults.standard.set(newValue, forKey: MainMenuScene.keyIsEnableAudio)
                self.soundButton.titleText = newValue ? "Sound: Off" : "Sound: On"
                backgroundMusic(play: newValue)
            }
        }
    }
    
    override func didMove(to view: SKView) {
        setupScene()
    }
    
    //MARK: - Private
    
    func setupScene() {
        container = self.childNode(withName: "container")
        newGameButton = container?.childNode(withName: "newGame") as? Button
        recordButton =  container?.childNode(withName: "records") as? Button
        soundButton = container?.childNode(withName: "sound") as? Button
        exitButton = container?.childNode(withName: "exit") as? Button
        
        if let isEnableSound = UserDefaults.standard.value(forKey: MainMenuScene.keyIsEnableAudio) as? Bool {
            self.isEnableSound = isEnableSound
        } else {
            isEnableSound = false
        }
        
        let buttons = [
            newGameButton,
            recordButton,
            soundButton,
            exitButton,
        ]
        
        for i in 0..<buttons.count {
            if let button = buttons[i] {
                button.delegate = self
                button.tag = i
            }
        }
        
        setupBackground()
    }
    
    func backgroundMusic(play: Bool) {
        if play {
            BackgroundMusicManager.shared.play()
        } else {
            BackgroundMusicManager.shared.pause()
        }
    }
}

extension MainMenuScene: ButtonProtocol {
    
    func tapToButton(tag: Int) {
        let sceneSize = CGSize(width: 750, height: 1334)
        switch MainMenuButton.init(rawValue: tag) {
        case .newGame:
            let mainGameScene = MainGameScene(size: sceneSize)
            mainGameScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            let transition = SKTransition.crossFade(withDuration: 0.3)
            view?.presentScene(mainGameScene, transition: transition)
        case .records:
            if let recordsScene = SKScene(fileNamed: "RecordsScene") {
                recordsScene.size = sceneSize
                let transition = SKTransition.push(with: .left, duration: 0.3)
                view?.presentScene(recordsScene, transition: transition)
            }
            break
        case .sound:
            isEnableSound?.toggle()
        case .exit:
            exit(0)
        default:
            break
        }
    }
    
}
