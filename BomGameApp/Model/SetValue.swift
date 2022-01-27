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
    
    var timerCount = 0
    var punishmentGames = [String: String]()
    var numExplosions = 1
}

