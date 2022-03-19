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
    private var punishmentGamesList: [String] = []
    private var firstShuffleFlag = Bool()
    private var firstTapBtn = Int()
    private var timer: Timer?
    private var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titleStringArray[index]
        titleLabel.morphingEffect = .burn
        punishmentButtonList = [
            punishmentButton1,
            punishmentButton2,
            punishmentButton3,
            punishmentButton4,
            punishmentButton5
        ]
        firstShuffleFlag = setValue.firstShuffleFlag
        if firstShuffleFlag {
            let tmpPunishmentGamesList = setValue.punishmentGames
            for (key, val) in tmpPunishmentGamesList { setValue.punishmentGamesList.append(val) }
            punishmentGamesList = setValue.punishmentGamesList
            punishmentGamesList.shuffle()
            setValue.firstShuffleFlag = false
        }
        
        for tmp in 0..<punishmentButtonList.count {
            if tmp >= 0 && tmp < punishmentGamesList.count { continue }
            punishmentButtonList[tmp].isHidden = true
        }
        
        punishmentButtonList.forEach { button in
            button.rx.tap
                .asDriver()
                .drive(onNext: { [weak self] _ in
                    self?.flipButton(button: button, title: (self?.punishmentGamesList[button.tag])!)
                    button.isEnabled = false
                    self?.firstTapBtn = button.tag
                    if button.tag == self?.firstTapBtn {
                        self?.punishmentButtonList.forEach { button2 in
                            button2.isEnabled = false
                        }
                    }
                })
                .disposed(by: disposeBag)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 3.0,
                                     target: self,
                                     selector: #selector(updateTimer(timer:)),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func updateTimer(timer: Timer) {
        titleLabel.text = titleStringArray[index]
        index += 1
        if index >= titleStringArray.count {
            index = 0
        }
    }
    
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
