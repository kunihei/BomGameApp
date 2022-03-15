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
    private let bundleDataName: String = "Explosion"
    private let bundleDataType: String = "mp4"
    
    private var timer = Timer()
    var videoPlayer: AVPlayer!
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
        
        timerCount = setValue.timerCount
        numExplosionCount = setValue.numExplosions
        notLimitTime()
    }
    
    @IBAction func startButton(_ sender: Any) {
        bomButtons.forEach { bom in
            bom.isEnabled = true
        }
        
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
                movePunishment()
                //                let moviePath: String? = Bundle.main.path(forResource: bundleDataName, ofType: bundleDataType)
                //                playMovieFromPath(moviePath: moviePath)
                //                playMovieSetup(path: bundleDataName, type: bundleDataType)
                //                videoPlayer.play()
            }
        }
        bomButtons[tag - 1].isHidden = true
    }
    
    // 動作再生画面作成
    //    func playMovieSetup(path: String, type: String) {
    //        // Create AVPlayerItem
    //        guard let path = Bundle.main.path(forResource: path, ofType: type) else {
    //            fatalError("Movie file can not find.")
    //        }
    //        let fileURL = URL(fileURLWithPath: path)
    //        let avAsset = AVURLAsset(url: fileURL)
    //        let playerItem: AVPlayerItem = AVPlayerItem(asset: avAsset)
    //
    //        // Create AVPlayer
    //        videoPlayer = AVPlayer(playerItem: playerItem)
    //
    //        // Add AVPlayer
    //        let layer = AVPlayerLayer()
    //        layer.videoGravity = AVLayerVideoGravity.resizeAspect
    //        layer.player = videoPlayer
    //        layer.frame = view.bounds
    //        view.layer.addSublayer(layer)
    //    }
    
    private func movePunishment() {
        let storyboard = UIStoryboard(name: "PunishmentGame", bundle: nil)
        let punishmentGameVC = storyboard.instantiateViewController(withIdentifier: "punishment") as! PunishmentGameViewController
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        view.alpha = 0
        view.backgroundColor = .white
        self.view.addSubview(view)
        UIWindow.animate(withDuration: 1.0) {
            view.alpha = 1.0
        } completion: { (Bool) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.navigationController?.pushViewController(punishmentGameVC, animated: false)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                view.removeFromSuperview()
            }
        }
        
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

