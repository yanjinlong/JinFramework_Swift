//
//  LectionModel.swift
//  JinFramework_Swift
//
//  Created by 严锦龙 on 2017/12/20.
//  Copyright © 2017年 Jin. All rights reserved.
//

import UIKit

/// 经文的实体类
class LectionModel: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.lection_id, forKey: "lection_id")
        aCoder.encode(self.lection_name, forKey: "lection_name")
        aCoder.encode(self.lection_pic, forKey: "lection_pic")
        aCoder.encode(self.lection_content, forKey: "lection_content")
//        aCoder.encode(self.lection_merits, forKey: "lection_merits")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.lection_id = aDecoder.decodeInteger(forKey: "lection_id")
        self.lection_name = aDecoder.decodeObject(forKey: "lection_name") as! String
        self.lection_pic = aDecoder.decodeObject(forKey: "lection_pic") as! String
        self.lection_content = aDecoder.decodeObject(forKey: "lection_content") as? String
//        self.lection_merits = aDecoder.decodeObject(forKey: "lection_merits") as! String
    }
    
    override init() {
        super.init()
    }
    
    init(withDict dict: NSDictionary) {
        super.init()
        
        self.lection_id = Int(dict["lection_id"] as! String)!
        self.lection_name = dict["lection_name"] as! String
        self.lection_pic = dict["lection_pic"] as! String
        self.lection_content = dict["lection_content"] as? String
    }
    
    /// 经文id
    var lection_id: Int = 0
    
    /// 经文名称
    var lection_name: String = ""
    
    /// 经文图片
    var lection_pic: String = ""
    
    /// 经文内容
    var lection_content: String? = ""
//
//    /// 功德/利益
//    var lection_merits: String = ""
}
