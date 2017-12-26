//
//  JFWViewController.swift
//  JinFramework_Swift
//
//  Created by 严锦龙 on 2017/11/27.
//  Copyright © 2017年 Jin. All rights reserved.
//

import UIKit

fileprivate let NoNetViewTag = 159
fileprivate let NoDataViewTag = 283

/// 接口定义，供子类实现用的一些方法
protocol JFWViewControllerInterface: NSObjectProtocol {
    
    /// 快捷解析数据的提炼，供子类继承
    ///
    /// - Parameters:
    ///   - body: 正确数据的字典
    ///   - identifier: 方法名
    func parseData(body: Any, identifier: String) -> Void
}

protocol JFWVCDescriptionInterface: NSObjectProtocol {
    
    /// 控制器中文名描述（子类需重写才可）
    ///
    /// - Returns: 中文名描述
    func descriptionCN() -> String
}

/// 控制器基类
class JFWViewController: UIViewController {
    
    // MARK: - 属性
    
    /// 导航栏背景
    var navBGView: UIView! {
        get {
            return self.getNavBGView()
        }
    }
    
    fileprivate lazy var hud: WSProgressHUD = {
        let _hud = WSProgressHUD(view: self.view)
        self.view.addSubview(_hud!)
        
        return _hud!
    }()
    
    // MARK: - 规范好流程
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.rt_disableInteractivePop = true    // 关掉rt的滑动返回选项，保留fd的
        
        if self.navigationController != nil {
            JFWViewController.setNavStyle(nav: self.navigationController!, isHaveBottomLine: false)
        }
        
        self.customView()
        self.customNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    /// 设置nav的样式
    ///
    /// - Parameter nav: nav控制器
    class func setNavStyle(nav: UINavigationController, isHaveBottomLine: Bool) {
        var bgImageView = UIImageView()
        var underLineView = UIView()
        var navBGView = UIView()
        let itemTintColor = ThemeColor
        let textTintColor = UIColor.black
        let backgroundColor = UIColor.white
        
        if UIDevice.systemVersion() >= 10 {
            // iOS10之后的处理
            nav.navigationBar.tintColor = itemTintColor
            nav.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : textTintColor]
            UIApplication.shared.statusBarStyle = .default
            
            // 背景视图的新对象
            navBGView = UIView(frame: CGRect(x: 0, y: -UI_STATUSBAR_HEIGHT,
                                             width: UI_SCREEN_FWIDTH, height: UI_TOP_HEIGHT))
            navBGView.backgroundColor = backgroundColor
            
            // 图片背景
            bgImageView = UIImageView(frame: navBGView.bounds)
            bgImageView.isHidden = true
            navBGView.addSubview(bgImageView)
            bgImageView.isUserInteractionEnabled = false
            
            // 下划线
            let scale = UIScreen.main.scale
            let height = 1 / scale
            underLineView = UIView(frame: CGRect(x: 0, y: UI_NAVBAR_HEIGHT, width: UI_SCREEN_FWIDTH, height: height))
            underLineView.backgroundColor = JFWUI.systemLineColor()
            
            if isHaveBottomLine {
                navBGView.addSubview(underLineView)
            }
            
            // 重置背景视图
            nav.navigationBar.setValue(navBGView, forKey: "backgroundView")
        } else {
            // iOS10之前的处理
            nav.navigationBar.tintColor = itemTintColor
            nav.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : textTintColor]
            UIApplication.shared.statusBarStyle = .default
            
            // 背景视图的新对象
            navBGView = UIView(frame: CGRect(x: 0, y: 0, width: UI_SCREEN_FWIDTH, height: UI_TOP_HEIGHT))
            navBGView.backgroundColor = backgroundColor
            
            // 图片背景
            bgImageView = UIImageView(frame: navBGView.bounds)
            bgImageView.isHidden = true
            navBGView.addSubview(bgImageView)
            
            // 下划线
            let scale = UIScreen.main.scale
            let height = 1 / scale
            underLineView = UIView(frame: CGRect(x: 0, y: UI_NAVBAR_HEIGHT, width: UI_SCREEN_FWIDTH, height: height))
            underLineView.backgroundColor = JFWUI.systemLineColor()
            
            if isHaveBottomLine {
                navBGView.addSubview(underLineView)
            }
            
            // 对背景视图进行改造
            let bgView = nav.navigationBar.value(forKey: "backgroundView") as! UIView
            
            // 移除底部自带的底线，由我们自己额外添加一条底线来控制
            for item in bgView.subviews {
                if (item.frame.size.height * scale == 1) {
                    item.removeFromSuperview()
                    break
                }
            }
            
            bgView.addSubview(navBGView)
        }
    }
    
    /// 得到导航栏视图
    fileprivate func getNavBGView() -> UIView {
        var navBGView: UIView!
        
        if UIDevice.systemVersion() >= 10 {
            // iOS10之后
            let backgroundView = self.navigationController?.navigationBar.value(forKey: "backgroundView") as? UIView
            navBGView = backgroundView!
        } else {
            // iOS10之前
            let backgroundView = self.navigationController?.navigationBar.value(forKey: "backgroundView") as? UIView
            navBGView = backgroundView!.subviews.first!
        }
        
        return navBGView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.dismissLoading()
    }
    
    deinit {
        
    }
    
    // MARK: - 基类代码，供子类继承使用
    
    /// 自定义的初始化视图的方法
    func customView() {
        
    }
    
    /**
     自定义的导航栏方法
     */
    func customNavigationBar() {
        
    }
    
    // MARK: - 封装/提炼 的方法
    
    /// 返回按钮的动作方法
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// 设置默认的返回按钮
    func setDefaultBackItem() {
        let backButton = UIBarButtonItem(image: JFWUI.backButtonItemImage(),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonAction))
        
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    /// 设置默认的标题
    ///
    /// - Parameter title: 设置标题
    func setDefaultTitle(_ title : String) {
        self.navigationItem.title = title
    }
    
    /**
     重新加载数据
     */
    func reloadNewData() {
    
    }
    
    override var description: String {
        get {
            return "\(self.className())(\(self.descriptionCN()))"
        }
    }
    
    // MARK: - 对没有网和没数据的表现
    
    /// 没有数据时显示的界面
    ///
    /// - Parameters:
    ///   - tipsText: 提示标题
    ///   - forView: 给哪个视图添加
    func showNoDataView(tipsText: String, forView: UIView) -> Void {
        var noDataView = forView.viewWithTag(NoDataViewTag) as? JFWEmptyView
        
        if noDataView == nil {
            noDataView = JFWEmptyView()
            noDataView!.tag = NoDataViewTag
            noDataView!.viewType = EmptyViewType.noData
            noDataView?.tipsText = tipsText
            
            forView.addSubview(noDataView!)
        }
    }
    
    /// 隐藏没有数据的视图
    ///
    /// - Parameter forView: 给哪个视图去掉
    func hideNoDataView(forView: UIView) -> Void {
        let noDataView = forView.viewWithTag(NoDataViewTag)
        
        if noDataView != nil {
            noDataView!.removeFromSuperview()
        }
    }
    
    /// 显示没有网络的视图
    func showNoNetView() -> Void {
        var noNetView = self.view.viewWithTag(NoNetViewTag) as? JFWEmptyView
        
        if noNetView == nil {
            noNetView = JFWEmptyView()
            noNetView!.tag = NoNetViewTag;
            
            weak var weakSelf = self
            noNetView?.didTouchViewBlock = { () in
                weakSelf?.reloadNewData()
            }
            
            self.view.addSubview(noNetView!)
        }
    }
    
    /// 隐藏没有网络的视图
    func hideNoNetView() -> Void {
        let noNetView = self.view.viewWithTag(NoNetViewTag)
        
        if noNetView != nil {
            noNetView?.removeFromSuperview()
        }
    }
    
    // MARK: - 提示指示器
    
    /// 显示loagding
    ///
    /// - Parameter loadTips: 提示语
    func showLoading(loadTips: String?) {
        var loading = "Loading..."
        
        if loadTips != nil && loadTips!.characters.count > 0 {
            loading = loadTips!
        }
        
        DispatchQueue.main.async {
            self.hud.show(with: loading, maskType: .clear, maskWithout: .navigation)
        }
    }
    
    /// loading消失
    func dismissLoading() {
        DispatchQueue.main.async {
            self.hud.dismiss()
        }
    }
    
    /// 提示文本，自动消失
    ///
    /// - Parameter tips: 提示内容
    func showAutoDismissText(tips: String) {
        DispatchQueue.main.async {
            self.hud.dismiss()
            
            self.hud.show(nil,
                          status: tips,
                          maskType: .clear,
                          maskWithout: .navigation)
        }
    }
    
    /// 就提示文字而已，需要用户点击才关闭
    ///
    /// - Parameter tips: 提示
    func showTextTips(tips: String) {
        DispatchQueue.main.async {
            self.hud.showImageNoAutoDismiss(nil, status: tips,
                                            maskType: .clear, maskWithout: .navigation)
        }
    }
    
    /// 显示成功
    ///
    /// - Parameters:
    ///   - tips: 提示内容
    ///   - dismissBlock: 消失时的执行block
    func showSuccessTips(tips: String, dismissBlock: (() -> Swift.Void)? = nil) {
        DispatchQueue.main.async {
            self.hud.showSuccess(with: tips)
            let time = DispatchTime.now() + Double(Int64(1.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            
            DispatchQueue.main.asyncAfter(deadline: time, execute: {
                self.dismissLoading()
                
                dismissBlock?()
            })
        }
    }
    
    /// 展示错误信息，需要用户点击才关闭
    ///
    /// - Parameter tips: 提示
    func showErrorTips(tips: String) {
        DispatchQueue.main.async {
            self.hud.showError(with: tips)
        }
    }
}

// MARK: - NetworkDelegate
extension JFWViewController: NetworkDelegate {
    func loadDataSuccess(responseData: Any, identifier: String) {
        // 能走这里证明有网络，需要把无网的视图干掉
        self.hideNoNetView()
        
        let isSuccess = JFWNetworkManager.parseDataYESOrNO(responseData, identifier: identifier)
        let response = responseData as! NSDictionary
        
        if (isSuccess) {
            let data = response["data"]
            self.parseData(body: data!, identifier: identifier)
        }
        else {
            var message = response["message"] as! String
            
            if (message.characters.count == 0) {
                message = DefaultErrorTips
            }
            
            self.showErrorTips(tips: message)
        }
    }
    
    func loadDataFailure(error: Error?, identifier: String) {
        self.dismissLoading()
        
        let nsError = error! as NSError
        
        // 弹出错误提示
        if (nsError.code == -1009 || nsError.code == -1003 || nsError.code == -1005 || nsError.code == -1001) {
            self.showNoNetView()
        } else {
            self.showErrorTips(tips: DefaultErrorTips)
        }
    }
    
    // MARK: - 先pop再push
    
    /// 先pop再push的方法
    ///
    /// - Parameters:
    ///   - newVC: 新的控制器
    ///   - animated: 是否开启动画
    func popWithPush(newVC: UIViewController, animated: Bool) -> Void {
        self.podWidthPush(newVC: newVC, withPopCount: 1, animated: animated)
    }
    
    /// 先pop再push的方法，添加了pop的视图数量
    ///
    /// - Parameters:
    ///   - newVC: 新的控制器
    ///   - withPopCount: pop的视图数量
    ///   - animated: 是否开启动画
    func podWidthPush(newVC: UIViewController, withPopCount: Int, animated: Bool) -> Void {
        if withPopCount > 0 {
            var navVCArray = self.rt_navigationController.viewControllers
            
            for _ in 0..<withPopCount {
                navVCArray.remove(at: navVCArray.count - 1)
            }
            
            navVCArray.append(newVC)
            
            self.rt_navigationController.setViewControllers(navVCArray, animated: animated)
        }
    }
}

// MARK: - JFWViewControllerInterface
extension JFWViewController: JFWViewControllerInterface {
    
    /// 快捷解析数据的提炼，供子类继承
    ///
    /// - Parameters:
    ///   - body: 正确数据的字典
    ///   - identifier: 方法名
    func parseData(body: Any, identifier: String) {
        
    }
}

extension JFWViewController: JFWVCDescriptionInterface {
    func descriptionCN() -> String {
        return "控制器基类"
    }
}
