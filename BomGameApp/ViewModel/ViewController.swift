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
    private let pickerView: UIPickerView = UIPickerView()
    private let pickerView2: UIPickerView = UIPickerView()
    private let exposionCountArray = ["1", "2", "3", "4", "5"]
    private let targetTabBar = 1
    private let limitExposionCount = 5
    private let limitTimerCount = 60
    private let pickerViewTagOne = 1
    private var timerCount = String()
    private var exposionCount = String()
    private var setValue = SetValue.shared
    private var textFieldList = [UITextField]()
    private var timerCountArray = [Int](0...60)
    private var pickersw = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setColor_Border()
        timerTextField.text = "0"
        numExplosions.text = "1"
        tabBarController?.tabBar.items![targetTabBar].isEnabled = false
        totalDelegate_tag()
        pickerView.showsSelectionIndicator = true
        createDone()
        textFieldList = [punishmentGame1, punishmentGame2, punishmentGame3, punishmentGame4, punishmentGame5]
        textFieldList.forEach { textField in
            textField.delegate = self
            textField.returnKeyType = .done
        }
        
        punishmentGame1.rx.controlEvent(.editingDidEnd)
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.setValue.punishmentGames.updateValue(self?.punishmentGame1.text ?? "なし", forKey: "0")
                self?.checkTabButton(punishmentGamesText: (self?.setValue.punishmentGames["0"])!)
            })
            .disposed(by: disposeBag)
        
        punishmentGame2.rx.controlEvent(.editingDidEnd)
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.setValue.punishmentGames.updateValue(self?.punishmentGame2.text ?? "なし", forKey: "1")
                self?.checkTabButton(punishmentGamesText: (self?.setValue.punishmentGames["1"])!)
            })
            .disposed(by: disposeBag)
        
        punishmentGame3.rx.controlEvent(.editingDidEnd)
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.setValue.punishmentGames.updateValue(self?.punishmentGame3.text ?? "なし", forKey: "2")
                self?.checkTabButton(punishmentGamesText: (self?.setValue.punishmentGames["2"])!)
            })
            .disposed(by: disposeBag)
        
        punishmentGame4.rx.controlEvent(.editingDidEnd)
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.setValue.punishmentGames.updateValue(self?.punishmentGame4.text ?? "なし", forKey: "3")
                self?.checkTabButton(punishmentGamesText: (self?.setValue.punishmentGames["3"])!)
            })
            .disposed(by: disposeBag)
        
        punishmentGame5.rx.controlEvent(.editingDidEnd)
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.setValue.punishmentGames.updateValue(self?.punishmentGame5.text ?? "なし", forKey: "4")
                self?.checkTabButton(punishmentGamesText: (self?.setValue.punishmentGames["4"])!)
            })
            .disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }
    
    /// 画面をタップしてキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        timerTextField.resignFirstResponder()
        numExplosions.resignFirstResponder()
        textFieldList.forEach { textField in
            textField.resignFirstResponder()
        }
    }
    
    /// textFieldの枠線と色、太さの設定とタブバーの色変更
    private func setColor_Border() {
        UITabBar.appearance().tintColor = UIColor.red
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
        punishmentGame1.layer.borderColor = UIColor.white.cgColor
        punishmentGame1.layer.cornerRadius = 5.0
        punishmentGame1.layer.borderWidth = 1.0
        punishmentGame2.layer.borderColor = UIColor.white.cgColor
        punishmentGame2.layer.cornerRadius = 5.0
        punishmentGame2.layer.borderWidth = 1.0
        punishmentGame3.layer.borderColor = UIColor.white.cgColor
        punishmentGame3.layer.cornerRadius = 5.0
        punishmentGame3.layer.borderWidth = 1.0
        punishmentGame4.layer.borderColor = UIColor.white.cgColor
        punishmentGame4.layer.cornerRadius = 5.0
        punishmentGame4.layer.borderWidth = 1.0
        punishmentGame5.layer.borderColor = UIColor.white.cgColor
        punishmentGame5.layer.cornerRadius = 5.0
        punishmentGame5.layer.borderWidth = 1.0
    }
    
    /// 改行ボタンの変更
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldList.forEach { textField in
            textField.resignFirstResponder()
        }
        return true
    }
        
    /// 決定バーの作成
    private func createDone() {
        timerTextField.inputView = pickerView
        numExplosions.inputView = pickerView2
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        toolbar.isUserInteractionEnabled = true
        timerTextField.inputAccessoryView = toolbar
        numExplosions.inputAccessoryView = toolbar
        timerTextField.isEnabled = true
        numExplosions.isEnabled = true
    }
    
    /// delegate関係とタグをまとめたメソッド
    private func totalDelegate_tag() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView2.delegate = self
        pickerView2.dataSource = self
        pickerView.tag = 1
        pickerView2.tag = 2
    }
    
    /// アラートの表示の設定
    private func alert(title: String, body: String, button: String) {
        let alert: UIAlertController = UIAlertController(title: title, message: body, preferredStyle: .alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: button, style: .cancel, handler: {
            (action: UIAlertAction!) -> Void in
        })
        
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    /// 条件クリアでタブボタン押せる
    private func checkTabButton(punishmentGamesText: String) {
        if punishmentGamesText != "" {
            self.tabBarController?.tabBar.items![targetTabBar].isEnabled = true
        } else {
            self.tabBarController?.tabBar.items![targetTabBar].isEnabled = false
            alert(title: "注意", body: "罰ゲーム文を最低1つは記入してください！", button: "OK")
        }
    }
    
    @objc func done() {
        if pickersw == pickerViewTagOne {
            timerTextField.text = "\(timerCountArray[pickerView.selectedRow(inComponent: 0)])"
            timerCount = timerTextField.text ?? "0"
            setValue.timerCount = Int(timerCount) ?? 0
        } else {
            numExplosions.text = "\(exposionCountArray[pickerView2.selectedRow(inComponent: 0)])"
            exposionCount = numExplosions.text ?? "1"
            setValue.numExplosions = Int(exposionCount) ?? 1
        }
        view.endEditing(true)
    }
    
    /// 完了ボタン押下でキーボード閉じる
    @objc func didTapDoneButton() {
        timerTextField.resignFirstResponder()
        numExplosions.resignFirstResponder()
    }
}


extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == pickerViewTagOne {
            return timerCountArray.count
        } else {
            return exposionCountArray.count
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == pickerViewTagOne {
            pickersw = 1
            return String(timerCountArray[row])
        } else {
            pickersw = 2
            return exposionCountArray[row]
        }
    }
}
