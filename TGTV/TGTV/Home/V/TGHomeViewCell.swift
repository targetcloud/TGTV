//
//  TGHomeViewCell.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/10.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGHomeViewCell: UICollectionViewCell {

    @IBOutlet weak var albumImageV: UIImageView!
    @IBOutlet weak var liveImageV: UIImageView!
    @IBOutlet weak var nickNameLbl: UILabel!
    @IBOutlet weak var onlineLbl: UIButton!
    
    var anchorM : TGAnchorM? {
        didSet {
            albumImageV.setImage((anchorM?.isEvenIndex)! ? anchorM?.pic74 : anchorM?.pic51, UIImage(named: "live_cell_default_phone"), false)
            liveImageV.isHidden = anchorM?.live == 0
            nickNameLbl.text = anchorM?.name
            onlineLbl.setTitle(" " + "\(anchorM?.focus ?? 0)", for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
