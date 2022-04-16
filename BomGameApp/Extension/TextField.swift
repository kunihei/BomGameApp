//
//  TextField.swift
//  BomGameApp
//
//  Created by 祥平 on 2022/03/22.
//

import Foundation
import UIKit

extension UITextField {
    func setUnderLine() {
        // 枠線を非表示にする
        borderStyle = .none
        let underline = UIView()
        // heightにはアンダーラインの高さを入れる
        underline.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: 0.5)
        // 枠線の色
        underline.backgroundColor = .white
        addSubview(underline)
        // 枠線を最前面に
        bringSubviewToFront(underline)
    }
}
