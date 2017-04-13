//
//  TGSettingVC.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/8.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

private let kSettingCellID = "kSettingCellID"

private let kRemind = "开播提醒"
private let kTrafficRemind = "移动流量提醒"
private let kNetwork = "网络环境优化"
private let kMob = "绑定手机"
private let kLive = "直播公约"
private let kAboutus = "关于我们"
private let kPraise = "我要好评"

class TGSettingVC: TGBaseVC {

    fileprivate lazy var titleArr:[[String]] = {
        return [[kRemind, kTrafficRemind, kNetwork],
                [kMob, kLive, kAboutus, kPraise]]
    }()
    
    fileprivate lazy var tableV : UITableView = {
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: self.view.height)
        let tableView = UITableView(frame: rect, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        view.backgroundColor = UIColor.white
        view.addSubview(tableV)
        tableV.register(UITableViewCell.self, forCellReuseIdentifier: kSettingCellID)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension TGSettingVC: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kSettingCellID, for: indexPath)
        let subTitle = titleArr[indexPath.section]
        cell.textLabel?.text = subTitle[indexPath.row]
        cell.textLabel?.textColor = UIColor.darkGray
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(TGTestVC(), animated: true)
    }
}

