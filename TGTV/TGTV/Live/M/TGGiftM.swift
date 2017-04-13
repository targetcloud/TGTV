//
//  TGGiftM.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/11.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGGiftM: TGBaseM {
    var img2: String = ""
    var coin: Int = 0
    var subject: String = "" {
        didSet{
            if subject.contains("(有声)") {
                subject = subject.replacingOccurrences(of: "(有声)", with: "")
            }
        }
    }
}
