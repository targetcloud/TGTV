//
//  TGHomeVC.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/8.
//  Copyright © 2017年 targetcloud. All rights reserved.
//http://blog.csdn.net/callzjy/article/details/70160050

import UIKit

class TGHomeVC: TGBaseVC {
    fileprivate lazy var searchBar : UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        searchBar.placeholder = "主播昵称/房间号/链接"
        searchBar.searchBarStyle = .minimal
        let searchFiled = searchBar.value(forKey: "_searchField") as? UITextField
        searchFiled?.textColor = UIColor.lightText
        searchFiled?.tintColor = searchFiled?.textColor
        searchFiled?.resignFirstResponder()
        return searchBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    fileprivate func setupUI(){
        setupNav()
        setupContentView()
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    private func setupContentView() {
        let homeTypes = loadTypesData()
        let titles = homeTypes.map({$0.title})
        let style = TGPageStyle()
        style.isScrollEnable = true
        style.isShowCoverView = true
        style.normalColor = UIColor.darkGray
        style.selectColor = UIColor.orange
        style.coverBgColor = UIColor.lightGray
        
        let pageFrame = CGRect(x: 0, y: kNavigationBarH + kStatusBarH, width: kScreenW, height: kScreenH - kNavigationBarH - kStatusBarH - kTabBarH)
        var childVCs = [TGAnchorVC]()
        for type in homeTypes {
            let anchorVC = TGAnchorVC()
            anchorVC.homeType = type
            childVCs.append(anchorVC)
        }
        let scrollView = TGPageView(frame: pageFrame, titles: titles, titleStyle: style, childVCs: childVCs, parentVC: self)
        view.addSubview(scrollView)
    }
    
    private func loadTypesData() ->[TGHomeStyle] {
        let path = Bundle.main.path(forResource: "types.plist", ofType: nil)
        let dataArr = NSArray(contentsOfFile: path!) as? [[String: Any]] ?? []
        var tempArr = [TGHomeStyle]()
        for dict in dataArr {
            tempArr.append(TGHomeStyle(dict:dict))
        }
        return tempArr
    }
    
    private func setupNav(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "logo"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search_btn_follow"), style: .plain, target: self, action: #selector(didClickRightItem))
        navigationItem.titleView = searchBar
        navigationController?.navigationBar.barTintColor = UIColor.lightGray
    }
    
    @objc fileprivate func didClickRightItem() {
        navigationController?.pushViewController(TGFocusVC(), animated: true)
    }

}
