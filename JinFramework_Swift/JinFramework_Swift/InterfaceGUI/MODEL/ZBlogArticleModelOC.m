//
//  ZBlogArticleModelOC.m
//  JinFramework_Swift
//
//  Created by 严锦龙 on 2017/12/25.
//  Copyright © 2017年 Jin. All rights reserved.
//

#import "ZBlogArticleModelOC.h"

@implementation ZBlogArticleModelOC

- (NSString *)description {
    return [NSString stringWithFormat:@"%@;%@;%@;%@;", _id, _title, _cover, _content];
}

@end
