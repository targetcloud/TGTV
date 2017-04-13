//
//  TGProfileVC.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/8.
//  Copyright © 2017年 targetcloud. All rights reserved.
//http://blog.csdn.net/callzjy/article/details/70160050

import UIKit

private let kProfileCellID = "kProfileCellID"
private let kHeaderViewH: CGFloat = 252
private let kFreeTraficURL = "http://hybrid.ximalaya.com/api/telecom/index?app=iting&device=iPhone&impl=com.gemd.iting&telephone=%28null%29&version=5.4.27"
private let kMeSubScribe   = "我的订阅"
private let kMePlayHistory = "播放历史"
private let kMeHasBuy      = "我的已购"
private let kMeWallet      = "我的钱包"
private let kMeStore       = "直播商城"
private let kMeStoreOrder  = "我的商城订单"
private let kMeCoupon      = "我的优惠券"
private let kMeGameenter   = "游戏中心"
private let kMeSmartDevice = "智能硬件设备"
private let kMeFreeTrafic  = "免流量服务"
private let kMeFeedBack    = "意见反馈"
private let kEditMyInfo    = "编辑资料"
private let kMeSetting     = "设置"

class TGProfileVC: TGBaseVC {

    var lightFlag: Bool = true
    fileprivate lazy var titleArr:[[String]] = {
        return [[kMeSubScribe, kMePlayHistory],
                [kMeHasBuy, kMeWallet],
                [kMeStore, kMeStoreOrder, kMeCoupon, kMeGameenter, kMeSmartDevice],
                [kMeFreeTrafic, kMeFeedBack, kEditMyInfo, kMeSetting]]
    }()
    lazy var imageArr:[[String]] = {
        return [["mine_follow", "mine_money"],
                ["mine_fanbao", "mine_bag"],
                ["mine_money", "mine_money", "mine_bag", "mine_fanbao", "mine_follow"],
                ["mine_fanbao", "mine_bag", "mine_edit","mine_set"]]
    }()
    
    fileprivate lazy var headerV : TGProfileHeaderV = {
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: kHeaderViewH)
        let headerView = TGProfileHeaderV(frame: rect)
        return headerView
    }()
    fileprivate lazy var tableV : UITableView = {
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: self.view.height - 49)
        let tableView = UITableView(frame: rect, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kHeaderViewH))
        tableView.addSubview(self.headerV)
        return tableView
    }()
    
    fileprivate lazy var statusV: UIView = { [unowned self] in
        let v = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 20))
        v.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        self.view.addSubview(v)
        self.view.bringSubview(toFront: v)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(tableV)
        tableV.rowHeight = 44.0
        tableV.register(UITableViewCell.self, forCellReuseIdentifier: kProfileCellID)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return lightFlag ? .lightContent : .default
    }

}

extension TGProfileVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let subTitleArr = titleArr[indexPath.section]
        let subImageArr = imageArr[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: kProfileCellID, for: indexPath)
        cell.textLabel?.text = subTitleArr[indexPath.row]
        cell.textLabel?.textColor = UIColor.darkGray
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: subImageArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        guard let title = cell?.textLabel?.text else {
            return
        }
        if title == kMeFreeTrafic {
            jump2FreeTraficService()
        }else if title == kMeSetting { 
            jump2SettingVC()
        }
    }
    
    fileprivate func jump2FreeTraficService() {
        let serviceVC = TGBannerVC()
        serviceVC.urlString = kFreeTraficURL
        serviceVC.titleString = "免流量包"
        serviceVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(serviceVC, animated: true)
    }
    
    fileprivate func jump2SettingVC() {
        let settingVc = TGSettingVC()
        settingVc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(settingVc, animated: true)
    }
    
}

extension TGProfileVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        print("offsetY->\(offsetY) kScreenW->\(kScreenW) width->\(kScreenW - offsetY) kHeaderViewH->\(kHeaderViewH) height->\(kHeaderViewH - offsetY)")
        if offsetY <= 0 {
            headerV.frame = CGRect(x: offsetY * 0.5, y: offsetY, width: kScreenW - offsetY, height: kHeaderViewH - offsetY)
        }
        
        if offsetY < 200.0 {
            statusV.alpha = 0.0
            setStatusBarStyle(isLight: true)
        } else if offsetY >= 200 && offsetY < 220 {
            let alpha: CGFloat = (offsetY - 200) / 20.0
            view.bringSubview(toFront: statusV)
            statusV.alpha = alpha
        } else {
            statusV.alpha = 1.0
            view.bringSubview(toFront: statusV)
            setStatusBarStyle(isLight: false)
        }
    }
    
    func setStatusBarStyle(isLight: Bool) {
        if isLight && lightFlag == false {
            lightFlag = true
            setNeedsStatusBarAppearanceUpdate()
        } else if !isLight && lightFlag == true {
            lightFlag = false
            setNeedsStatusBarAppearanceUpdate()
        }
    }
}


