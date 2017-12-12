//
//  JFWDesignConfig.swift
//  JinFramework_Swift
//
//  Created by 严锦龙 on 2017/11/28.
//  Copyright © 2017年 Jin. All rights reserved.
//

/**
 cell的默认高度 50，针对屏幕适配了
 */
let CellDefaultHeight = (50.0 * kJFWScreenScale)

/// section的默认高度 10
let SectionDefaultHeight = 10

/// cell为空的高度 0.01
let CellNullHeight = 0.01

/// 屏幕的默认高度
let ViewDefaultHeight = UI_SCREEN_FHEIGHT - UI_TOP_HEIGHT

// 颜色
let C1 = UIColor(hexString: "f9ce31")// 黄色，主色
let C2 = UIColor(hexString: "a3afc0")// 淡黑
let C3 = UIColor(hexString: "232323")// 黑色
let C4 = UIColor(hexString: "545961")// 淡黑
let C5 = UIColor(hexString: "b1b2b5")// 奶白
let C6 = UIColor(hexString: "edeff2")// 背景灰
let C7 = UIColor(hexString: "ffffff")// 白色
let C8 = UIColor(hexString: "7895be")// 淡蓝色
let C9 = UIColor(hexString: "ffedbd")// 淡黄
let C10 = UIColor(hexString: "bba364")// 淡土黄
let C11 = UIColor(hexString: "727274")// 深灰
let C12 = UIColor(hexString: "ff4444")// 红色

// 字体
let F1 = (JFWFont(20.0))
let F2 = (JFWFont(18.0))
let F3 = (JFWFont(16.0))
let F4 = (JFWFont(15.0))
let F5 = (JFWFont(14.0))
let F6 = (JFWFont(13.0))
let F7 = (JFWFont(12.0))
let F8 = (JFWFont(11.0))
let F9 = (JFWFont(10.0))

let FB1 = (JFWBoldFont(20.0))
let FB2 = (JFWBoldFont(18.0))
let FB3 = (JFWBoldFont(16.0))
let FB4 = (JFWBoldFont(15.0))
let FB5 = (JFWBoldFont(14.0))
let FB6 = (JFWBoldFont(13.0))
let FB7 = (JFWBoldFont(12.0))
let FB8 = (JFWBoldFont(11.0))
let FB9 = (JFWBoldFont(10.0))

/// 字号，针对屏幕适配了
func JFWFont(_ number: CGFloat) -> UIFont {
    if UI_SCREEN_FHEIGHT > 480 {
        if UI_SCREEN_FHEIGHT < 736.0 {
            if UI_SCREEN_FHEIGHT < 667.0 {
                return UIFont.systemFont(ofSize: number - 1.0)
            } else {
                return UIFont.systemFont(ofSize: number)
            }
        } else {
            return UIFont.systemFont(ofSize: number + 2)
        }
    } else {
        return UIFont.systemFont(ofSize: number - 2)
    }
}

/// 加粗的字号，针对屏幕适配了
func JFWBoldFont(_ number: CGFloat) -> UIFont {
    if UI_SCREEN_FHEIGHT > 480 {
        if UI_SCREEN_FHEIGHT < 736.0 {
            if UI_SCREEN_FHEIGHT < 667.0 {
                return UIFont.boldSystemFont(ofSize: number - 1.0)
            } else {
                return UIFont.boldSystemFont(ofSize: number)
            }
        } else {
            return UIFont.boldSystemFont(ofSize: number + 2)
        }
    } else {
        return UIFont.boldSystemFont(ofSize: number - 2)
    }
}
