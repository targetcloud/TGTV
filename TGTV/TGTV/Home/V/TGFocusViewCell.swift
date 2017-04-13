//
//  TGFocusViewCell.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/10.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGFocusViewCell: UITableViewCell {

    @IBOutlet weak var iconImageV: UIImageView!
    @IBOutlet weak var nickNameLbl: UILabel!
    @IBOutlet weak var liveImageV: UIImageView!
    
    var anchorM: TGAnchorM? {
        didSet{
            iconImageV.setImage(anchorM?.pic51, UIImage(named:"Avatar"), true)
            nickNameLbl.text = anchorM?.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
