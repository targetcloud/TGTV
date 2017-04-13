//
//  TGFocusVM.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/10.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGFocusVM {
    lazy var anchorMs = [TGAnchorM]()
    
    func loadFocusData(completion: () -> ()) {
        let dataArr = SqliteTools.share.querySQL("SELECT * FROM t_focus;")
        for dict in dataArr {
            self.anchorMs.append(TGAnchorM(dict: dict))
        }
        completion()
    }
}
