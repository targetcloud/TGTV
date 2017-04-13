//
//  SqliteTools.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/5.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class SqliteTools: NSObject {

    static let share = SqliteTools()
    fileprivate var appdb: OpaquePointer? = nil
    fileprivate let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    private let dbQueue = DispatchQueue(label:"net.targetcloud.sqlite3")//串行
    //let concurrentQueue = DispatchQueue(label:"net.targetcloud.concurrentQueue", qos: .utility, attributes: .concurrent)//并行
    //.initiallyInactive //起初不活跃  queue.activate()来执行
    //let anotherQueue = DispatchQueue(label:"com.appcoda.anotherQueue", qos: .userInitiated, attributes: [.concurrent, .initiallyInactive])//并行 + 起初不活跃
    /*
    let additionalTime:DispatchTimeInterval = .seconds(2)
    microseconds
    milliseconds
    nanoseconds
    delayQueue.asyncAfter(deadline: .now() + additionalTime) {
    print(Date())
    }
    */ 

    func execQueueSQL(action: @escaping (_ manager: SqliteTools)->()){
        dbQueue.async() {
            print(Thread.current)
            action(self)
        }
    }
    
    class func shareInstance() ->SqliteTools {
        return share
    }
    
    private override init() {
        super.init()
        let docDir: String! = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                                  FileManager.SearchPathDomainMask.userDomainMask, true).first
        let DBPath = (docDir! as NSString).appendingPathComponent("appdb.sqlite")
        let path = DBPath.cString(using: String.Encoding.utf8)
        print(DBPath)
        if  sqlite3_open(path, &appdb) == SQLITE_OK {
            dropTable("t_focus")
            createTable("CREATE TABLE IF NOT EXISTS t_focus ( " +
                        "roomid INTEGER PRIMARY KEY, " +
                        "name TEXT, " +
                        "pic51 TEXT, " +
                        "pic74 TEXT, " +
                        "live INTEGER " +
                        ");")
        }else {
            print("open fail")
        }
    }
    
    func openDB(SQLiteName: String) -> Bool{
        let path = SQLiteName.docDir()
        print(path)
        let cPath = path.cString(using: String.Encoding.utf8)!
        return sqlite3_open(cPath, &appdb) == SQLITE_OK
    }
    
    func closeDB() -> Bool{
        return sqlite3_close(appdb) == SQLITE_OK
    }

    func querySQL(_ sqlString : String) -> [[String : Any]] {
        var stmt : OpaquePointer? = nil
        sqlite3_prepare_v2(appdb, sqlString.cString(using: String.Encoding.utf8)!, -1, &stmt, nil)
        let count = sqlite3_column_count(stmt)
        var tempArray = [[String : Any]]()
        while sqlite3_step(stmt) == SQLITE_ROW {
            var dict = [String : Any]()
            for i in 0..<count {
                let key = String(cString: sqlite3_column_name(stmt, i), encoding: String.Encoding.utf8)!
                let value = sqlite3_column_text(stmt, i)
                let valueStr = String(cString: value!)
                dict[key] = valueStr
            }
            tempArray.append(dict)
        }
        return tempArray
    }
    
    func query_Stmt(_ sql :String) ->[[String:Any]] {
        var stmt: OpaquePointer? = nil
        var queryDataArrM = [[String:Any]]()
        if sqlite3_prepare_v2(appdb, sql.cString(using: String.Encoding.utf8)!, -1, &stmt, nil) != SQLITE_OK {
            print("prepare fail")
            return queryDataArrM
        }
        let count = sqlite3_column_count(stmt)
        while sqlite3_step(stmt) == SQLITE_ROW {
            var dict = [String:Any]()
            for i in 0..<count {
                let columnName = String(cString: sqlite3_column_name(stmt, i), encoding: String.Encoding.utf8)
                let type = sqlite3_column_type(stmt, i)
                if type == SQLITE_INTEGER {
                    let value = sqlite3_column_int(stmt, i)//int64
                    dict[columnName!] = value
                    print(columnName!,value)
                }
                if type == SQLITE_FLOAT {
                    let value = sqlite3_column_double(stmt, i)
                    dict[columnName!] = value
                    print(columnName!,value)
                }
                if type == SQLITE_TEXT {
                    let value =  String(cString:sqlite3_column_text(stmt, i)!)
                    let valueStr = String(cString: value, encoding: String.Encoding.utf8)
                    dict[columnName!] = valueStr
                    print(columnName!,valueStr!)
                }
                if type == SQLITE_NULL{
                    dict[columnName!] =  NSNull()
                }
            }
            queryDataArrM.append(dict)
        }
        sqlite3_finalize(stmt)
        return queryDataArrM
    }
    
    func query(_ sql :String) {
        //外层参数共5个: 一个打开的数据库、需要执行的SQL语句、查询结果回调(执行0次或多次)、回调函数的第一个值、错误信息
        let result = sqlite3_exec(appdb, sql, { (
            firstValue, columnCount, values , columnNames ) -> Int32 in // 闭包参数共4个: 外层的第4个参数的值、列的个数、结果值的数组、所有列的名称数组。返回值: 0代表继续执行一直到结束, 1代表执行一次
            let count = Int(columnCount)
            for i in 0..<count {
                let column = columnNames?[i]
                let columnNameStr = String(cString: column!, encoding: String.Encoding.utf8)//(columnNames?[i]!)!
                let value = values?[i]
                let valueStr = String(cString: value!, encoding: String.Encoding.utf8)//(values?[i]!)!
                print(columnNameStr! + "=" + valueStr!)
            }
            return 0//0代表继续执行一直到结束, 1代表执行一次
        }, nil, nil)
        if result == SQLITE_OK {
            print("all query ok")
        }else {
            print("all query fail")
        }
    }
    
    //建表
    @discardableResult
    fileprivate func createTable(_ sql: String) ->Bool {
        return execSQL(sql)
    }
    
    //删表
    @discardableResult
    fileprivate func dropTable(_ tableName: String) ->Bool {
        let sql = "drop table if exists "+tableName
        return execSQL(sql)
    }
    
    //普通更新
    func updateRecord(_ table: String, setStr: String, condition: String?) -> Bool {
        let whereCondition = (condition == nil) ? ("") : ("where \(condition!)")
        let sql = "update \(table) set \(setStr) \(whereCondition)"
        return execSQL(sql)
    }
    
    //普通INSERT
    func insert(_ tableName: String, columnNameArray: [String], values: CVarArg...) -> Bool {
        return insert(tableName, columnNameArray: columnNameArray, valueArray:values)
    }
    
    //普通INSERT
    func insert(_ tableName: String, columnNameArray: [String], valueArray: [Any]) -> Bool {
        if columnNameArray.count != valueArray.count{
            return false
        }
        let tempColumnNameArray = columnNameArray as NSArray
        let columnNames = tempColumnNameArray.componentsJoined(by: ",")
        let tempValueArray = valueArray as NSArray
        let values = tempValueArray.componentsJoined(by: "\',\'")
        let sql = "INSERT INTO \(tableName)(\(columnNames)) values (\'\(values)\')"
        return execSQL(sql)
    }
    
    func batchExecSQL(sql:String, args: CVarArg...) -> Bool{
        let cSQL = sql.cString(using: String.Encoding.utf8)!
        var stmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(appdb, cSQL, -1, &stmt, nil) != SQLITE_OK{
            print("prepare fail")
            sqlite3_finalize(stmt)
            return false
        }
        var index:Int32 = 1
        for objc in args{
            if objc is Int{
                sqlite3_bind_int64(stmt, index, sqlite3_int64(objc as! Int))
            }else if objc is Double{
                sqlite3_bind_double(stmt, index, objc as! Double)
            }else if objc is Float{
                sqlite3_bind_double(stmt, index, Double(objc as! Float))
            }else if objc is String{
                let text = objc as! String
                let cText = text.cString(using: String.Encoding.utf8)!
                sqlite3_bind_text(stmt, index, cText, -1, SQLITE_TRANSIENT)
            }
            index += 1
        }
        if sqlite3_step(stmt) != SQLITE_DONE{
            print("setp fail")
            return false
        }
        if sqlite3_reset(stmt) != SQLITE_OK{
            print("reset fail")
            return false
        }
        sqlite3_finalize(stmt)
        return true
    }

    
    //批量INSERT
    func insertBatch(_ tableName: String, columnNameArray: [String], valuesBlock: () -> Array<Array<Any>>){
        guard let stmt: OpaquePointer = getPrepareStmt(tableName, columnNameArray: columnNameArray) else { return}
        beginTransaction()
        for array in valuesBlock(){
            insertBind(stmt, values: array)
            resetStmt(stmt)
        }
        commitTransaction()
        releaseStmt(stmt)
    }
    
    func execSqls(_ sqlarr : [String]) -> Bool {
        for item in sqlarr {
            if execSQL(item) == false {
                return false
            }
        }
        return true
    }
    
    @discardableResult
    func execSQL(_ sql : String) -> Bool {
        let errmsg : UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>? = nil
        let cSQLString = sql.cString(using: String.Encoding.utf8)!
        if sqlite3_exec(appdb, cSQLString, nil, nil, errmsg) == SQLITE_OK {
            return true
        }else{
            print("error \(String(describing: errmsg))")
            return false
        }
    }
    
    //开启事务
    @discardableResult
    func beginTransaction() -> Bool{
        let sql = "begin transaction"
        return execSQL(sql)
    }
    
    //提交事务
    @discardableResult
    func commitTransaction() -> Bool{
        let sql = "commit transaction"
        return execSQL(sql)
    }
    
    //回滚事务
    @discardableResult
    func rollbackTransaction() -> Bool{
        let sql = "rollback transaction"
        return execSQL(sql)
    }
}

extension SqliteTools{//批量INSERT
    //得到INSERT Stmt
    fileprivate func getPrepareStmt(_ tableName: String, columnNameArray: [String]) -> OpaquePointer? {
        let tempColumnNameArray = columnNameArray as NSArray
        let columnNames = tempColumnNameArray.componentsJoined(by: ",")
        var tempValues: Array = [String]()
        for _ in 0 ..< columnNameArray.count{
            tempValues.append("?")
        }
        let valuesStr = (tempValues as NSArray).componentsJoined(by: ",")
        let prepareSql = "INSERT INTO \(tableName)(\(columnNames)) values (\(valuesStr))"
        var stmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(appdb, prepareSql, -1, &stmt, nil) != SQLITE_OK{
            print("prepare fail")
            sqlite3_finalize(stmt)
            return nil
        }
        return stmt!
    }
    
    //step Stmt
    @discardableResult
    fileprivate func insertBind(_ stmt: OpaquePointer, values: [Any]) -> Bool  {
        var index: Int32 = 1
        for obj in values{
            if obj is Int{
                sqlite3_bind_int(stmt, index, Int32(obj as! Int))
                //sqlite3_bind_int64(stmt, index, sqlite3_int64(obj as! Int))
            } else if obj is Double{
                sqlite3_bind_double(stmt, index, obj as! Double)
            } else if obj is Float{
                sqlite3_bind_double(stmt, index, Double(obj as! Float))
            }else if obj is String{
                sqlite3_bind_text(stmt, index, obj as! String, -1, SQLITE_TRANSIENT)
            }else {
                continue
            }
            index += 1
        }
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    //重置Stmt
    @discardableResult
    fileprivate func resetStmt(_ stmt: OpaquePointer) -> Bool {
        return sqlite3_reset(stmt) == SQLITE_OK
    }
    
    //释放Stmt
    fileprivate func releaseStmt(_ stmt: OpaquePointer) {
        sqlite3_finalize(stmt)
    }

}
