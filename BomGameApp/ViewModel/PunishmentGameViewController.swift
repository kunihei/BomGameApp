//
//  PunishmentGameViewController.swift
//  BomGameApp
//
//  Created by 祥平 on 2022/01/29.
//

import UIKit
import RxSwift
import RxCocoa

class PunishmentGameViewController: UIViewController {
    
    @IBOutlet weak var punishmentButton1: UIButton!
    @IBOutlet weak var punishmentButton2: UIButton!
    @IBOutlet weak var punishmentButton3: UIButton!
    @IBOutlet weak var punishmentButton4: UIButton!
    @IBOutlet weak var punishmentButton5: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private let setValue = SetValue.shared
    
    private var punishmentButtonList:[UIButton] = []
    private var punishmentGamesList: [String] = []
    private var firstShuffleFlag = Bool()
    private var firstTapBtn = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        punishmentButtonList = [
            punishmentButton1,
            punishmentButton2,
            punishmentButton3,
            punishmentButton4,
            punishmentButton5
        ]
        firstShuffleFlag = setValue.firstShuffleFlag
         let tmpPunishmentGamesList = setValue.punishmentGames
        for (key, val) in tmpPunishmentGamesList { punishmentGamesList.append(val) }
        if firstShuffleFlag {
            punishmentGamesList.shuffle()
            setValue.firstShuffleFlag = false
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
