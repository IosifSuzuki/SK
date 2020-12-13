//
//  StageProtocol.swift
//  SK
//
//  Created by admin on 14.11.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

protocol StageProtocol {
    func endGame()
    func startRound()
    func endRound()
    func moveToStartPosition(withCompletionBlock completionBlock:@escaping () -> Void)
    func addScore(score: Int)
    func addHealth()
}
