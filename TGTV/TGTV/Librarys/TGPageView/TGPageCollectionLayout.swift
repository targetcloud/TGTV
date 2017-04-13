//
//  TGPageCollectionLayout.swift
//  TGPageView
//
//  Created by targetcloud on 2017/3/24.
//  Copyright © 2017年 targetcloud. All rights reserved.
//http://blog.csdn.net/callzjy/article/details/70160050

import UIKit

class TGPageCollectionLayout: UICollectionViewLayout {
    var sectionInset :UIEdgeInsets = .zero
    var itemMargin : CGFloat = 0
    var lineMargin :CGFloat = 0
    var cols : Int = 4//wechat 9 weibo 7
    var rows : Int = 2//common 3
    var contentWidth : CGFloat = 0
    fileprivate lazy var attributes :[UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else {
            return
        }
        let itemW = (collectionView.bounds.width - sectionInset.left - sectionInset.right - CGFloat(cols - 1) * itemMargin) / CGFloat(cols)
        let itemH = (collectionView.bounds.height - sectionInset.top - sectionInset.bottom - CGFloat(rows - 1) * lineMargin) / CGFloat(rows)
        
        var totalPages :Int = 0
        for section in 0..<collectionView.numberOfSections{
            let items = collectionView.numberOfItems(inSection: section)
            for item in 0..<items{
                let subPages = item / (cols * rows)
                let indexPath = IndexPath(item:item ,section : section)
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                let itemX = CGFloat(totalPages + subPages) * collectionView.bounds.width + sectionInset.left + CGFloat(item % cols) * (itemMargin + itemW)
                let itemY = sectionInset.top + (itemH + lineMargin) * CGFloat(item / cols % rows)
                attribute.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
                attributes.append(attribute)
            }
            totalPages += ((items - 1) / (cols * rows) + 1)
        }
        contentWidth = CGFloat(totalPages) * collectionView.bounds.width 
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
    
    override var collectionViewContentSize: CGSize{
        return CGSize(width: contentWidth, height: 0)
    }
}
