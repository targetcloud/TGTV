//
//  TGEmoticonVM.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/11.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGEmoticonVM {
    static let share : TGEmoticonVM = TGEmoticonVM()
    lazy var packages: [TGEmoticonPackage] = [TGEmoticonPackage]()
    
    init() {
        packages.append(TGEmoticonPackage(plistName: "emotion.plist"))
        packages.append(TGEmoticonPackage(plistName: "e2.plist"))
    }
}
