//
//  JFWConfig.swift
//  JinFramework_Swift
//
//  Created by 严锦龙 on 2017/11/27.
//  Copyright © 2017年 Jin. All rights reserved.
//

/// 全屏宽度
let UI_SCREEN_FWIDTH = (UIScreen.main.bounds.size.width)

/// 全屏高度
let UI_SCREEN_FHEIGHT = (UIScreen.main.bounds.size.height)

/// 屏幕因子 2或3（1的已经不存在了）
let WWScreenScale = UIScreen.main.scale

let UI_iPhone6P_H: CGFloat = 736
let UI_iPhone6_H: CGFloat = 667
let UI_iPhone6_W: CGFloat = 375

/// tab bar高度 49
let UI_TABBAR_HEIGHT: CGFloat = 49

/// 状态栏的高度
let UI_STATUSBAR_HEIGHT: CGFloat = UIApplication.shared.statusBarFrame.size.height

/// 导航栏的高度（不包括了状态栏的） 44
let UI_NAVBAR_HEIGHT: CGFloat = 44

/// 导航栏的高度（包括了状态栏的） 44 + 状态栏高度
let UI_TOP_HEIGHT: CGFloat = (UI_STATUSBAR_HEIGHT + UI_NAVBAR_HEIGHT)

/// 主题色
let ThemeColor: UIColor = UIColor(hexString: "F72E47")!

/// 适配屏幕的基数
let kJFWScreenScale = (UI_SCREEN_FWIDTH / UI_iPhone6_W)

/// 默认错误提示
let DefaultErrorTips = "网络异常，请稍后再试！"
