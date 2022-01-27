//
//  PlayViewController.swift
//  BomGameApp
//
//  Created by 祥平 on 2022/01/22.
//

import UIKit
import RxSwift
import RxCocoa

class PlayViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var reset: UIButton!
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var bom1: UIButton!
    @IBOutlet weak var bom2: UIButton!
    @IBOutlet weak var bom3: UIButton!
    @IBOutlet weak var bom4: UIButton!
    @IBOutlet weak var bom5: UIButton!
    @IBOutlet weak var bom6: UIButton!
    @IBOutlet weak var bom7: UIButton!
    @IBOutlet weak var bom8: UIButton!
    @IBOutlet weak var bom9: UIButton!
    @IBOutlet weak var bom10: UIButton!
    @IBOutlet weak var bom11: UIButton!
    @IBOutlet weak var bom12: UIButton!
    @IBOutlet weak var bom13: UIButton!
    @IBOutlet weak var bom14: UIButton!
    @IBOutlet weak var bom15: UIButton!
    @IBOutlet weak var bom16: UIButton!
    @IBOutlet weak var bom17: UIButton!
    @IBOutlet weak var bom18: UIButton!
    @IBOutlet weak var bom19: UIButton!
    @IBOutlet weak var bom20: UIButton!
    
    private let disposeBag = DisposeBag()
    private let zeroCount = 0
    
    private var timer = Timer()
    private var setValue = SetValue.shared
    private var numberOfExplosions: [Int] = []
    private var tmpNumberOfExplosions: [Int] = []
    private var punishmentGames: [String] = []
    private var bomButtons: [UIButton] = []
    private var timerCount = Int()
    private var numExplosionCount = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bomButtons = [
            bom1,  bom2,  bom3,  bom4,
            bom5,  bom6,  bom7,  bom8,
            bom9,  bom10, bom11, bom12,
            bom13, bom14, bom15, bom16,
            bom17, bom18, bom19, bom20
        ]
        
        bomButtons.forEach { bom in
            bom.rx.tap
                .asDriver()
                .drive { [weak self] _ in
                    self?.checkTheBom(tag: bom.tag)
                    self?.timerCount = self!.timerCount
                }
                .disposed(by: disposeBag)
        }
        
        reset.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.allReset()
            }
            .disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        timerCount = setValue.timerCount
        numExplosionCount = setValue.numExplosions
        notLimitTime()
    }
    
    @IBAction func startButton(_ sender: Any) {
        
        if timerCount != zeroCount {
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
        
        for i in 1...20 { tmpNumberOfExplosions.append(i) }
        
        for _ in 0..<numExplosionCount {
            
            let ramdomInt = Int.random(in: 0..<tmpNumberOfExplosions.count)
            numberOfExplosions.append(tmpNumberOfExplosions[ramdomInt])
            tmpNumberOfExplosions.remove(at: ramdomInt)
        }
        
        start.isHidden = true
    }
    
    // タイマーのカウンドダウン
    @objc private func updateTimer() {
        
        timerCount -= 1
        if timerCount == zeroCount {
            
            timerLabel.text = "時間切れ"
            timer.invalidate()
        } else {
            
            timerLabel.text = "残り\(timerCount)秒"
        }
    }
    
    // 爆破するか判断
    private func checkTheBom(tag: Int) {
        
        numberOfExplosions.forEach { numExplo in
            
            if tag == numExplo {
                timerLabel.text = "爆発しました"
                timer.invalidate()
                return
            }
        }
        
        bomButtons[tag - 1].isHidden = true
    }
    
    // 全て初期状態に戻す
    private func allReset() {
        
        bomButtons.forEach { bom in
            bom.isHidden = false
        }
        
        timerCount = setValue.timerCount
        numberOfExplosions = []
        tmpNumberOfExplosions = []
        notLimitTime()
        timer.invalidate()
        start.isHidden = false
    }
    
    // 制限時間の有無
    private func notLimitTime() {
        
        if timerCount == zeroCount {
            timerLabel.text = "制限時間なし"
            timerLabel.font = timerLabel.font.withSize(20)
        } else {
            timerLabel.text = "残り\(timerCount)秒"
            timerLabel.font = timerLabel.font.withSize(25)
        }
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

