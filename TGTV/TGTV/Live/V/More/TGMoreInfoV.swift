//
//  TGMoreInfoV.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/11.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGMoreInfoV: UIView,TGNibLoadable {

    @IBOutlet  var btns: [TGButton]!
    
    func showMoreInfoView() {
        for btn in btns {
            btn.transform = CGAffineTransform(translationX: 0, y: 60)
        }
        for (index,btn) in btns.enumerated() {
            UIView.animate(withDuration: 0.5, delay: 0.25 + Double(index) * 0.02, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: .curveLinear, animations: {
                btn.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }

}
