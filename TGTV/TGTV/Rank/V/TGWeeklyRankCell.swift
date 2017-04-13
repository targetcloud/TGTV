//
//  TGWeeklyRankCell.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/9.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGWeeklyRankCell: UITableViewCell {

    @IBOutlet weak var iconImageV: UIImageView!
    @IBOutlet weak var giftNameLbl: UILabel!
    @IBOutlet weak var giftNumLbl: UILabel!
    @IBOutlet weak var nickNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    var weeklyM : TGWeekM? {
        didSet {
            iconImageV.setImage(weeklyM?.giftAppImg, nil, true)
            giftNameLbl.text = weeklyM?.giftName
            giftNumLbl.text = "本周获得 x\(weeklyM?.giftNum ?? 0)个"
            nickNameLbl.text = weeklyM?.nickname
        }
    }
    
}
