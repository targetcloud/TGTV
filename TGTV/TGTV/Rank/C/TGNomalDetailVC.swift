//
//  TGNomalDetailVC.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/9.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit
private let kDetailCellId = "kDetailCellId"

class TGNomalDetailVC: UIViewController {

    var rankType: TGRankType
    
    fileprivate lazy var detailRankVM: TGRankVM = TGRankVM()
    
    fileprivate lazy  var tableV: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor(colorLiteralRed: 245, green: 245, blue: 245, alpha: 1.0)
        tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 50
        tableView.register(UINib(nibName: "TGRankCell", bundle: nil), forCellReuseIdentifier: kDetailCellId)
        return tableView
    }()
    
    init(rankType: TGRankType) {
        self.rankType = rankType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadData()
    }
    
    func loadData() {
        detailRankVM.loadDetailRankData(rankType) {
            self.tableV.reloadData()
        }
    }
    
    fileprivate func setupUI() {
        view.addSubview(tableV)
        tableV.frame = view.bounds
        tableV.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}

extension TGNomalDetailVC: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailRankVM.rankMs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kDetailCellId, for: indexPath) as! TGRankCell
        cell.rankM = detailRankVM.rankMs[indexPath.row]
        cell.rankNum = indexPath.row
        return cell
    }
}
