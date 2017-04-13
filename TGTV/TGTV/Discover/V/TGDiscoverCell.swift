//
//  TGDiscoverCell.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/9.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit
private let kDiscoverCollectionViewCellID = "kDiscoverCollectionViewCellID"

class TGDiscoverCell: UITableViewCell {
    @IBOutlet weak var collectionV: UICollectionView!
    
    fileprivate lazy var discoverVM: TGDiscoverContentVM = TGDiscoverContentVM()
    fileprivate var anchorData : [TGAnchorM]?
    fileprivate var currentIndex : Int = 0
    var cellDidSelected : ((_ anchor : TGAnchorM) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        discoverVM.loadContentData {
            self.anchorData = Array(self.discoverVM.anchorMs[self.currentIndex * 9..<(self.currentIndex + 1) * 9])
            self.collectionV.reloadData()
        }
        collectionV.dataSource = self
        collectionV.delegate = self
        collectionV.register(UINib(nibName: "TGDiscoverAnchorCell", bundle: nil), forCellWithReuseIdentifier: kDiscoverCollectionViewCellID)
    }
    
    func reloadData() {
        currentIndex += 1
        if currentIndex > 2 { currentIndex = 0 }
        anchorData = Array(discoverVM.anchorMs[currentIndex * 9..<(currentIndex + 1) * 9])
        collectionV.reloadData()
    }
}

extension TGDiscoverCell : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return anchorData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionV.dequeueReusableCell(withReuseIdentifier: kDiscoverCollectionViewCellID, for: indexPath) as! TGDiscoverAnchorCell
        cell.anchorM = anchorData?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellDidSelected?(anchorData![indexPath.item])
    }
}

class TGDiscoverLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        let itemMargin: CGFloat = 10
        let itemW = ((collectionView?.bounds.width)! - 3 * itemMargin) / 2
        let itemH = (collectionView?.bounds.height)! / 2
        itemSize = CGSize(width: itemW, height: itemH)
        minimumLineSpacing = 0
        minimumInteritemSpacing = itemMargin
        sectionInset = UIEdgeInsets(top: 0, left: itemMargin, bottom: 0, right: itemMargin)
        collectionView?.bounces = false
        collectionView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
