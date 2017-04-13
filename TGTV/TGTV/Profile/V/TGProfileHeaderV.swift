//
//  TGProfileHeaderV.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/8.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit
import SnapKit

class TGProfileHeaderV: UIView {
    fileprivate lazy var backImageV : UIImageView = {
        let backImageView = UIImageView(image: UIImage(named: "my_dynamic_bg"))
        backImageView.contentMode = .scaleAspectFill
        backImageView.layer.masksToBounds = true
        self.addSubview(backImageView)
        return backImageView
    }()
    
    fileprivate lazy var alphaV : UIView = {
        let alphaView = UIView()
        alphaView.backgroundColor = UIColor(hex: "0x000000")
        alphaView.alpha = 0.5
        self.addSubview(alphaView)
        return alphaView
    }()
    
    fileprivate lazy var avatarImageV : UIImageView = {
        let avatarView = UIImageView(image: UIImage(named: "my_dynamic_bg"))
        avatarView.layer.cornerRadius = 45.0
        avatarView.layer.masksToBounds = true
        avatarView.layer.borderColor = UIColor(hex: "0xFFB02C")?.cgColor
        avatarView.layer.borderWidth = 2.0
        avatarView.layer.rasterizationScale = UIScreen.main.scale
        avatarView.layer.shouldRasterize = true
        self.addSubview(avatarView)
        return avatarView
    }()
    
    lazy var userNameBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle("点击登录", for: .normal)
        self.addSubview(btn)
        return btn
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin: CGFloat = 10.0
        let hspace: CGFloat = (self.width - kScreenW) * 0.5
        /*
        print(" --- hspace\(hspace) --- \(self.width) \(self.height) ---- ")
        
        offsetY->-2.0 kScreenW->414.0 width->416.0 kHeaderViewH->252.0 height->254.0
        --- hspace1.0 --- 416.0 254.0 ----
        */
        backImageV.frame = CGRect(x: hspace, y: 0, width: kScreenW, height: self.height)
        alphaV.frame = backImageV.frame
        
        avatarImageV.snp.makeConstraints { (make) in
            make.width.height.equalTo(90.0)
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY).offset(-20)
        }
        
        userNameBtn.snp.makeConstraints { (make) in
            make.height.equalTo(18)
            make.top.equalTo(avatarImageV.snp.bottom).offset(margin)
            make.centerX.equalTo(avatarImageV.snp.centerX)
        }
    }
}
