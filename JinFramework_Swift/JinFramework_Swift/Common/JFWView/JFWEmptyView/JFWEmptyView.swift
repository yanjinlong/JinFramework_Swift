//
//  JFWEmptyView.swift
//  JinFramework_Swift
//
//  Created by 严锦龙 on 2017/11/28.
//  Copyright © 2017年 Jin. All rights reserved.
//

import UIKit

/// 空视图的界面类型
///
/// - noNet: 无网
/// - noData: 无数据
enum EmptyViewType: Int {
    case noNet = 0
    case noData = 1
}

/// 空视图（无网，无数据）
class JFWEmptyView: UIView {
    
    /// 点击了屏幕触发block
    var didTouchViewBlock: (() -> Void)?
    var viewType: EmptyViewType!
    var tipsText: String?
    
    fileprivate var imageView: UIImageView!
    fileprivate var tipsLabel: UILabel!
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        
        self.initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 初始化视图
    fileprivate func initView() -> Void {
        self.backgroundColor = UIColor.white
        let width = 60 * kJFWScreenScale
        let height = width
        
        // 图标
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        self.imageView.center = CGPoint(x: UI_SCREEN_FWIDTH / 2, y: UI_SCREEN_FHEIGHT / 2 - height)
        self.addSubview(self.imageView)
        
        // 文本
        self.tipsLabel = UILabel(frame: CGRect(x: 0, y: self.imageView.bottom, width: UI_SCREEN_FWIDTH, height: 28))
        self.tipsLabel.textAlignment = NSTextAlignment.center
        self.tipsLabel.textColor = ThemeColor
        self.tipsLabel.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(self.tipsLabel)
    }
    
    override func draw(_ rect: CGRect) {
        var imageName = "noNet"
        var tipsText = "网络不给力，点击屏幕重试"
        
        if self.viewType == EmptyViewType.noData {
            imageName = "noData"
            tipsText = "暂无数据"
            
            if self.tipsText?.characters.count == 0 {
                tipsText = self.tipsText!
            }
        } else {
            // 只有无网才可以点击屏幕进行重试
            let tap = UITapGestureRecognizer(actionBlock: { (sender) in
                if self.didTouchViewBlock != nil {
                    self.didTouchViewBlock!()
                }
            })
            
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(tap)
        }
        
        let image = UIImage(named: imageName)
        self.imageView.image = image
        
        self.tipsLabel.text = tipsText
    }
}
