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
    
    // 罰ゲーム内容
    var initPunishmentGames = [String: String]()
    // 罰ゲームシャッフルする用
    var displayButtonPunishmentGames = [String]()
    // 選択されたボタン保持
    var selectedTagArray = [Int]()
    // 選択された罰ゲーム数保存用
    var numberPunishmentGamesDisplayed = 0
    // 初回のシャッフルかどうか
    var firstShuffleFlag = true
    // 罰ゲームを多重に選択できない様
    var firstSetPubnishCountFlag = true
    // 選択済みがどうか
    var selectedFlag = false
    var timerStopFlag = true
    // 初回爆破個数保存
    var initNumExplosions = 1
    // 爆破した個数を保存
    var countExplosions = 0
    // タイマーカウント保持
    var timerCount = 0
    // リセットフラグ
    var resetFlag = false
}

