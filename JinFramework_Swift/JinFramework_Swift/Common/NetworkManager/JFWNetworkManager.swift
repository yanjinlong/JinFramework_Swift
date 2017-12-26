//
//  JFWNetworkManager.swift
//  JinFramework_Swift
//
//  Created by 严锦龙 on 2017/11/27.
//  Copyright © 2017年 Jin. All rights reserved.
//

import UIKit

/* 数据接口 */
#if DEBUG
    
let BusmanOPENURL = "http://api.t.myoba.net/"   // 测试环境
    
#else
    
let BusmanOPENURL = "http://api.t.myoba.net/"   // 正式环境
    
#endif

fileprivate let MaxErrorTimes = 0
fileprivate let RefreshTokenMethod = "refreshToken"

/// 主框架的网络管理者
class JFWNetworkManager: NetworkManager {
//    fileprivate var errorTimesDict: [String: Int]!
//    fileprivate var urlDict: [String: String]!
//    fileprivate var paramsDict: [String: NSDictionary]!
//    fileprivate var requestTypeDict: [String: RequestType]!
    
    /// 解析数据是正确还是错误
    ///
    /// - Parameters:
    ///   - responseData: 返回的数据
    ///   - identifier: 方法的标志
    class func parseDataYESOrNO(_ responseData: Any, identifier: String) -> Bool {
        let response = responseData as! NSDictionary
        let errorCodee = response["code"] as! Int
        
        if errorCodee == 0 {
            return true
        } else {
            let errorMsg = response["message"] as! String
            NSLog("method:%@; errorCode: %ld; errorMsg: %@", identifier, errorCodee, errorMsg)
            
            return false
        }
    }
    
//    override func initOther() {
//        self.errorTimesDict = [String: Int]()
//        self.urlDict = [String: String]()
//        self.paramsDict = [String: NSDictionary]()
//        self.requestTypeDict = [String: RequestType]()
//    }
//
//    override func requestBefore(type: RequestType, url: String, parameters: NSDictionary) {
//        let method = self.getMethod(headerDict: self.manager.requestSerializer.httpRequestHeaders)
//
//        self.requestTypeDict[method] = type
//        self.urlDict[method] = url
//        self.paramsDict[method] = parameters
//        self.errorTimesDict[method] = MaxErrorTimes
//    }
    
    /**
     设置http头
     
     @param method 方法名
     */
    func setHttpHeader(method: String) {
        let request = self.manager.requestSerializer
        request.setValue(method, forHTTPHeaderField: "method")
    }
}
