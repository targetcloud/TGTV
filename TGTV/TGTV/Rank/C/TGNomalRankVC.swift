//
//  TGNomalRankVC.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/9.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGNomalRankVC: TGSubRankVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    fileprivate func setupUI() {
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - kStatusBarH - kNavigationBarH - kTabBarH)
        let titles = ["日榜", "周榜", "月榜", "总榜"]
        let style = TGPageStyle()
        style.isShowBottomLine = false
        style.titleViewHeight = 35
        style.normalColor = UIColor.darkGray
        style.selectColor = UIColor.orange
        style.bottomLineColor = UIColor.orange
        style.titleFont = UIFont.systemFont(ofSize: 13.0)
        style.isShowCoverView = true
        style.coverBgColor = UIColor.lightGray
        style.coverHeight = 20
        style.coverMargin = 24
        var childVCs = [TGNomalDetailVC]()
        for i in 0..<titles.count {
            let rankType = TGRankType(typeName: typeName, typeNum: i + 1)
            let vc = TGNomalDetailVC(rankType: rankType)
            childVCs.append(vc)
        }
        let scrollPageView = TGPageView(frame: rect, titles: titles, titleStyle: style, childVCs: childVCs, parentVC: self)
        view.addSubview(scrollPageView)
    }
    
}
