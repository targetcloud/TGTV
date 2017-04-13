//
//  TGAnchorM.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/9.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGAnchorM: TGBaseM {
    var roomid : Int = 0
    var name : String = ""
    var pic51 : String = ""
    var pic74 : String = ""
    var live : Int = 0
    var push : Int = 0
    var focus : Int = 0
    var uid : String = ""
    var isEvenIndex : Bool = false
}

extension TGAnchorM {
    func inserIntoDB() {
        let insertSQL = "INSERT INTO t_focus (roomid, name, pic51, pic74, live) VALUES (\(roomid), '\(name)', '\(pic51)', '\(pic74)', \(live));"
        if SqliteTools.share.execSQL(insertSQL) {
            print("插入成功")
        } else {
            print("插入失败")
        }
    }
    
    func deleteFromDB() {
        let deleteSQL = "DELETE FROM t_focus WHERE roomid = \(roomid);"
        if SqliteTools.share.execSQL(deleteSQL) {
            print("删除成功")
        } else {
            print("删除失败")
        }
    }
}
