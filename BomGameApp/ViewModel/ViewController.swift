//
//  ViewController.swift
//  BomGameApp
//
//  Created by 祥平 on 2022/01/19.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var punishmentGame1: UITextField!
    @IBOutlet weak var punishmentGame2: UITextField!
    @IBOutlet weak var punishmentGame3: UITextField!
    @IBOutlet weak var punishmentGame4: UITextField!
    @IBOutlet weak var punishmentGame5: UITextField!
    @IBOutlet weak var timerTextField: UITextField!
    @IBOutlet weak var numExplosions: UITextField!
    
    private let disposeBag = DisposeBag()
    private let targetTabBar = 1
    private let limitExposionCount = 5
    private let limitTimerCount = 60
    private var timerCount = String()
    private var exposionCount = String()
    private var checkTimeCountFlag = true
    private var checkExpoCountFlag = true
    private var setValue = SetValue.shared
    private var textFieldList = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolBarSetupUI()
        textFieldList = [punishmentGame1, punishmentGame2, punishmentGame3, punishmentGame4, punishmentGame5]
        textFieldList.forEach { textField in
            textField.delegate = self
            textField.returnKeyType = .done
        }
        
        timerTextField.rx.controlEvent(.editingDidEnd)
            .subscribe { [weak self] _ in
                self?.timerCount = self?.timerTextField.text ?? "0"
                self?.setValue.timerCount = Int(self!.timerCount) ?? 0
                
                if self!.limitTimerCount < self!.setValue.timerCount {
                    
                    self!.alert(title: "注意", body: "60秒以下に設定してください！", button: "完了")
                    self!.checkTimeCountFlag = false
                    self?.checkTabButton(timeFlag: self!.checkTimeCountFlag, expoFlag: self!.checkExpoCountFlag)
                } else {
                    self!.checkTimeCountFlag = true
                    self?.checkTabButton(timeFlag: self!.checkTimeCountFlag, expoFlag: self!.checkExpoCountFlag)
                }
            }
            .disposed(by: disposeBag)
        
        numExplosions.rx.controlEvent(.editingDidEnd)
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.exposionCount = self?.numExplosions.text ?? "1"
                self?.setValue.numExplosions = Int(self!.exposionCount) ?? 1
                
                if self!.limitExposionCount < self!.setValue.numExplosions {
                    
                    self!.alert(title: "注意", body: "5個以下に設定してください！", button: "完了")
                    self!.checkExpoCountFlag = false
                    self?.checkTabButton(timeFlag: self!.checkTimeCountFlag, expoFlag: self!.checkExpoCountFlag)
                } else {
                    
                    self!.checkExpoCountFlag = true
                    self?.checkTabButton(timeFlag: self!.checkTimeCountFlag, expoFlag: self!.checkExpoCountFlag)
                }
            })
            .disposed(by: disposeBag)
        
        punishmentGame1.rx.controlEvent(.editingDidEnd)
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.setValue.punishmentGames.updateValue(self?.punishmentGame1.text ?? "なし", forKey: "0")
            })
            .disposed(by: disposeBag)
        
        punishmentGame2.rx.controlEvent(.editingDidEnd)
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.setValue.punishmentGames.updateValue(self?.punishmentGame2.text ?? "なし", forKey: "1")
            })
            .disposed(by: disposeBag)
        
        punishmentGame3.rx.controlEvent(.editingDidEnd)
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.setValue.punishmentGames.updateValue(self?.punishmentGame3.text ?? "なし", forKey: "2")
            })
            .disposed(by: disposeBag)
        
        punishmentGame4.rx.controlEvent(.editingDidEnd)
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.setValue.punishmentGames.updateValue(self?.punishmentGame4.text ?? "なし", forKey: "3")
            })
            .disposed(by: disposeBag)
        
        punishmentGame5.rx.controlEvent(.editingDidEnd)
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.setValue.punishmentGames.updateValue(self?.punishmentGame5.text ?? "なし", forKey: "4")
            })
            .disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }
    
    // 改行ボタンの変更
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldList.forEach { textField in
            textField.resignFirstResponder()
        }
        return true
    }
    
    // キーボードの上に完了ボタンを設置
    private func toolBarSetupUI() {
        
        let toolBar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(didTapDoneButton))
        
        toolBar.items = [space, done]
        toolBar.sizeToFit()
        
        timerTextField.inputAccessoryView = toolBar
        numExplosions.inputAccessoryView = toolBar
    }
    
    // 完了ボタン押下でキーボード閉じる
    @objc func didTapDoneButton() {
        
        timerTextField.resignFirstResponder()
        numExplosions.resignFirstResponder()
    }
    
    // 画面をタップしてキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        timerTextField.resignFirstResponder()
        numExplosions.resignFirstResponder()
        textFieldList.forEach { textField in
            textField.resignFirstResponder()
        }
    }
    
    // アラートの表示の設定
    private func alert(title: String, body: String, button: String) {
        
        let alert: UIAlertController = UIAlertController(title: title, message: body, preferredStyle: .alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: button, style: .cancel, handler: {
            (action: UIAlertAction!) -> Void in
        })
        
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    // 条件クリアでタブボタン押せる
    private func checkTabButton(timeFlag: Bool=true, expoFlag: Bool=true) {
        if timeFlag && expoFlag {
            self.tabBarController?.tabBar.items![targetTabBar].isEnabled = true
        } else {
            self.tabBarController?.tabBar.items![targetTabBar].isEnabled = false
        }
    }
}

