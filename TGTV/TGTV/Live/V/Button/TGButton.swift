//
//  TGButton.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/11.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        imageView?.contentMode = .scaleAspectFit
        titleLabel?.textAlignment = .center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let ratio : CGFloat = 0.8
        imageView?.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height * ratio)
        titleLabel?.frame = CGRect(x: 0, y: imageView!.frame.maxY, width: frame.width, height: frame.height * (1 - ratio))
    }

}
