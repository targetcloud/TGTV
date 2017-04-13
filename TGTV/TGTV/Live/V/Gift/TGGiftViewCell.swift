//
//  TGGiftViewCell.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/12.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGGiftViewCell: UICollectionViewCell {

    @IBOutlet weak var iconImageV: UIImageView!
    @IBOutlet weak var subjectLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    
    var giftModel : TGGiftM? {
        didSet {
            iconImageV.setImage(giftModel?.img2, UIImage(named: "room_btn_gift"), true)
            subjectLbl.text = giftModel?.subject
            priceLbl.text = "\(giftModel?.coin ?? 0)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconImageV.layer.cornerRadius = iconImageV.frame.height * 0.5
        iconImageV.layer.masksToBounds = true
        
        let selectedView = UIView()
        selectedView.layer.cornerRadius = 5
        selectedView.layer.masksToBounds = true
        selectedView.layer.borderColor = UIColor.orange.cgColor
        selectedView.layer.borderWidth = 2
        selectedView.backgroundColor = UIColor.clear
        
        selectedBackgroundView = selectedView
    }


}
