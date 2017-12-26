//
//  ZBlogArticleModelOC.h
//  JinFramework_Swift
//
//  Created by 严锦龙 on 2017/12/25.
//  Copyright © 2017年 Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBlogArticleModelOC : NSObject
/// 文章id
@property (nonatomic, copy) NSString *id;

/// 文章标题
@property (nonatomic, copy) NSString *title;

/// 图片
@property (nonatomic, copy) NSString *cover;

/// 内容
@property (nonatomic, copy) NSString *content;
@end
