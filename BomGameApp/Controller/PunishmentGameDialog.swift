//
//  PunishmentGameDialog.swift
//  BomGameApp
//
//  Created by 祥平 on 2022/04/03.
//

import UIKit
import LTMorphingLabel

class PunishmentGameDialog: UIViewController {

    @IBOutlet weak var punishmentExplanationLabel: LTMorphingLabel!
    @IBOutlet weak var punishmentGameLabel1: UILabel!
    @IBOutlet weak var punishmentGameLabel2: UILabel!
    @IBOutlet weak var punishmentGameLabel3: UILabel!
    @IBOutlet weak var punishmentGameLabel4: UILabel!
    
    private let titleLabelArray = ["時間が切れたので", "あなたひとりで", "全ての罰ゲームを", "実行してください☠️"]
    private let setValue = SetValue.shared
    
    private var outputArrayLabel = [UILabel]()
    private var arrayLabel = [UILabel]()
    private var timer: Timer?
    private var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrayLabel = [
            punishmentGameLabel1,
            punishmentGameLabel2,
            punishmentGameLabel3,
            punishmentGameLabel4
        ]
        if setValue.punishmentGamesList.count == 0 {
            let tmpPunishmentGameList = setValue.punishmentGames
            for (key, val) in tmpPunishmentGameList { setValue.punishmentGamesList.append(val) }
        }
        
        for tmp in 0..<arrayLabel.count {
            if tmp >= 0 && tmp < setValue.punishmentGamesList.count {
                outputArrayLabel.append(arrayLabel[tmp])
                continue
            }
            arrayLabel[tmp].isHidden = true
        }
        
        for i in 0..<outputArrayLabel.count {
            outputArrayLabel[i].text = setValue.punishmentGamesList[i]
        }
        
        punishmentExplanationLabel.text = titleLabelArray[index]
        punishmentExplanationLabel.morphingEffect = .burn
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(updateTimer(timer:)), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    
    @objc func updateTimer(timer: Timer) {
        punishmentExplanationLabel.text = titleLabelArray[index]
        index += 1
        if index >= titleLabelArray.count { index = 0 }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}