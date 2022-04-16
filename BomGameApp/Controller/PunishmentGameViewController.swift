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

class PunishmentGameViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: LTMorphingLabel!
    @IBOutlet weak var punishmentButton1: UIButton!
    @IBOutlet weak var punishmentButton2: UIButton!
    @IBOutlet weak var punishmentButton3: UIButton!
    @IBOutlet weak var punishmentButton4: UIButton!
    @IBOutlet weak var punishmentButton5: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private let setValue = SetValue.shared
    private let titleStringArray = ["あなたの運命を", "決める罰ゲームを", "選択してください!"]
    
    private var punishmentButtonList:[UIButton] = []
    private var firstShuffleFlag = Bool()
    private var firstTapBtn = Int()
    private var timer: Timer?
    private var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
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
            if tmp >= 0 && tmp < setValue.punishmentGamesList.count { continue }
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
                        title: (self?.setValue.punishmentGamesList[button.tag])!
                    )
                    self?.setSelectedButton(button: button)
                })
                .disposed(by: disposeBag)
        }
    }
    
    @objc func updateTimer(timer: Timer) {
        titleLabel.text = titleStringArray[index]
        index += 1
        if index >= titleStringArray.count { index = 0 }
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
                punishmentButtonList[selectedTag].setTitle(setValue.punishmentGamesList[selectedTag], for: .normal)
            }
        }
    }
    
    // 罰ゲームをシャッフル
    private func firstShuffle() {
        if setValue.firstShuffleFlag {
            let tmpPunishmentGamesList = setValue.punishmentGames
            for (key, val) in tmpPunishmentGamesList { setValue.punishmentGamesList.append(val) }
            setValue.punishmentGamesList.shuffle()
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
        navigationController?.popViewController(animated: true)
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
