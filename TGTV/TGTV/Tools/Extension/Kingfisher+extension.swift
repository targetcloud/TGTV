//
//  Kingfisher+extension.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/5.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(_ URLString : String?, _ placeHolderName : UIImage? = nil, _ isAvatar: Bool = false, _ avatarColor: UIColor = UIColor.clear) {
        guard let URLString = URLString, let url = URL(string: URLString) else {
            image = placeHolderName
            return
        }
        kf.setImage(with: url, placeholder: placeHolderName, options: [], progressBlock: nil) {[weak self] (image, _, _, _) in
            if isAvatar {
                self?.image = image?.tg_avatarImage(size: self?.bounds.size,lineColor:avatarColor)
            }
        }
    }
}
