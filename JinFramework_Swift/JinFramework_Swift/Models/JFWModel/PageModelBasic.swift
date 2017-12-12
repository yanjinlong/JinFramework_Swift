//
//  PageModelBasic.swift
//  JinFramework_Swift
//
//  Created by 严锦龙 on 2017/11/28.
//  Copyright © 2017年 Jin. All rights reserved.
//

import UIKit

/// 分页实体类
class PageModelBasic: NSObject {
    
    /// 每页数量多少条
    var pageSize: Int = 10
    
    /// 当前第几页
    var pageIndex: Int = 0
    
    /// 总共多少页
    var totalPage: Int = 0
    
    /// 总共多少条数据
    var totalSize: Int = 0
    
    /// 数据实体
    var dataArray: [Any]!
    
    override init() {
        super.init()
        
        // 帮忙初始化数组
        self.dataArray = [Any]()
    }
    
    /// 拷贝信息除了dataArray属性
    ///
    /// - Parameter otherModel: 另外一个实体对象
    func copyInfoButDataArrayTo(otherModel: PageModelBasic) {
        otherModel.pageIndex = self.pageIndex
        otherModel.pageSize = self.pageSize
        otherModel.totalPage = self.totalPage
        otherModel.totalSize = self.totalSize
    }
}
