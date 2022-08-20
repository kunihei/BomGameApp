//
//  FinishGameDialog.swift
//  BomGameApp
//
//  Created by 祥平 on 2022/04/16.
//

import UIKit
import LTMorphingLabel
import GoogleMobileAds

class FinishGameDialog: UIViewController {

    @IBOutlet weak var punishmentExplanationLabel: LTMorphingLabel!
    @IBOutlet weak var punishmentGameLabel1: UILabel!
    @IBOutlet weak var punishmentGameLabel2: UILabel!
    @IBOutlet weak var punishmentGameLabel3: UILabel!
    @IBOutlet weak var punishmentGameLabel4: UILabel!
    @IBOutlet weak var punishmentGameLabel5: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private let setValue = SetValue.shared
    private let finishGameLabelArr = [
        "これでゲームは",
        "終了です！",
        "上から順に",
        "1人目の罰ゲームを",
        "表示しています!",
        "お疲れ様でした！"
    ]
    
    private var outputArrayLabel = [UILabel]()
    private var labelArray = [UILabel]()
    private var interstitial: GADInterstitialAd?
    private var interstitialID: String?
    private var timer: Timer?
    private var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
#if DEBUG
        bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"
        interstitialID = "ca-app-pub-3940256099942544/4411468910"
#else
        bannerView.adUnitID = "ca-app-pub-3279976203462809/9550021848"
        interstitialID = "ca-app-pub-3279976203462809/2160345351"
#endif
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        GADInterstitialAd.load(withAdUnitID: interstitialID ?? "", request: GADRequest()) { [weak self] (ad, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            self?.interstitial = ad
        }

        labelArray = [
            punishmentGameLabel1,
            punishmentGameLabel2,
            punishmentGameLabel3,
            punishmentGameLabel4,
            punishmentGameLabel5
        ]
        for tmp in 0..<labelArray.count {
            if tmp >= 0 && tmp < setValue.displayButtonPunishmentGames.count {
                outputArrayLabel.append(labelArray[tmp])
                continue
            }
            labelArray[tmp].isHidden = true
        }
        for i in 0..<outputArrayLabel.count {
            outputArrayLabel[i].text = setValue.displayButtonPunishmentGames[i]
        }
        
        punishmentExplanationLabel.text = finishGameLabelArr[index]
        punishmentExplanationLabel.morphingEffect = .burn
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(updateTimer(timer:)), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    
    @objc func updateTimer(timer: Timer) {
        punishmentExplanationLabel.text = finishGameLabelArr[index]
        index += 1
        if index >= finishGameLabelArr.count { index = 0 }
    }
    
    @IBAction func backButton(_ sender: Any) {
        setValue.resetFlag = true
        self.interstitial?.present(fromRootViewController: self)
        self.navigationController?.popToRootViewController(animated: true)
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
