//
//  TGRankType.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/9.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGRankType: NSObject {
    var typeName: String = ""
    var typeNum: Int = 0
    
    init(typeName: String, typeNum:Int) {
        self.typeName = typeName
        self.typeNum = typeNum
    }
}
