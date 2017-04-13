//
//  TGGiftPackage.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/11.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGGiftPackage: TGBaseM {
    var t: Int = 0
    var title: String = ""
    var list: [TGGiftM] = [TGGiftM]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "list" {
            guard let listArr = value as? [[String : Any]] else {
                return
            }
            for listDict in listArr {
                list.append(TGGiftM(dict: listDict))
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }

}
