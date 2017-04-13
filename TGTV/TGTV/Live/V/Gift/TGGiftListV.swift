//
//  TGGiftListV.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/12.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit
private let kEdgeMargin: CGFloat = 10.0
private let kGiftViewCellID = "kGiftViewCellID"

protocol TGGiftListViewDelegate : NSObjectProtocol {
    func giftListView(giftListView: TGGiftListV , giftModel: TGGiftM)
}

class TGGiftListV: UIView,TGNibLoadable {
    weak var delegate : TGGiftListViewDelegate?
    
    @IBOutlet weak var sendTo: UILabel!
    @IBOutlet weak var giftV: UIView!
    @IBOutlet weak var sendGiftBtn: UIButton!
    fileprivate var currentIndexPath : IndexPath?
    fileprivate var pageCollectionV : TGPageCollectionView!
    fileprivate var giftVM : TGGiftVM = TGGiftVM()
    fileprivate var titles : [String] = ["热门", "高级", "豪华", "专属","还有"]
    
    var Anchor : String? {
        didSet{
            self.sendTo.text = "赠给:\(Anchor ?? "")"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sendGiftBtn.isEnabled = false
        setupGiftView()
        loadGiftData()
    }
    
    fileprivate func loadGiftData() {
        giftVM.loadGiftData {
            self.pageCollectionV.reloadData()
            self.pageCollectionV.setTitles(titles: Array(self.titles[0..<self.giftVM.giftlistData.count]))
        }
    }
    
    fileprivate func setupGiftView() {
        let style = TGPageStyle()
        style.titleViewHeight = 35
        style.normalColor = UIColor.white
        style.selectColor = UIColor.orange
        style.bottomLineColor = UIColor.orange
        style.bottomLineMargin = 0
        style.bottomLineExtendWidth = 22
        style.titleFont = UIFont.systemFont(ofSize: 14.0)
        
        let layout = TGPageCollectionLayout()
        layout.cols = 4
        layout.rows = 2
        layout.sectionInset = UIEdgeInsets(top: kEdgeMargin, left: kEdgeMargin, bottom: kEdgeMargin, right: kEdgeMargin)
        layout.lineMargin = 5
        layout.itemMargin = 5
        
        var pageViewFrame = giftV.bounds
        pageViewFrame.size.width = kScreenW
        pageCollectionV = TGPageCollectionView(frame:pageViewFrame, titles: titles, titleStyle: style, layout: layout)
        pageCollectionV.dataSource = self
        pageCollectionV.register(nib: UINib(nibName: "TGGiftViewCell", bundle: nil), forCellWithReuseIdentifier: kGiftViewCellID)
        pageCollectionV.delegate = self
        giftV.addSubview(pageCollectionV)
    }
    
    @IBAction func sendGiftBtnClick(_ sender: UIButton) {
        let package = giftVM.giftlistData[currentIndexPath!.section]
        let giftModel = package.list[currentIndexPath!.item]
        delegate?.giftListView(giftListView: self, giftModel: giftModel)
    }

}

extension TGGiftListV : TGPageCollectionViewDataSource, TGPageCollectionViewDelegate {
    func numberOfSections(in pageCollectionView: TGPageCollectionView) -> Int {
        return giftVM.giftlistData.count
    }

    func pageCollectionView(_ collectionView: TGPageCollectionView, numberOfItemsInSection section: Int) -> Int {
        let package = giftVM.giftlistData[section]
        return package.list.count
    }

    func pageCollectionView(_ pageCollectionView: TGPageCollectionView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGiftViewCellID, for: indexPath) as! TGGiftViewCell
        cell.giftModel = giftVM.giftlistData[indexPath.section].list[indexPath.item]
        return cell
    }
    
    func pageCollectionView(_ pageCollectionView: TGPageCollectionView, didSelectItemAt indexPath: IndexPath) {
        sendGiftBtn.isEnabled = true
        currentIndexPath = indexPath
    }
}
