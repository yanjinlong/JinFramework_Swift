//
//  NetworkManager.swift
//  JinFramework_Swift
//
//  Created by 严锦龙 on 2017/11/27.
//  Copyright © 2017年 Jin. All rights reserved.
//

import UIKit

/// 请求类型
///
/// - get: get
/// - post: post
enum RequestType: Int {
    case get = 0
    case post
}

/// 网路请求的委托
@objc protocol NetworkDelegate: NSObjectProtocol {
    
    /// 网络请求成功
    ///
    /// - Parameters:
    ///   - responseData: 返回的数据
    ///   - identifier: 方法的标志
    @objc optional func loadDataSuccess(responseData: Any, identifier: String) -> Void
    
    /// 网络请求失败
    ///
    /// - Parameters:
    ///   - error: 失败的信息
    ///   - identifier: 方法的标志
    @objc optional func loadDataFailure(error: Error?, identifier: String) -> Void
}

/// 网络请求的抽离
class NetworkManager: NSObject {
    var timeInterval: TimeInterval = 0
    weak var delegate: NetworkDelegate!
    var manager: AFHTTPSessionManager!
    var originalClass: String!
    
    init(delegate: NetworkDelegate) {
        super.init()
        
        self.initDefaultData()
        self.delegate = delegate
        self.originalClass = NetworkManager.className(delegate)
    }
    
    fileprivate func initDefaultData() {
        self.timeInterval = 5
        self.manager = AFHTTPSessionManager()
        self.manager.requestSerializer = AFHTTPRequestSerializer()
        
        let responseSerializer = AFJSONResponseSerializer()
        responseSerializer.removesKeysWithNullValues = true
        responseSerializer.acceptableContentTypes = ["application/json", "text/json",
                                                     "text/javascript", "text/html", "text/plain"]
        self.manager.responseSerializer = responseSerializer
        
        // 初始化其他的东西
        self.initOther()
    }
    
    // MARK: - 虚方法
    
    /// 初始化其他的东西，让子类重写，有其他的发展空间（子类实现）
    func initOther() -> Void {
        
    }
    
    /// 请求前需要执行的内容，让子类发挥空间（子类实现）
    ///
    /// - Parameters:
    ///   - type: 请求类型
    ///   - url: 请求地址
    ///   - parameters: 请求参数
    func requestBefore(type: RequestType, url: String, parameters: NSDictionary) -> Void {
        
    }
    
    /// 获得url中的方法名称（子类实现）
    ///
    /// - Parameter headerDict: 请求头的字典集
    func getMethod(headerDict: [String: String]) -> String {
        let method = headerDict["method"]
        
        return method!
    }
    
    // MARK: - 实际方法
    
    /// 发送请求
    ///
    /// - Parameters:
    ///   - type: 请求类型
    ///   - url: 请求地址
    ///   - parameters: 请求参数
    func request(type: RequestType, url: String, parameters: NSDictionary) -> Void {
        self.manager.requestSerializer.timeoutInterval = self.timeInterval
        self.requestBefore(type: type, url: url, parameters: parameters)
        
        if type == RequestType.get {
            self.manager.get(url, parameters: parameters, progress: { (progress) in
                // 进度
            }, success: { (task, responseObject) in
                let currentClass = NetworkManager.className(self.delegate)
                
                if (currentClass == self.originalClass) {
                    self.successBlock(task, responseObject: responseObject!)
                }
                else {
                    NSLog("delegate被释放");
                }
            }, failure: { (task, error) in
                let currentClass = NetworkManager.className(self.delegate)
                
                if (currentClass == self.originalClass) {
                    self.failureBlock(task!, error:error)
                }
                else {
                    NSLog("delegate被释放");
                }
            })
        } else if type == RequestType.post {
            
        }
    }
    
    // MARK: - 把成功和失败的block提炼开来
    
    func successBlock(_ task: URLSessionDataTask, responseObject: Any) -> Void {
        let currentClass = NetworkManager.className(self.delegate)
        
        if currentClass == self.originalClass {
            let identifier = self.getMethod(headerDict: (task.originalRequest?.allHTTPHeaderFields)!)
            
            self.delegate?.loadDataSuccess?(responseData: responseObject, identifier: identifier)
        } else {
            NSLog("delegate被释放")
        }
    }
    
    func failureBlock(_ task: URLSessionDataTask, error: Error) -> Void {
        let currentClass = NetworkManager.className(self.delegate)
        
        if currentClass == self.originalClass {
            let identifier = self.getMethod(headerDict: (task.originalRequest?.allHTTPHeaderFields)!)
            
            self.delegate?.loadDataFailure?(error: error, identifier: identifier)
        } else {
            NSLog("delegate被释放")
        }
    }
    
    class func className(_ obj: Any) -> String {
        return String(describing: type(of: obj))
    }
    
    // MARK: - 静态类方法
    
    /// 获得当前联网方式
    ///
    /// - Returns: 联网方式的字符串
    class func getCurrentNetWorkType() -> String {
        var netWorkType = "0"
        
        // 2.检测手机是否能上网络(WIFI\3G\2.5G)
        let conn = Reachability.forInternetConnection()
        let networkStatue = conn?.currentReachabilityStatus()
        
        // 3.判断网络状态
        if (networkStatue == ReachableViaWWAN) {
            // 没有使用wifi, 使用手机自带网络进行上网
            netWorkType = "GPRS"
        }
        else if (networkStatue == ReachableViaWiFi) {
            // 有wifi
            netWorkType = "WiFi"
        }
        else {
            // 没有网络
            netWorkType = "noconnect"
        }
        
        return netWorkType
    }
}
