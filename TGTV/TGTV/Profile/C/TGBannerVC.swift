//
//  TGBannerVC.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/8.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGBannerVC: UIViewController {

    fileprivate lazy var webView : UIWebView = UIWebView()
    var urlString : String?
    var titleString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = (titleString ?? "")
        webView.frame = view.bounds
        webView.backgroundColor = UIColor.white
        view.addSubview(webView)
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    fileprivate func loadData() {
        guard let url = URL(string: urlString!) else {
            return
        }
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }
}
