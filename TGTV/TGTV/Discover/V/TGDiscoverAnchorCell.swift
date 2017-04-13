//
//  TGDiscoverAnchorCell.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/9.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGDiscoverAnchorCell: UICollectionViewCell {

    @IBOutlet weak var onlineLbl: UILabel!
    @IBOutlet weak var nickNameLbl: UILabel!
    @IBOutlet weak var iconImageV: UIImageView!
    @IBOutlet weak var liveImageV: UIImageView!
    
    var anchorM: TGAnchorM? {
        didSet {
            onlineLbl.text = "\(anchorM?.focus ?? 0)人观看"
            nickNameLbl.text = anchorM?.name
            iconImageV.setImage(anchorM?.pic51, UIImage(named: "live_cell_default_phone"), false)
            liveImageV.isHidden = anchorM?.live == 0
        }
    }

}
