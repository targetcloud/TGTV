//
//  TGNibLoadable.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/8.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

protocol TGNibLoadable {
}

extension TGNibLoadable where Self : UIView{
//    static func loadFromNib(_ nibname : String? = nil) -> Self {
//        return Bundle.main.loadNibNamed(nibname ?? "\(self)" , owner: nil, options: nil)?.first as! Self
//    }
    
    
    static func loadFromNib(_ nibNmae :String = "") -> Self{
        let nib = nibNmae == "" ? "\(self)" : nibNmae
        print(nib)
        return Bundle.main.loadNibNamed(nib, owner: nil, options: nil)?.first as! Self
    }
    
//    static func loadNib(_ nibNmae :String? = nil) -> Self{
//        return Bundle.main.loadNibNamed(nibNmae ?? "\(self)", owner: nil, options: nil)?.first as! Self
    
    //    class func loadFromNib() -> TGGiftChannelV {
    //        return Bundle.main.loadNibNamed("TGGiftChannelV", owner: nil, options: nil)?.first as! TGGiftChannelV
    //    }
}
