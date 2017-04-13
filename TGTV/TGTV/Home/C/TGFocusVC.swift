//
//  TGFocusVC.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/10.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit
private let kFucusCellID = "kFocusCellID"

class TGFocusVC: UITableViewController {

    fileprivate lazy var focusVM : TGFocusVM = TGFocusVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        loadFocusData()
    }

    fileprivate func setupUI() {
        title = "我的关注"
        navigationController?.navigationBar.tintColor = UIColor.white
        tableView.register(UINib(nibName: "TGFocusViewCell", bundle: nil), forCellReuseIdentifier: kFucusCellID)
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    fileprivate func loadFocusData() {
        focusVM.loadFocusData {
            self.tableView.reloadData()
        }
    }

}

extension TGFocusVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return focusVM.anchorMs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kFucusCellID, for: indexPath) as! TGFocusViewCell
        cell.anchorM = focusVM.anchorMs[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let roomVc = TGRoomVC()
        roomVc.anchor = focusVM.anchorMs[indexPath.row]
        navigationController?.pushViewController(roomVc, animated: true)
    }
}
