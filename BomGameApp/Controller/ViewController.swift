//
//  ViewController.swift
//  BomGameApp
//
//  Created by 祥平 on 2022/01/19.
//

import UIKit
import RxSwift
import RxCocoa
import LTMorphingLabel
import GoogleMobileAds

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var punishmentGame1: UITextField!
    @IBOutlet weak var punishmentGame2: UITextField!
    @IBOutlet weak var punishmentGame3: UITextField!
    @IBOutlet weak var punishmentGame4: UITextField!
    @IBOutlet weak var punishmentGame5: UITextField!
    @IBOutlet weak var timerTextField: UITextField!
    @IBOutlet weak var numExplosions: UITextField!
    @IBOutlet weak var explanationLabel: LTMorphingLabel!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private let disposeBag = DisposeBag()
    private let pickerView: UIPickerView = UIPickerView()
    private let pickerView2: UIPickerView = UIPickerView()
    private let exposionCountArray = ["1", "2", "3", "4", "5"]
    private let explanationArray = ["罰ゲームを", "最低一つは", "入力してください!", "でないとゲームを", "始めることができません!"]
    private let targetTabBar = 1
    private let limitExposionCount = 5
    private let limitTimerCount = 60
    private let pickerViewTagOne = 5
    private var index = 0
    private var timerCount = String()
    private var exposionCount = String()
    private var setValue = SetValue.shared
    private var textFieldList = [UITextField]()
    private var timerCountArray = [Int]()
    private var pickersw = Int()
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
#if DEBUG
        bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"
#else
        bannerView.adUnitID = "ca-app-pub-3279976203462809/3390215288"
#endif
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        for i in 0...25 {
            if (i % 5) == 0 {
                timerCountArray.append(i)
            }
        }
        initialization()
        timer = Timer.scheduledTimer(timeInterval: 3.0,
                                     target: self,
                                     selector: #selector(updateTimer(timer:)),
                                     userInfo: nil,
                                     repeats: true)
        pickerView.showsSelectionIndicator = true
        createDone()
        setColor_Border()
        textFieldList.forEach { textField in
            textField.rx.controlEvent(.editingDidEnd)
                .asDriver()
                .drive(onNext: { [weak self] _ in
                    if textField.text != "" {
                        self?.setValue.initPunishmentGames.updateValue(textField.text!, forKey: "\(textField.tag)")
                    }
                    self?.checkTabButton()
                })
                .disposed(by: disposeBag)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        index = 0
        explanationLabel.text = explanationArray[index]
    }
    
    @objc func updateTimer(timer: Timer) {
        explanationLabel.text = explanationArray[index]
        index += 1
        if index >= explanationArray.count { index = 0 }
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
        textFieldList.forEach { textField in
            textField.setUnderLine()
            textField.delegate = self
            textField.returnKeyType = .done
        }
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
    private func initialization() {
        textFieldList = [punishmentGame1, punishmentGame2, punishmentGame3, punishmentGame4, punishmentGame5]
        timerTextField.text = "0"
        numExplosions.text = "1"
        explanationLabel.morphingEffect = .burn
        tabBarController?.tabBar.items![targetTabBar].isEnabled = false
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView2.delegate = self
        pickerView2.dataSource = self
        pickerView.tag = 5
        pickerView2.tag = 6
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
    private func checkTabButton() {
        print("kuni_initPunishmentGamesCount:\(setValue.initPunishmentGames.count)")
        print("kuni_initPunishmentGames:\(setValue.initPunishmentGames)")
        if setValue.initPunishmentGames.count == 0 {
            self.tabBarController?.tabBar.items![targetTabBar].isEnabled = false
            alert(title: "注意", body: "罰ゲーム文を最低1つは記入してください！", button: "OK")
        } else {
            self.tabBarController?.tabBar.items![targetTabBar].isEnabled = true
            
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
            setValue.initNumExplosions = Int(exposionCount) ?? 1
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
            pickersw = 5
            return String(timerCountArray[row])
        } else {
            pickersw = 6
            return exposionCountArray[row]
        }
    }
}
