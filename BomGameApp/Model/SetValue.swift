//
//  SetValue.swift
//  BomGameApp
//
//  Created by 祥平 on 2022/01/24.
//

import Foundation

class SetValue {
    private init() {}
    static let shared = SetValue()
    
    var initPunishmentGames = [String: String]()
    var displayButtonPunishmentGames = [String]()
    var selectedTagArray = [Int]()
    var numberPunishmentGamesDisplayed = 0
    var firstShuffleFlag = true
    var firstSetPubnishCountFlag = true
    var selectedFlag = false
    var timerStopFlag = true
    var initNumExplosions = 1
    var countExplosions = 0
    var timerCount = 0
}

