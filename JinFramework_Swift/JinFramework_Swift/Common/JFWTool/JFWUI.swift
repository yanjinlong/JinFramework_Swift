//
//  JFWUI.swift
//  JinFramework_Swift
//
//  Created by 严锦龙 on 2017/11/27.
//  Copyright © 2017年 Jin. All rights reserved.
//

import UIKit

/// 提炼跟UI有关的公共多用的封装类
class JFWUI: NSObject {
    /// 默认的返回图片
    ///
    /// - Returns: 图片对象
    class func backButtonItemImage() -> UIImage {
        return UIImage(named: "nav_back")!
    }
    
    /// 系统的线条颜色
    ///
    /// - Returns: 颜色值
    class func systemLineColor() -> UIColor {
        return UIColor(hexString: "C8C7CC")!
    }
    
    /// 获得线条的一像素值
    ///
    /// - Returns: 根据屏幕比例值返回不同的结果
    class func line1PixelValue() -> CGFloat {
        return 1.0 / YYScreenScale()
    }
    
    /// 直接在push一个控制器
    ///
    /// - Parameters:
    ///   - vc: 控制器
    ///   - animated: 是否需要动画
    class func pushNextVC(vc: UIViewController, animated: Bool) -> Void {
        let naVC = self.getNavigationController()
        
        if naVC != nil {
            naVC!.pushViewController(vc, animated: animated)
        }
    }
    
    /// 获得导航栏
    ///
    /// - Returns: 导航栏控制器
    class func getNavigationController() -> UINavigationController? {
        let window = UIApplication.shared.windows[0]
        let naVC = window.rootViewController as? UINavigationController
        
        return naVC
    }
}
