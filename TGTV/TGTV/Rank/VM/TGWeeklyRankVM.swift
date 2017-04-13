//
//  TGWeeklyRankVM.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/9.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGWeeklyRankVM {
    lazy var weeklyRankMs : [[TGWeekM]] = [[TGWeekM]]()
    
    func loadWeeklyRankData(_ rankType : TGRankType, _ completion : @escaping () -> ()) {
        let URLString = "http://qf.56.com/activity/star/v1/rankAll.ios"
        let signature = rankType.typeNum == 1 ? "b4523db381213dde637a2e407f6737a6" : "d23e92d56b1f1ac6644e5820eb336c3e"
        let ts = rankType.typeNum == 1 ? "1480399365" : "1480414121"
        let parameters : [String : Any] = ["imei" : "36301BB0-8BBA-48B0-91F5-33F1517FA056", "pageSize" : 30, "signature" : signature, "ts" : ts, "weekly" : rankType.typeNum - 1]
        
        NetworkTools.share.requestData(.get, URLString: URLString, parameters: parameters, finishedCallback: { result in
            guard let resultDict = result as? [String : Any],let msgDict = resultDict["message"] as? [String : Any] else { return }
            
            if let anchorDataArr = msgDict["anchorRank"] as? [[String : Any]] {
                self.addDataToWeeklyRankMs(anchorDataArr)
            }
        
            if let fansDataArr = msgDict["fansRank"] as? [[String : Any]] {
                self.addDataToWeeklyRankMs(fansDataArr)
            }
            completion()
        })
    }
    
    private func addDataToWeeklyRankMs(_ dataArray : [[String : Any]]) {
        var ranks = [TGWeekM]()
        for dict in dataArray {
            ranks.append(TGWeekM(dict: dict))
        }
        weeklyRankMs.append(ranks)
    }
}
