//
//  TGWaterfallLayout.swift
//  TGWaterfall
//
//  Created by targetcloud on 2017/3/23.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

@objc protocol TGWaterfallLayoutDataSource:class {
    func waterfallLayout(_ layout :TGWaterfallLayout,itemIndexPath : IndexPath) -> CGFloat
    @objc optional func numberOfColsInWaterfallLayout(_ layout : TGWaterfallLayout) -> Int
}

class TGWaterfallLayout: UICollectionViewFlowLayout {

    weak var dataSource : TGWaterfallLayoutDataSource?
    fileprivate lazy var cols : Int = self.dataSource?.numberOfColsInWaterfallLayout?(self) ?? 2
    fileprivate lazy var attributes :[UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate lazy var maxH : CGFloat = self.sectionInset.top + self.sectionInset.bottom
    fileprivate lazy var heights : [CGFloat] = Array(repeating: self.sectionInset.top, count: self.cols)
    
    override func prepare() {
        super.prepare()
        //attributes.removeAll()
        guard let collectionView = collectionView else {
            return
        }
        let count = collectionView.numberOfItems(inSection: 0)
        let itemW = (collectionView.bounds.width - sectionInset.left - sectionInset.right - CGFloat(cols-1) * minimumInteritemSpacing) / CGFloat(cols)
        
        for i in attributes.count..<count{
            /*
            //let itemH = CGFloat(arc4random_uniform(150) + 50)
            */
            //正式使用时请使用这里 
            let indexPath = IndexPath(item: i, section: 0)
            guard let itemH = dataSource?.waterfallLayout(self, itemIndexPath: indexPath) else{
                fatalError("请检查数据源")
            }
            
            /*
            let itemH = dataSource?.waterfallLayout(self, itemIndex: i) ?? CGFloat(arc4random_uniform(150) + 50)//test
            */
            let minH = heights.min()!
            let minIndex = heights.index(of: minH)!
            let itemX = sectionInset.left + (minimumInteritemSpacing + itemW) * CGFloat(minIndex)
            let itemY = minH
            //heights[minIndex] = itemY
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribute.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
            attributes.append(attribute)
            heights[minIndex] = attribute.frame.maxY + minimumLineSpacing
            
        }
        
        maxH = heights.max()! - minimumLineSpacing
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
    
    override var collectionViewContentSize: CGSize{
        return CGSize(width: 0, height: maxH + sectionInset.bottom)
    }
}

extension TGWaterfallLayout{
    
}
