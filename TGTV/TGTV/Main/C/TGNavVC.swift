//
//  TGNavVC.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/8.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGNavVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPopGester()
        setupAppearanceAtr()
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigationbar_back_withtext"), style: .plain, target: self, action: #selector(popToParent))
        }
        super.pushViewController(viewController, animated: true)
    }

    @objc fileprivate func popToParent() {
        popViewController(animated: true)
    }
    
    fileprivate func setupAppearanceAtr() {
        UINavigationBar.appearance().tintColor = UIColor(hex: "0x333333")
        let attributes = [
            NSForegroundColorAttributeName : UIColor(hex: "0x333333"),
            NSFontAttributeName: UIFont.systemFont(ofSize: 18)
        ]
        UINavigationBar.appearance().titleTextAttributes = attributes
    }
    
    fileprivate func setupPopGester() {
        guard let targets = interactivePopGestureRecognizer!.value(forKey:  "_targets") as? [NSObject],let targetObjc = targets.first,let target = targetObjc.value(forKey: "target") else { return }
        view.addGestureRecognizer(UIPanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition:"))))
 
        /*
        guard let targets = interactivePopGestureRecognizer?.value(forKey: "_targets") as? [NSObject],let targetObjc = targets.first,let target = targetObjc.value(forKey: "target"),let gesView = interactivePopGestureRecognizer?.view else { return }
        gesView.addGestureRecognizer(UIPanGestureRecognizer(target:target, action: Selector(("handleNavigationTransition:"))))
        */
        
    }
}
