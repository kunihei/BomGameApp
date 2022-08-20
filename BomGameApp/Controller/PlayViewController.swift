//
//  PlayViewController.swift
//  BomGameApp
//
//  Created by 祥平 on 2022/01/22.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import AVKit
import MBCircularProgressBar
import GoogleMobileAds

class PlayViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressView: MBCircularProgressBarView!
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
    @IBOutlet weak var bannerView: GADBannerView!
    
    private let disposeBag = DisposeBag()
    private let zeroCount = 0
    private let bundleDataName: String = "Explosion"
    private let bundleDataType: String = "mp4"
    
    private var countDownTimer = Timer()
    private var videoPlayer: AVPlayer!
    private var setValue = SetValue.shared
    private var numberOfExplosions: [Int] = []
    private var tmpNumberOfExplosions: [Int] = []
    private var bomButtons: [UIButton] = []
    private var timerCount = Int()
    private var numExplosionCount = Int()
    private var changeYellowCount = Int()
    private var changeRedCount = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
#if DEBUG
        bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"
#else
        bannerView.adUnitID = "ca-app-pub-3279976203462809/6099590368"
#endif
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        reset.isHidden = true
        bomButtons = [
            bom1,  bom2,  bom3,  bom4,
            bom5,  bom6,  bom7,  bom8,
            bom9,  bom10, bom11, bom12,
            bom13, bom14, bom15, bom16,
            bom17, bom18, bom19, bom20
        ]
        
        bomButtons.forEach { bom in
            bom.isEnabled = false
            bom.rx.tap
                .asDriver()
                .drive { [weak self] _ in
                    self?.checkTheBom(tag: bom.tag)
                    self?.timerCount = self!.setValue.timerCount + 1
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
        
        setTimer()
        navigationController?.isNavigationBarHidden = true
        if setValue.resetFlag {
            allReset()
        }
        numExplosionCount = setValue.initNumExplosions
        if setValue.firstSetPubnishCountFlag {
            setValue.numberPunishmentGamesDisplayed = setValue.initPunishmentGames.count
            setValue.firstSetPubnishCountFlag = false
        }
        notLimitTime()
    }
    
    @IBAction func startButton(_ sender: Any) {
        bomButtons.forEach { bom in
            bom.isEnabled = true
        }
        if timerCount != zeroCount {
            countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
        
        // 爆発箇所が被らない様にする処理
        for i in 1...20 { tmpNumberOfExplosions.append(i) }
        for _ in 0..<numExplosionCount {
            let ramdomInt = Int.random(in: 0..<tmpNumberOfExplosions.count)
            numberOfExplosions.append(tmpNumberOfExplosions[ramdomInt])
            tmpNumberOfExplosions.remove(at: ramdomInt)
        }
        start.isHidden = true
        reset.isHidden = false
    }
    
    // タイマーのカウンドダウン
    @objc private func updateTimer() {
        timerCount -= 1
        progressView.value = CGFloat(timerCount)
        if timerCount == zeroCount {
            countDownTimer.invalidate()
            let storyboard = UIStoryboard(name: "PunishmentGameDialog", bundle: nil)
            let punishmentGameDialogVC = storyboard.instantiateViewController(withIdentifier: "punishmentDialog") as! PunishmentGameDialog
            moveView(controller: punishmentGameDialogVC)
        } else if timerCount <= 5 {
            setupProgressColor(color: .red)
            timerLabel.text = "残り\(timerCount)秒"
        } else if timerCount <= changeYellowCount {
            setupProgressColor(color: .yellow)
            timerLabel.text = "\(timerCount)秒"
        } else {
            setupProgressColor(color: .green)
            timerLabel.text = "\(timerCount)秒"
        }
    }
    
    // タイマーの初期表示とプログレスバーの色変更数値設定
    private func setTimer() {
        timerCount = setValue.timerCount
        changeYellowCount = timerCount / 2
        changeRedCount = 5
        judgLabel()
    }
    
    // プログレスバーの色設定
    private func setupProgressColor(color: UIColor) {
        progressView.progressColor = color
        progressView.progressStrokeColor = color
    }
    
    // 爆破するか判断
    private func checkTheBom(tag: Int) {
        numberOfExplosions.forEach { numExplo in
            if tag == numExplo {
                countDownTimer.invalidate()
                setValue.countExplosions += 1
                let storyboard = UIStoryboard(name: "PunishmentGame", bundle: nil)
                let punishmentGameVC = storyboard.instantiateViewController(withIdentifier: "punishment") as! PunishmentGameViewController
                moveView(controller: punishmentGameVC)
            }
        }
        bomButtons[tag - 1].isHidden = true
    }
    
    // 画面遷移アニメーション
    private func moveView(controller: UIViewController) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        view.alpha = 0
        view.backgroundColor = .white
        self.view.addSubview(view)
        UIWindow.animate(withDuration: 1.0) {
            view.alpha = 1.0
        } completion: { (Bool) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.navigationController?.pushViewController(controller, animated: false)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                view.removeFromSuperview()
            }
        }
    }
    
    // 全て初期状態に戻す
    private func allReset() {
        numberOfExplosions = []
        tmpNumberOfExplosions = []
        setValue.selectedTagArray = []
        setValue.displayButtonPunishmentGames = []
        setValue.firstSetPubnishCountFlag = true
        start.isHidden = false
        reset.isHidden = true
        setValue.resetFlag = false
        setValue.selectedFlag = false
        setValue.firstShuffleFlag = true
        bomButtons.forEach { bom in
            bom.isHidden = false
            bom.isEnabled = false
        }
        timerCount = setValue.timerCount
        setupProgressColor(color: .green)
        judgLabel()
        notLimitTime()
        countDownTimer.invalidate()
    }
    
    // タイマーラベルの文言判定
    private func judgLabel() {
        if timerCount == changeRedCount {
            setupProgressColor(color: .red)
            timerLabel.text = "残り\(timerCount)秒"
        } else {
            setupProgressColor(color: .green)
            timerLabel.text = "\(timerCount)秒"
        }
    }
    
    // 制限時間の有無
    private func notLimitTime() {
        if timerCount == zeroCount {
            timerLabel.isHidden = true
            progressView.isHidden = true
        } else {
            timerLabel.isHidden = false
            progressView.isHidden = false
            progressView.value = CGFloat(timerCount)
            progressView.maxValue = CGFloat(timerCount)
            timerLabel.numberOfLines = 0
            timerLabel.font = timerLabel.font.withSize(15)
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

