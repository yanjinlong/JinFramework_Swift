//
//  DBHelper.swift
//  JinFramework_Swift
//
//  Created by 严锦龙 on 2017/12/20.
//  Copyright © 2017年 Jin. All rights reserved.
//

import UIKit

/// 数据库帮助类
class DBHelper: NSObject {
    //MARK: - 创建类的静态实例变量即为单例对象 let-是线程安全的
    fileprivate static let instance = DBHelper()
    //对外提供创建单例对象的接口
    class func shareInstance() -> DBHelper {
        return instance
    }
    
    //定义数据库变量
    var db : OpaquePointer? = nil
    
    //打开数据库
    func openDB() -> Bool {
        //数据库文件路径
        let dicumentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let DBPath = (dicumentPath! as NSString).appendingPathComponent("JinFramework_Swift/database.db")
        let cDBPath = DBPath.cString(using: String.Encoding.utf8)
        //打开数据库
        //第一个参数:数据库文件路径  第二个参数:数据库对象\
        if sqlite3_open(cDBPath, &db) != SQLITE_OK {
            print("数据库打开失败")
            return false
        }
        
        return true
    }
    
    //创建表
    func creatTable() -> Bool {
        //建表的SQL语句
        let creatUserTable = "CREATE TABLE IF NOT EXISTS 't_User' ( 'ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'name' TEXT,'age' INTEGER,'icon' TEXT);"
        let creatCarTable = "CREATE TABLE IF NOT EXISTS 't_Car' ('ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'type' TEXT,'output' REAL,'master' TEXT);"
        //执行SQL语句-创建表 依然,项目中一般不会只有一个表
        return creatTableExecSQL(SQL_ARR: [creatUserTable,creatCarTable])
    }
    
    //执行建表SQL语句
    func creatTableExecSQL(SQL_ARR : [String]) -> Bool {
        for item in SQL_ARR {
            if execSQL(SQL: item) == false {
                return false
            }
        }
        
        return true
    }
    
    //执行SQL语句
    func execSQL(SQL : String) -> Bool {
        // 1.将sql语句转成c语言字符串
        let cSQL = SQL.cString(using: String.Encoding.utf8)
        //错误信息
        let errmsg : UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>? = nil
        
        if sqlite3_exec(db, cSQL, nil, nil, errmsg) == SQLITE_OK {
            return true
        } else {
            print("SQL 语句执行出错 -> 错误信息: 一般是SQL语句写错了 \(errmsg!)")
            return false
        }
    }
    
    //查询数据库中数据
    func queryDBData(querySQL: String) -> [[String : AnyObject]]? {
        //定义游标对象
        var stmt : OpaquePointer? = nil
        
        //将需要查询的SQL语句转化为C语言
        if querySQL.lengthOfBytes(using: String.Encoding.utf8) > 0 {
            let cQuerySQL = (querySQL.cString(using: String.Encoding.utf8))!
            //进行查询前准备操作
            // 1> 参数一:数据库对象
            // 2> 参数二:查询语句
            // 3> 参数三:查询语句的长度:-1
            // 4> 参数四:句柄(游标对象)
            
            if sqlite3_prepare_v2(db, cQuerySQL, -1, &stmt, nil) == SQLITE_OK {
                //准备好之后进行解析
                var queryDataArrM = [[String : AnyObject]]()
                while sqlite3_step(stmt) == SQLITE_ROW {
                    //1.获取 解析到的列(字段个数)
                    let columnCount = sqlite3_column_count(stmt)
                    
                    //2.遍历某行数据
                    var dict = [String : AnyObject]()
                    
                    for i in 0..<columnCount {
                        // 取出i位置列的字段名,作为字典的键key
                        let cKey = sqlite3_column_name(stmt, i)
                        let key : String = String(validatingUTF8: cKey!)!
                        
                        //取出i位置存储的值,作为字典的值value
                        let cValue = sqlite3_column_text(stmt, i)
                        let value =  String(cString:cValue!)
                        dict[key] = value as AnyObject
                    }
                    
                    queryDataArrM.append(dict)
                }
                
                return queryDataArrM
            }
        }
        
        return nil
    }
}
