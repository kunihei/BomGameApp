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
    
    var punishmentGames = [String: String]()
    var punishmentGamesList: [String] = []
    var arrayButtonTag = [Int]()
    var firstShuffleFlag = true
    var selectedFlag = false
    var timerStopFlag = true
    var numExplosions = 1
    var timerCount = 0
}

