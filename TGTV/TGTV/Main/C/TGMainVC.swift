//
//  TGMainVC.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/8.
//  Copyright © 2017年 targetcloud. All rights reserved.
//http://blog.csdn.net/callzjy/article/details/70160050

import UIKit

class TGMainVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        setupUI()
    }

    fileprivate func setupUI() {
        var arrayM = [UIViewController]()
        let array = [
            ["clsName": "TGHomeVC", "title": "直播", "imageName": "Living"],
            ["clsName": "TGRankVC", "title": "排行", "imageName": "Focus"],
            ["clsName": "TGDiscoverVC", "title": "发现", "imageName": "Discovery"],
            ["clsName": "TGProfileVC", "title": "我的", "imageName": "Mine"],
            ]
        for dict in array {
            arrayM.append(setupViewControllers(dict as [String : Any]))
        }
        viewControllers = arrayM
    }
    
    private func setupViewControllers(_ dict:[String : Any]) -> UIViewController {
        guard let clsName = dict["clsName"] as? String,let title = dict["title"] as? String,let imageName = dict["imageName"] as? String,
            let cls = NSClassFromString(Bundle.main.nameSpace + "." + clsName) as? TGBaseVC.Type
            else {
                return UIViewController()
        }
        let vc = cls.init()
        vc.title = title
        vc.tabBarItem.image = UIImage(named: "tab" + imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tab" + imageName + "HL")?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(r: 217, g: 165, b: 69)], for: .selected)
        vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12)], for: .normal)
        let nav = TGNavVC(rootViewController: vc)
        return nav
    }
}
