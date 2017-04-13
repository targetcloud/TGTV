//
//  TGEmoticonPackage.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/11.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGEmoticonPackage {
    lazy var emoticonMs : [TGEmoticonM] = [TGEmoticonM]()
    
    init(plistName: String) {
        guard let path = Bundle.main.path(forResource: plistName, ofType: nil),let emoticonArr = NSArray(contentsOfFile: path) as? [String] else {
            return
        }
        for e in emoticonArr {
            emoticonMs.append(TGEmoticonM(emoticonName: e))
        }
    }
}
