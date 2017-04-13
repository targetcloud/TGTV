//
//  TGRankVM.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/9.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGRankVM {
    lazy var rankMs = [TGRankM]()
    func loadDetailRankData(_ type: TGRankType, _ complection:@escaping () -> ()) {
        let URLString = "http://qf.56.com/rank/v1/\(type.typeName).ios"
        let parameters = ["pageSize" : 30, "type" : type.typeNum]
        NetworkTools.share.requestData(.get, URLString: URLString, parameters: parameters) { (result) in
            print(" ---\(result)")
            guard let resultDict = result as? [String : Any],let msgDict = resultDict["message"] as? [String : Any],let dataArr = msgDict[type.typeName] as? [[String : Any]] else {
                return
            }
            for dict in dataArr {
                self.rankMs.append(TGRankM(dict: dict))
            }
            complection()
        }
    }
}
