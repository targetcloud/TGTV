//
//  TGChatContentV.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/12.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit
private let kChatContentViewID = "kChatContentViewID"

class TGChatContentV: UIView ,TGNibLoadable{

    @IBOutlet weak var tableV: UITableView!
    fileprivate lazy var messages: [NSAttributedString] = [NSAttributedString]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableV.register(UINib(nibName: "TGChatContentViewCell", bundle: nil), forCellReuseIdentifier: kChatContentViewID)
        tableV.dataSource = self
        tableV.separatorStyle = .none
        tableV.showsHorizontalScrollIndicator = false
        tableV.showsVerticalScrollIndicator = false
        tableV.estimatedRowHeight = 44
        tableV.rowHeight = UITableViewAutomaticDimension
    }
    
    func insertMessage(_ message : NSAttributedString) {
        messages.append(message)
        tableV.reloadData()
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableV.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

extension TGChatContentV: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kChatContentViewID, for: indexPath) as! TGChatContentViewCell
        cell.contentLbl.attributedText = messages[indexPath.row]
        return cell
    }
}
