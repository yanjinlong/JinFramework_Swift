//
//  TableItemModel.swift
//  JinBLETest
//
//  Created by 严锦龙 on 2017/8/17.
//  Copyright © 2017年 严锦龙. All rights reserved.
//

import UIKit

/// 行item（常用）
class TableRowItem: NSObject {
    /// 图标
    var icon: UIImage?
    
    /// 文本
    var text: String?
    
    /// 关键code
    var code: String?
    
    /// 不常用，则在初始化不给予构造函数赋值
    var desc: String?
    
    init(icon: String?, text: String?, code: String?) {
        self.code = code
        
        if (icon != nil) {
            self.icon = UIImage(named: icon!)
        }
        
        self.text = text
    }
}

/// 组item（配合行item使用）
class TableSectionItem: NSObject {
    /// 头部的item
    var sectionItem: TableRowItem?
    
    /// 子的item数组
    var rowItemArray: NSMutableArray?
}
