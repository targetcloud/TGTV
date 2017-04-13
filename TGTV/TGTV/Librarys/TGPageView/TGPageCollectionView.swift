//
//  TGPageCollectionView.swift
//  TGPageView
//
//  Created by targetcloud on 2017/3/24.
//  Copyright © 2017年 targetcloud. All rights reserved.
//http://blog.csdn.net/callzjy/article/details/70160050

import UIKit

/*
private let kPageCollectionViewCellID = "kPageCollectionViewCellID"
*/

protocol TGPageCollectionViewDataSource :class {//MARK:- DataSource 1
    func numberOfSections(in pageCollectionView: TGPageCollectionView ) -> Int
    func pageCollectionView(_ pageCollectionView: TGPageCollectionView, numberOfItemsInSection section: Int) -> Int
    func pageCollectionView(_ pageCollectionView: TGPageCollectionView, collectionView : UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

protocol TGPageCollectionViewDelegate : NSObjectProtocol {
    func pageCollectionView(_ pageCollectionView: TGPageCollectionView, didSelectItemAt indexPath: IndexPath)
}

class TGPageCollectionView: UIView {

    weak var dataSource : TGPageCollectionViewDataSource?//MARK:- DataSource 2
    weak var delegate : TGPageCollectionViewDelegate?
    
    fileprivate var layout : TGPageCollectionLayout
    fileprivate var titles : [String] 
    fileprivate var titleStyle : TGPageStyle
    fileprivate var titleView : TGTitleView!
    fileprivate var pageControl : UIPageControl!
    fileprivate lazy var currentIndex : IndexPath = IndexPath(item: 0, section: 0)
    
//    fileprivate var collectionView : UICollectionView?
    fileprivate var collectionView : UICollectionView!//用！ 则后面使用到不用写写？  ->  用！意思是这行代码的作者对此保证：若有用到此collectionView,则一定有值  ->  若用？ 则后面的代码一直要用？，系统不会强行解包，而是进行可选链形式操作，如果没有值，则不往下操作  ->  如果使用的是！，发现没有值，则会崩  ->  所以你有把握用! 没有把握用？
    
    init(frame: CGRect,titles : [String],titleStyle : TGPageStyle,layout : TGPageCollectionLayout) {
        self.titles = titles
        self.titleStyle = titleStyle
        self.layout = layout
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(){
        self.backgroundColor = titleStyle.contentBgColor
        
        let titleY = titleStyle.isTitleInTop ? 0 : bounds.height - titleStyle.titleViewHeight
        let titleViewFrame = CGRect(x: 0, y: titleY, width: bounds.width, height: titleStyle.titleViewHeight)
        let titleView = TGTitleView(frame:titleViewFrame,titles:titles,style:titleStyle)
        titleView.backgroundColor = titleStyle.titleBgColor//UIColor.random()
        addSubview(titleView)
        self.titleView = titleView
        
        let contentY = titleStyle.isTitleInTop ? titleStyle.titleViewHeight : 0
        let contentFrame = CGRect(x: 0, y: contentY, width: bounds.width, height: bounds.height - titleStyle.titleViewHeight - titleStyle.pageControlHeigth)
        let contentView = UICollectionView(frame: contentFrame, collectionViewLayout: layout)
        contentView.showsHorizontalScrollIndicator = false
        contentView.backgroundColor = titleStyle.contentBgColor//UIColor.random()
        contentView.dataSource = self
        contentView.delegate = self
        /*
        contentView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kPageCollectionViewCellID)
        */
        contentView.isPagingEnabled = true
        collectionView = contentView
        addSubview(contentView)
        
        let pageControlY = contentFrame.maxY
        let pageControlFrame = CGRect(x: 0, y: pageControlY, width: bounds.width, height: titleStyle.pageControlHeigth)
        let pageControl = UIPageControl(frame: pageControlFrame)
        pageControl.numberOfPages = 1
        pageControl.backgroundColor = contentView.backgroundColor//UIColor.random()
        pageControl.tintColor = titleStyle.bottomLineColor
        pageControl.isUserInteractionEnabled = false
        addSubview(pageControl)
        self.pageControl = pageControl
        
        titleView.delegate = self//MARK:- 代理的使用 1 成为代理
    }

}

extension TGPageCollectionView {//保持和系统一样的用法和习惯
    func register(cellClass : AnyClass?, forCellWithReuseIdentifier reuseIdentifier: String){//UICollectionViewCell.Type?
        collectionView.register(cellClass, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func register(nib: UINib?, forCellWithReuseIdentifier reuseIdentifier: String){
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}

extension TGPageCollectionView : UICollectionViewDataSource{//MARK:- DataSource 3
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        /*
        return dataSource?.numberOfSections(in: self) ?? 4
        */
        return dataSource?.numberOfSections(in: self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /*
        return dataSource?.pageCollectionView(self, numberOfItemsInSection: section) ?? 1 + Int(arc4random_uniform(10))
        */
        let itemNum =  dataSource?.pageCollectionView(self, numberOfItemsInSection: section) ?? 0
        if section == 0 {
            pageControl.numberOfPages = (itemNum - 1) / (layout.rows * layout.cols) + 1
        }
        return itemNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /*
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPageCollectionViewCellID, for: indexPath)
        cell.backgroundColor = UIColor.random()
        var label :UILabel? = cell.contentView.subviews.first as? UILabel
        if label == nil{
            label = UILabel(frame: cell.bounds)
            label?.textAlignment = .center
            cell.contentView.addSubview(label!)
        }
        label?.text = "\(indexPath.section)-\(indexPath.item)"
        return cell
        */
        return (dataSource?.pageCollectionView(self, collectionView: collectionView,cellForItemAt: indexPath))!//通过参数暴露collectionView
    }
}

extension TGPageCollectionView:TGTitleViewDelegate{//MARK:- 代理的使用 2 遵守
    //MARK:- 代理的使用 3 实现协议方法
    func titleView(_ titleView: TGTitleView, targetIndex: Int) {
        let indexPath = IndexPath(item: 0, section: targetIndex)
        currentIndex = indexPath
        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: false)
        
        let sectionNum = dataSource?.numberOfSections(in: self) ?? 0
        let itemNum = dataSource?.pageCollectionView(self, numberOfItemsInSection: targetIndex) ?? 0
        
        pageControl.numberOfPages = (itemNum - 1) / (layout.rows * layout.cols) + 1
        pageControl.currentPage = indexPath.item / (layout.rows * layout.cols)
        //print(" --- \(sectionNum) \(itemNum) ---");
        if (targetIndex == (sectionNum - 1)) && (itemNum <= (layout.rows * layout.cols)) {
        }else{
            collectionView.contentOffset.x -= layout.sectionInset.left
        }
        print("--- \(targetIndex) \((sectionNum - 1)) \(itemNum) \(layout.rows * layout.cols)---")
    }
}

extension TGPageCollectionView : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pageCollectionView(self, didSelectItemAt: indexPath)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("decelerate \(decelerate)")
        scrollViewDidEndScroll()
    }
    
    private func scrollViewDidEndScroll(){
        /*
        guard let cell = collectionView.visibleCells.first,let indexPath = collectionView.indexPath(for: cell)  else {
            return
        }
        indexPath.item / (layout.rows * layout.cols)
        */
        let point = CGPoint(x: layout.sectionInset.left + 1 + collectionView.contentOffset.x, y: layout.sectionInset.top + 1)
        guard let indexPath = collectionView.indexPathForItem(at: point) else {
            return
        }
        print( "---\(indexPath.section)  \(point)--- ")
        if indexPath.section != currentIndex.section {
            let itemNum = dataSource?.pageCollectionView(self, numberOfItemsInSection: indexPath.section) ?? 0
            pageControl.numberOfPages = (itemNum - 1) / (layout.rows * layout.cols) + 1
            titleView.setCurrentIndex(indexPath.section)
            currentIndex = indexPath
        }
        pageControl.currentPage = indexPath.item / (layout.rows * layout.cols)
    }
}

extension TGPageCollectionView{
    func setTitles(titles : [String]){
        self.titles = titles
        titleView.setTitles(titles: titles)
    }
}
