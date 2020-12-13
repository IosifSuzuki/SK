//
//  BackgroundMusicManager.swift
//  SK
//
//  Created by admin on 23.11.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import AVFoundation

class BackgroundMusicManager {
    
    static let shared = BackgroundMusicManager()
    
    var backgroundMusicPlayer: AVAudioPlayer?
    
    init() {
        let url = Bundle.main.url(forResource: "backgroundMusic", withExtension: "mp3")

        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url!)
            backgroundMusicPlayer?.numberOfLoops = -1
            backgroundMusicPlayer?.prepareToPlay()
            backgroundMusicPlayer?.play()
        } catch {
            backgroundMusicPlayer = nil
            print("Error")
        }
    }
    
    func play() {
        backgroundMusicPlayer?.play()
    }
    
    func pause() {
        backgroundMusicPlayer?.pause()
    }
}
