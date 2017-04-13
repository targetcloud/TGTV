//
//  TGDiscoverVC.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/8.
//  Copyright © 2017年 targetcloud. All rights reserved.
//http://blog.csdn.net/callzjy/article/details/70160050

import UIKit
import SDCycleScrollView

private let kDiscoverID = "KDiscoverID"

class TGDiscoverVC: TGBaseVC {

    fileprivate lazy var bannerVM: TGBannerVM = TGBannerVM()
    fileprivate lazy var tableV: UITableView = UITableView()
    fileprivate lazy var headerV : UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: -kScreenW * 0.4, width: kScreenW, height: kScreenW * 0.4))
        headerView.addSubview(self.scrollV)
        return headerView
    }()
    
    fileprivate lazy var scrollV : UIScrollView = {
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenW * 0.4)
        let scrollView = UIScrollView(frame: rect)
        scrollView.contentSize = CGSize(width: kScreenW, height: kScreenW * 0.4)
        scrollView.addSubview(self.bannerV)
        return scrollView
    }()
    
    fileprivate lazy var bannerV : SDCycleScrollView = {
        let bannerView = SDCycleScrollView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenW * 0.4), delegate: self, placeholderImage: nil)
        bannerView?.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        bannerView?.pageDotColor = UIColor(white: 1.0, alpha: 0.5)
        bannerView?.currentPageDotColor = UIColor.orange
        return bannerView!
    }()
    
    fileprivate lazy var footerV: UIView = {
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: 80)
        let footerView = UIView(frame: rect)
        footerView.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        let btn = UIButton(type: UIButtonType.custom)
        btn.frame.size = CGSize(width: kScreenW * 0.5, height: footerView.size.height * 0.5)
        btn.center = CGPoint(x: kScreenW * 0.5, y: footerView.size.height * 0.5)
        btn.setTitle("换一下", for: .normal)
        btn.setTitleColor(UIColor.orange, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = UIColor.orange.cgColor
        btn.layer.borderWidth = 0.5
        btn.addTarget(self, action: #selector(switchGuessAnchor), for: .touchUpInside)
        footerView.addSubview(btn)
        return footerView
    }()
    
    fileprivate lazy var sectionHeaderV: UIView = {
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 30))
        sectionHeaderView.backgroundColor = UIColor.white
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 30))
        headerLabel.text = " --- 猜你喜欢 --- "
        headerLabel.font = UIFont.systemFont(ofSize: 14)
        headerLabel.textAlignment = .center
        headerLabel.textColor = UIColor.orange
        headerLabel.center = CGPoint(x: kScreenW * 0.5, y: sectionHeaderView.size.height * 0.5)
        sectionHeaderView.addSubview(headerLabel)
        return sectionHeaderView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bannerVM.loadCarouselData {
            self.bannerV.imageURLStringsGroup = self.bannerVM.banners
            self.tableV.reloadData()
        }
    }
    
    @objc fileprivate func switchGuessAnchor() {
        let cell = tableV.visibleCells.first as? TGDiscoverCell
        cell?.reloadData()
        let offset = CGPoint(x: 0, y: kScreenW * 0.4 - 64)
        tableV.setContentOffset(offset, animated: true)
    }
    
    fileprivate func setupUI() {
        tableV.frame = view.bounds
        tableV.dataSource = self
        tableV.delegate = self
        tableV.tableHeaderView = headerV
        tableV.tableFooterView = footerV
        tableV.rowHeight = kScreenW * 1.3
        view.addSubview(tableV)
        tableV.register(UINib(nibName: "TGDiscoverCell", bundle: nil) , forCellReuseIdentifier: kDiscoverID)
    }
}

extension TGDiscoverVC:SDCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        //print(index)
        let bannerVC = TGBannerVC()
        bannerVC.urlString = self.bannerVM.links[index]
        bannerVC.titleString = self.bannerVM.names[index]
        navigationController?.pushViewController(bannerVC, animated: true)
    }
}

extension TGDiscoverVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kDiscoverID, for: indexPath) as! TGDiscoverCell
        cell.cellDidSelected = { (anchor : TGAnchorM) in
            let liveVc = TGRoomVC()
            liveVc.anchor = anchor
            self.navigationController?.pushViewController(liveVc, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionHeaderV
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}
