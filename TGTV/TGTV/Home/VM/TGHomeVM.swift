//
//  TGHomeVM.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/10.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGHomeVM {
    lazy var anchorMs = [TGAnchorM]()
    
    func loadHomeData(type: TGHomeStyle,index : Int,  finishedCallback : @escaping () -> ()) {
        NetworkTools.share.requestData(.get, URLString: "http://qf.56.com/home/v4/moreAnchor.ios", parameters: ["type" : type.type, "index" : index, "size" : 48]) { (json) in
            //print(" --- \(json)")
            guard let resultDict = json as? [String : Any],let messageDict = resultDict["message"] as? [String : Any],let anchorsArr = messageDict["anchors"] as? [[String : Any]] else {
                    return
            }
            
            for (index,dict) in anchorsArr.enumerated() {
                let anchor = TGAnchorM(dict: dict)
                anchor.isEvenIndex = index % 2 == 0
                self.anchorMs.append(anchor)
            }
            print(" --- \(anchorsArr.count) \(self.anchorMs.count)")
            finishedCallback()
        }
    }
}
