//
//  TGEmoticonViewCell.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/12.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGEmoticonViewCell: UICollectionViewCell {

    @IBOutlet weak var imageV: UIImageView!
    
    var emoticon: TGEmoticonM? {
        didSet {
            imageV.image = UIImage(named: (emoticon?.emoticonName)!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
