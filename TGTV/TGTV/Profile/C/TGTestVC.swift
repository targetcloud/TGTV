//
//  TGTestVC.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/8.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGTestVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.random()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", style: .plain, target: self, action: #selector(nextVC))
    }

    @objc private func nextVC(){
        navigationController?.pushViewController(TGTestVC(), animated: true)
    }

}
