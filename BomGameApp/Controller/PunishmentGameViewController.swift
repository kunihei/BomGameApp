//
//  PunishmentGameViewController.swift
//  BomGameApp
//
//  Created by 祥平 on 2022/01/29.
//

import UIKit
import RxSwift
import RxCocoa
import LTMorphingLabel
import GoogleMobileAds

class PunishmentGameViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: LTMorphingLabel!
    @IBOutlet weak var punishmentButton1: UIButton!
    @IBOutlet weak var punishmentButton2: UIButton!
    @IBOutlet weak var punishmentButton3: UIButton!
    @IBOutlet weak var punishmentButton4: UIButton!
    @IBOutlet weak var punishmentButton5: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private let disposeBag = DisposeBag()
    private let setValue = SetValue.shared
    private let titleStringArray = ["あなたの運命を", "決める罰ゲームを", "選択してください!"]
    
    private var punishmentButtonList:[UIButton] = []
    private var firstShuffleFlag = Bool()
    private var interstitial: GADInterstitialAd?
    private var interstitialID: String?
    private var firstTapBtn = Int()
    private var finishFlag = false
    private var timer: Timer?
    private var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
#if DEBUG
        bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"
#else
        bannerView.adUnitID = "ca-app-pub-3279976203462809/4511725261"
#endif
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        navigationController?.isNavigationBarHidden = true
        backButton.isEnabled = false
        backButton.setTitleColor(.lightGray, for: .normal)
        titleLabel.text = titleStringArray[index]
        titleLabel.morphingEffect = .burn
        timer = Timer.scheduledTimer(
            timeInterval: 3.0,
            target: self,
            selector: #selector(updateTimer(timer:)),
            userInfo: nil,
            repeats: true
        )
        punishmentButtonList = [
            punishmentButton1,
            punishmentButton2,
            punishmentButton3,
            punishmentButton4,
            punishmentButton5
        ]
        selectedButtnSetTitle()
        firstShuffle()
        
        for tmp in 0..<punishmentButtonList.count {
            if tmp >= 0 && tmp < setValue.displayButtonPunishmentGames.count { continue }
            punishmentButtonList[tmp].isHidden = true
        }
        
        punishmentButtonList.forEach { button in
            button.titleLabel?.numberOfLines = 0
            if !setValue.selectedFlag { button.isEnabled = true}
            button.rx.tap
                .asDriver()
                .drive(onNext: { [weak self] _ in
                    self?.flipButton(
                        button: button,
                        title: (self?.setValue.displayButtonPunishmentGames[button.tag])!
                    )
                    self?.setSelectedButton(button: button)
                    self?.setValue.numberPunishmentGamesDisplayed -= 1
                    if self?.setValue.numberPunishmentGamesDisplayed == 0 {
                        self?.backButton.setTitle("ゲーム終了", for: .normal)
                        self?.finishFlag = true
                    }
                    self?.backButton.isEnabled = true
                    self?.backButton.setTitleColor(.white, for: .normal)
                })
                .disposed(by: disposeBag)
        }
    }
    
    @objc func updateTimer(timer: Timer) {
        titleLabel.text = titleStringArray[index]
        index += 1
        if index >= titleStringArray.count { index = 0 }
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
    
    // タップしたボタン非表示、初回タップした値セット
    private func setSelectedButton(button: UIButton) {
        button.isEnabled = false
        firstTapBtn = button.tag
        if button.tag == firstTapBtn {
            setValue.selectedTagArray.append(firstTapBtn)
            setValue.selectedFlag = true
            punishmentButtonList.forEach { button2 in
                button2.isEnabled = false
            }
        }
    }
    
    // タップされたボタンに初期からその罰ゲームを表示
    private func selectedButtnSetTitle() {
        if setValue.selectedFlag {
            for tmp in 0..<setValue.selectedTagArray.count {
                let selectedTag = setValue.selectedTagArray[tmp]
                punishmentButtonList[selectedTag].isEnabled = false
                punishmentButtonList[selectedTag].setTitle(setValue.displayButtonPunishmentGames[selectedTag], for: .normal)
            }
        }
    }
    
    // 罰ゲームをシャッフル
    private func firstShuffle() {
        if setValue.firstShuffleFlag {
            let tmpPunishmentGamesList = setValue.initPunishmentGames
            for (key, val) in tmpPunishmentGamesList { setValue.displayButtonPunishmentGames.append(val) }
            setValue.displayButtonPunishmentGames.shuffle()
            setValue.firstShuffleFlag = false
        }
    }
    
    // フリップアニメーション実装
    private func flipButton(button: UIButton, title: String) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        rotationAnimation.toValue = CGFloat(Double.pi / 180) * 360
        rotationAnimation.duration = 1.0
        rotationAnimation.repeatCount = 1
        button.layer.add(rotationAnimation, forKey: "rotationAnimation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            button.setTitle(title, for: .normal)
        }
    }
    
    @IBAction func displayButton(_ sender: Any) {
        if finishFlag {
            finishFlag = false
            let storyboard = UIStoryboard(name: "FinishGameDialog", bundle: nil)
            let finishDialog = storyboard.instantiateViewController(withIdentifier: "finishDialog") as! FinishGameDialog
            moveView(controller: finishDialog)
        } else {
            navigationController?.popViewController(animated: true)
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
