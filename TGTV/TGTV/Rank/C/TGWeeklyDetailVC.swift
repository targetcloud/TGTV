//
//  TGWeeklyDetailVC.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/9.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

private let kWeeklyRankeCellID = "kWeeklyRankeCellID"

class TGWeeklyDetailVC: UIViewController {

    var rankType: TGRankType

    fileprivate lazy var weeklyRankVM : TGWeeklyRankVM = TGWeeklyRankVM()
    
    fileprivate lazy  var tableV: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor(colorLiteralRed: 245, green: 245, blue: 245, alpha: 1.0)
        tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 50
        tableView.register(UINib(nibName: "TGWeeklyRankCell", bundle: nil), forCellReuseIdentifier: kWeeklyRankeCellID)
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
    
    fileprivate func loadData() {
        weeklyRankVM.loadWeeklyRankData(rankType) {
            self.tableV.reloadData()
        }
    }
    
    fileprivate func setupUI() {
        view.addSubview(tableV)
        tableV.frame = view.bounds
        tableV.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}

extension TGWeeklyDetailVC: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return weeklyRankVM.weeklyRankMs.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyRankVM.weeklyRankMs[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kWeeklyRankeCellID, for: indexPath) as! TGWeeklyRankCell
        cell.weeklyM = weeklyRankVM.weeklyRankMs[indexPath.section][indexPath.row]
        return cell
    }
    
    
}
