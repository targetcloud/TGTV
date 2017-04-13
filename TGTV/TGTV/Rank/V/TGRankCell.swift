//
//  TGRankCell.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/9.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGRankCell: UITableViewCell {

    @IBOutlet weak var rankNumBtn: UIButton!
    @IBOutlet weak var iconImageV: UIImageView!
    @IBOutlet weak var nickNameLbl: UILabel!
    @IBOutlet weak var liveImageV: UIImageView!
    
    var rankNum : Int = 0 {
        didSet {
            if rankNum < 3 {
                rankNumBtn.setTitle("", for: .normal)
                rankNumBtn.setImage(UIImage(named: "ranking_icon_no\(rankNum + 1)"), for: .normal)
            } else {
                rankNumBtn.setImage(nil, for: .normal)
                rankNumBtn.setTitle("\(rankNum + 1)", for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    var rankM : TGRankM? {
        didSet {
            iconImageV.setImage(rankM?.avatar, nil, true)
            nickNameLbl.text = rankM?.nickname
            liveImageV.isHidden = rankM?.isInLive == 0
        }
    }
    
}
