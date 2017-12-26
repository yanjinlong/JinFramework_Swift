//
//  DiskCache.swift
//  JinFramework_Swift
//
//  Created by 严锦龙 on 2017/12/20.
//  Copyright © 2017年 Jin. All rights reserved.
//

import UIKit

/// 磁盘缓存
class DiskCache: YYDiskCache {
    static fileprivate let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
    
//    static let shareCache = DiskCache(path: cachePath + "/JinFramework_Swift")!
    static let shareCache = DiskCache(path: cachePath + "/JinFramework_Swift", inlineThreshold: 1024 * 100)!
}
