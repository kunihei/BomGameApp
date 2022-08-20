//
//  PunishmentGameDialog.swift
//  BomGameApp
//
//  Created by 祥平 on 2022/04/03.
//

import UIKit
import LTMorphingLabel
import GoogleMobileAds

class PunishmentGameDialog: UIViewController {

    @IBOutlet weak var punishmentExplanationLabel: LTMorphingLabel!
    @IBOutlet weak var punishmentGameLabel1: UILabel!
    @IBOutlet weak var punishmentGameLabel2: UILabel!
    @IBOutlet weak var punishmentGameLabel3: UILabel!
    @IBOutlet weak var punishmentGameLabel4: UILabel!
    @IBOutlet weak var punishmentGameLabel5: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private let titleLabelArray = ["時間が切れたので", "あなたひとりで", "全ての罰ゲームを", "実行してください☠️"]
    private let setValue = SetValue.shared
    
    private var outputArrayLabel = [UILabel]()
    private var arrayLabel = [UILabel]()
    private var timer: Timer?
    private var index = 0
    private var interstitial: GADInterstitialAd?
    private var interstitialID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
#if DEBUG
        bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"
        interstitialID = "ca-app-pub-3940256099942544/4411468910"
#else
        bannerView.adUnitID = "ca-app-pub-3279976203462809/8264860330"
        interstitialID = "ca-app-pub-3279976203462809/8264860330"
#endif
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        GADInterstitialAd.load(withAdUnitID: interstitialID ?? "", request: GADRequest()) { [weak self] (ad, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            self?.interstitial = ad
        }
        
        
        
        arrayLabel = [
            punishmentGameLabel1,
            punishmentGameLabel2,
            punishmentGameLabel3,
            punishmentGameLabel4,
            punishmentGameLabel5
        ]
        if setValue.displayButtonPunishmentGames.count == 0 {
            let tmpPunishmentGameList = setValue.initPunishmentGames
            for (key, val) in tmpPunishmentGameList { setValue.displayButtonPunishmentGames.append(val) }
        }
        
        for tmp in 0..<arrayLabel.count {
            if tmp >= 0 && tmp < setValue.displayButtonPunishmentGames.count {
                outputArrayLabel.append(arrayLabel[tmp])
                continue
            }
            arrayLabel[tmp].isHidden = true
        }
        
        for i in 0..<outputArrayLabel.count {
            outputArrayLabel[i].text = setValue.displayButtonPunishmentGames[i]
        }
        
        punishmentExplanationLabel.text = titleLabelArray[index]
        punishmentExplanationLabel.morphingEffect = .burn
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(updateTimer(timer:)), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    
    @objc func updateTimer(timer: Timer) {
        punishmentExplanationLabel.text = titleLabelArray[index]
        index += 1
        if index >= titleLabelArray.count { index = 0 }
    }

    @IBAction func backButton(_ sender: Any) {
        setValue.resetFlag = true
        interstitial?.present(fromRootViewController: self)
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
