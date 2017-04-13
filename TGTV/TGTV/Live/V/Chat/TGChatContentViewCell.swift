//
//  TGChatContentViewCell.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/12.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGChatContentViewCell: UITableViewCell {

    @IBOutlet weak var contentLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
}
