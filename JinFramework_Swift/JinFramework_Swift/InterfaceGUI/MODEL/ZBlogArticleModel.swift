//
//  ZBlogArticleModel.swift
//  JinFramework_Swift
//
//  Created by 严锦龙 on 2017/12/22.
//  Copyright © 2017年 Jin. All rights reserved.
//

import UIKit

class ZBlogArticleModel: HandyJSON {
    
    /// 文章id
    var id: String = ""
    
    /// 文章标题
    var title: String = ""
 
    /// 图片
    var cover: String = ""
    
    /// 内容
    var content: String? = ""
    
    required init() {
        
    }
}
