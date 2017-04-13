//
//  TGEmoticonV.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/12.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit
private let kEdgeMargin : CGFloat = 10
private let kEmoticonCellID = "kEmoticonCellID"

class TGEmoticonV: UIView {

    var emoticonClickCallBack: ((TGEmoticonM) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        let style = TGPageStyle()
        style.isTitleInTop = false
        style.bottomLineColor = UIColor.orange
        style.titleViewHeight = 35
        style.normalColor = UIColor.darkGray
        style.selectColor = UIColor.orange
        
        let layout = TGPageCollectionLayout()
        layout.cols = 7
        layout.rows = 3
        layout.sectionInset = UIEdgeInsets(top: kEdgeMargin, left: kEdgeMargin, bottom: kEdgeMargin, right: kEdgeMargin)
        let pageView = TGPageCollectionView(frame: self.bounds, titles: ["普通","粉丝专属"], titleStyle: style, layout: layout)
        pageView.register(nib: UINib(nibName: "TGEmoticonViewCell", bundle: nil), forCellWithReuseIdentifier: kEmoticonCellID)
        addSubview(pageView)
        pageView.dataSource = self
        pageView.delegate = self
    }
}

extension TGEmoticonV: TGPageCollectionViewDataSource {
    func numberOfSections(in pageCollectionView: TGPageCollectionView) -> Int {
        return TGEmoticonVM.share.packages.count
    }
    
    func pageCollectionView(_ collectionView: TGPageCollectionView, numberOfItemsInSection section: Int) -> Int {
        return TGEmoticonVM.share.packages[section].emoticonMs.count
    }
    
    func pageCollectionView(_ pageCollectionView: TGPageCollectionView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kEmoticonCellID, for: indexPath) as! TGEmoticonViewCell
        cell.emoticon = TGEmoticonVM.share.packages[indexPath.section].emoticonMs[indexPath.item]
        return cell
    }
}

extension TGEmoticonV : TGPageCollectionViewDelegate {
    func pageCollectionView(_ pageCollectionView: TGPageCollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoticon = TGEmoticonVM.share.packages[indexPath.section].emoticonMs[indexPath.item]
        emoticonClickCallBack?(emoticon)
    }
}

