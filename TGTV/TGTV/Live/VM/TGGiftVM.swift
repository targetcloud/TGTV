//
//  TGGiftVM.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/11.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGGiftVM {
    lazy var giftlistData : [TGGiftPackage] = [TGGiftPackage]()
    
    func loadGiftData(finishedCallBack:@escaping () -> ())  {
        NetworkTools.share.requestData(.get, URLString: "http://qf.56.com/pay/v4/giftList.ios", parameters: ["type" : 0, "page" : 1, "rows" : 150]) { (result) in
            guard let resultDict = result as? [String : Any],let dataDict = resultDict["message"] as? [String : Any] else { return }
            for i in 0..<dataDict.count {
                guard let dict = dataDict["type\(i+1)"] as? [String : Any] else { continue }
                self.giftlistData.append(TGGiftPackage(dict: dict))
            }
            self.giftlistData = self.giftlistData.filter({ return $0.t != 0 }).sorted(by: { return $0.t > $1.t })
            finishedCallBack()
        }
    }
}
