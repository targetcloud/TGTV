//
//  TGDiscoverContentVM.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/9.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGDiscoverContentVM {
    lazy var anchorMs = [TGAnchorM]()
    
    func loadContentData(_ complection: @escaping () -> ()) {
        NetworkTools.share.requestData(.get, URLString: "http://qf.56.com/home/v4/guess.ios", parameters: ["count" : 27]) { (json: Any) in
            print(" ---\(json)")
            guard let responseDict = json as? [String : Any],let msgDict = responseDict["message"] as? [String : Any],let dataArr = msgDict["anchors"] as? [[String : Any]] else {
                return
            }
            for dict in dataArr {
                self.anchorMs.append(TGAnchorM(dict: dict))
            }
            complection()
        }
    }
}
