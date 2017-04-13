//
//  TGShareV.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/11.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGShareV: UIView,TGNibLoadable {
    @IBOutlet  var shareBtns: [TGButton]!
    
    @IBAction func didClickCopyBtn(_ sender: TGButton) {
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = "主播房间地址"
    }
    
    func showShareView() {
        for btn in shareBtns {
            btn.transform = CGAffineTransform(translationX: 0, y: 158)
        }
        for (index,btn) in shareBtns.enumerated() {
            UIView.animate(withDuration: 0.5, delay: 0.25 + Double(index) * 0.02, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: .curveLinear, animations: {
                btn.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }

}
