//
//  TGRankVC.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/8.
//  Copyright © 2017年 targetcloud. All rights reserved.
//http://blog.csdn.net/callzjy/article/details/70160050

import UIKit

class TGRankVC: TGBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        setupUI()
    }

    fileprivate func setupUI() {
        let rect = CGRect(x: 0, y: kStatusBarH, width: kScreenW, height: kScreenH - kStatusBarH)
        let titles = ["明星榜","富豪榜","人气榜","周星榜"]
        let style = TGPageStyle()
        style.normalColor = UIColor.darkGray
        style.selectColor = UIColor.orange
        style.bottomLineColor = UIColor.orange
        style.bottomLineMargin = 0
        style.bottomLineExtendWidth = 20
        var childVCs = [TGSubRankVC]()
        for i in 0..<titles.count {
            let vc = i == 3 ? TGWeeklyRankVC() : TGNomalRankVC()
            vc.currentIndex = i
            childVCs.append(vc)
        }
        let scrollPageView = TGPageView(frame: rect, titles: titles, titleStyle: style, childVCs: childVCs, parentVC: self)
        view.addSubview(scrollPageView)
    }

}
