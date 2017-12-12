//
//  JFWRefreshViewController.swift
//  JinFramework_Swift
//
//  Created by 严锦龙 on 2017/11/28.
//  Copyright © 2017年 Jin. All rights reserved.
//

import UIKit

fileprivate let NoMoreDataTipsHeight: CGFloat = 50
fileprivate let NoMoreDataTipsLabelTag = 546

/// 主的上下拉刷新的控制器，提供一些简单的抽离封装
/// 使用方法，①设置支持下拉，上拉等选择；②调用setRefreshTableView方法
class JFWRefreshViewController: JFWViewController {
    
    /// 是否支持下拉刷新
    var pullDown: Bool = false
    
    /// 是否支持上拉加载
    var pullUp: Bool = false
    
    /// 是否存在更多
    var hasMore: Bool = false
    
    fileprivate var headerView: MJRefreshGifHeader?
    fileprivate var footerView: MJRefreshAutoNormalFooter?
    
    /// 分页数据
    var pageModel: PageModelBasic!
    
    fileprivate var tableView: UITableView?
    fileprivate var collectionView: UICollectionView?
    
    override func customView() {
        
    }
    
    // MARK: - 对方方法
    
    /// 停止刷新
    func stopLoading() -> Void {
        if self.tableView != nil {
            DispatchQueue.main.async {
                self.tableView?.mj_header.endRefreshing()
                self.tableView?.mj_footer.endRefreshing()
            }
        } else if self.collectionView != nil {
            DispatchQueue.main.async {
                self.collectionView?.mj_header.endRefreshing()
                self.collectionView?.mj_footer.endRefreshing()
            }
        }
    }
    
    /// 控制加载更多的脚部视图
    func setupLoadMoreView() -> Void {
        // 判断是否有下一页,隐藏底部
        if self.pageModel.pageSize < self.pageModel.totalPage &&
            self.pageModel.dataArray.count != 0 {
            self.hasMore = true
            self.footerView?.isHidden = false
            
            self.hideNoMoreDataTips()
        } else {
            self.hasMore = false
            self.footerView?.isHidden = true
            
            if self.pageModel.dataArray.count >= 10 {
                self.showNoMoreDataTips(tips: nil)
            }
        }
    }
    
    /// 显示没有更多数据的提示（设置table的tableFooterView）
    ///
    /// - Parameter tips: 提示描述
    func showNoMoreDataTips(tips: String?) -> Void {
        var labelWidth: CGFloat = 0
        
        if self.tableView != nil {
            labelWidth = self.tableView!.frame.size.width
        }
        
        let tipsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: labelWidth, height: NoMoreDataTipsHeight))
        tipsLabel.text = tips != nil ? tips : "共 \(self.pageModel.dataArray.count) 条内容"
        tipsLabel.textAlignment = NSTextAlignment.center
        tipsLabel.backgroundColor = UIColor.clear
        tipsLabel.textColor = UIColor.lightGray
        tipsLabel.font = UIFont.systemFont(ofSize: 15)
        tipsLabel.tag = NoMoreDataTipsLabelTag
        
        self.tableView!.tableFooterView = tipsLabel
    }
    
    func hideNoMoreDataTips() -> Void {
        if self.tableView != nil {
            let tipsLabel = self.tableView?.tableFooterView
            
            if tipsLabel?.tag == NoMoreDataTipsLabelTag {
                self.tableView?.tableFooterView = nil
            }
        }
    }
    
    /// 设置需要刷新的表格
    ///
    /// - Parameter tableView: 表格对象
    func setRefreshTableView(tableView: UITableView) -> Void {
        // 初始化数据对象
        self.pageModel = PageModelBasic()
        
        // 设置过了就不设置了
        if self.tableView == nil {
            self.tableView = tableView
            
            if self.pullDown {
                // 下拉刷新
                self.headerView = MJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(loadNewData))
                self.tableView!.mj_header = self.headerView
            }
            
            if self.pullUp {
                // 上拉加载更多
                self.footerView = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
                self.tableView!.mj_footer = self.footerView
                self.footerView!.isHidden = true
            }
        }
    }
    
    /// 设置需要刷新的collectionView
    ///
    /// - Parameter collectionView: 需要刷新的collectionView
    func setRefreshCollectionView(collectionView: UICollectionView) -> Void {
        // 初始化数据对象
        self.pageModel = PageModelBasic()
        
        // 设置过了就不设置了
        if self.collectionView == nil {
            self.collectionView = collectionView
            
            if self.pullDown {
                // 下拉刷新
                self.headerView = MJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(loadNewData))
                self.collectionView!.mj_header = self.headerView
            }
            
            if self.pullUp {
                // 上拉加载更多
                self.footerView = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
                self.collectionView!.mj_footer = self.footerView
                self.footerView!.isHidden = true
            }
        }
    }
    
    // MARK: - 上下拉刷新所执行的方法
    
    @objc func loadNewData() -> Void {
        
    }
    
    @objc func loadMoreData() -> Void {
        
    }
    
    // MARK: - NetworkDelegate
    
    override func loadDataSuccess(responseData: Any, identifier: String) {
        let isSuccess = JFWNetworkManager.parseDataYESOrNO(responseData, identifier: identifier)
        self.hideNoNetView()
        self.stopLoading()
        
        if isSuccess {
            self.parseData(body: responseData, identifier: identifier)
        } else {
            let response = responseData as! NSDictionary
            var message = response["message"] as! String
            
            if message.characters.count == 0 {
                message = DefaultErrorTips
            }
            
            self.showErrorTips(tips: message)
        }
    }
    
    override func loadDataFailure(error: Error?, identifier: String) {
        super.loadDataFailure(error: error, identifier: identifier)
        
        // 请求失败了也要停止loading的视图
        self.stopLoading()
    }
}
