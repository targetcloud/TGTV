//
//  TGAnchorVC.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/10.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

private let kEdgeMargin : CGFloat = 5
private let kCollectionCellId = "kCollectionCellID"

class TGAnchorVC: TGBaseVC {

    var homeType : TGHomeStyle?
    fileprivate lazy var homeVM : TGHomeVM = TGHomeVM()
    
    fileprivate lazy var animImageV: UIImageView = { [unowned self] in
        let imageView = UIImageView(image: UIImage(named: "img_loading_1"))
        imageView.center = self.view.center
        imageView.animationImages = [UIImage(named: "img_loading_1")!, UIImage(named: "img_loading_2")!]
        imageView.animationDuration = 0.5
        imageView.animationRepeatCount = LONG_MAX
        imageView.backgroundColor = UIColor.clear
        imageView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin]
        return imageView
    }()
    
    fileprivate lazy var collectionV : UICollectionView =  {
        let layout = TGWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: kEdgeMargin, left: kEdgeMargin, bottom: kEdgeMargin, right: kEdgeMargin)
        layout.minimumLineSpacing = kEdgeMargin
        layout.minimumInteritemSpacing = kEdgeMargin
        layout.dataSource = self
        let collectionView = UICollectionView(frame: self.view.bounds , collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.register(UINib(nibName: "TGHomeViewCell", bundle: nil), forCellWithReuseIdentifier: kCollectionCellId)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        loadData(index: 0)
    }

    fileprivate func setupUI() {
        view.addSubview(collectionV)
        collectionV.isHidden = true
        view.addSubview(animImageV)
        animImageV.startAnimating()
    }
    
    fileprivate func loadData(index : Int) {
        homeVM.loadHomeData(type: homeType!, index: index, finishedCallback: {
            self.collectionV.reloadData()
            self.loadDataFinished()
            self.collectionV.delegate = self
        })
    }
    
    fileprivate func loadDataFinished() {
        animImageV.stopAnimating()
        animImageV.isHidden = true
        collectionV.isHidden = false
    }
}

extension TGAnchorVC : TGWaterfallLayoutDataSource {    
    func numberOfColsInWaterfallLayout(_ layout: TGWaterfallLayout) -> Int {
        return 3
    }
    
    func waterfallLayout(_ layout: TGWaterfallLayout, itemIndexPath: IndexPath) -> CGFloat {
        return itemIndexPath.item % 2 == 0 ? kScreenW * 0.45 : kScreenW * 0.5
    }
}

extension TGAnchorVC : UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeVM.anchorMs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView .dequeueReusableCell(withReuseIdentifier: kCollectionCellId, for: indexPath) as! TGHomeViewCell
        cell.anchorM = homeVM.anchorMs[indexPath.item]
//        if indexPath.item == homeVM.anchorMs.count - 1 {
//            loadData(index: homeVM.anchorMs.count)
//        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let roomVC = TGRoomVC()
        roomVC.anchor = homeVM.anchorMs[indexPath.item]
        navigationController?.pushViewController(roomVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {//上拉加载更多效果
            print("------>>>>>>>>>>>>\(scrollView.contentSize.height) \(scrollView.bounds.height) \(scrollView.contentSize.height - scrollView.bounds.height) <<<<<<<<<<<<<<<------")
            collectionV.delegate = nil
            loadData(index: homeVM.anchorMs.count)
        }
    }
    
}
