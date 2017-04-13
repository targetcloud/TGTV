//
//  TGBannerVM.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/9.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit
import MJExtension

class TGBannerVM {
    lazy var banners = [String]()
    lazy var links = [String]()
    lazy var names = [String]()
    lazy var carousels : [TGBannerM] = [TGBannerM]()
    
    func loadCarouselData(_ complection :  @escaping () -> ()) {
        NetworkTools.share.requestData(.get, URLString: "http://qf.56.com/home/v4/getBanners.ios", finishedCallback: { (result : Any) in
            print(" ---\(result)")
            guard let resultDict = result as? [String : Any],let msgDict = resultDict["message"] as? [String : Any],let banners = msgDict["banners"] as? [[String : Any]] else { return }
            
            var urlArrM = [String]()
            var linkArrM = [String]()
            var nameArrM = [String]()
        
            for dict in banners {
                self.carousels.append(TGBannerM(dict: dict))
            }
            
            for i in 0..<self.carousels.count {
                let model = TGBannerM.mj_object(withKeyValues: self.carousels[i])
                urlArrM.append((model?.picUrl)!)
                linkArrM.append((model?.linkUrl)!)
                nameArrM.append((model?.name)!)
            }
            
            self.banners = urlArrM
            self.links = linkArrM
            self.names = nameArrM
            complection()
        })
    }

}
