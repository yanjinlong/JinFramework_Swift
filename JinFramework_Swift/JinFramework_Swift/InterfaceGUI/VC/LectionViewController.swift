//
//  LectionViewController.swift
//  JinFramework_Swift
//
//  Created by 严锦龙 on 2017/12/20.
//  Copyright © 2017年 Jin. All rights reserved.
//

import UIKit

fileprivate let kCellIdentifier = "kCellIdentifier"

class LectionViewController: JFWViewController {
    fileprivate var network: JFWNetworkManager!
    fileprivate var modelArray: [ZBlogArticleModelOC] = [ZBlogArticleModelOC]()
    fileprivate var itemArray: [LectionModel] = [LectionModel]()
    fileprivate var mainTableView: UITableView!
    
    override func customView() {
        self.view.backgroundColor = UIColor.red
        
        let cache = DBHelper.shareInstance()
        let isTrue = cache.openDB()
        
        if isTrue == false {
            return
        }
        
        let restulData = cache.queryDBData(querySQL: "select * from lection where lection_isHot = 2")
        var array = [LectionModel]()
        
        for item in restulData! {
            let model = LectionModel.init(withDict: item as NSDictionary)

            array.append(model)
        }
        
        itemArray = array
        
        network = JFWNetworkManager(delegate: self)
        network.manager.requestSerializer = AFJSONRequestSerializer()
        network.setHttpHeader(method: "qryArticle")

        let param = NSMutableDictionary()
        param["cate"] = "1"
        param["formSource"] = "iOS"
        param["pageNo"] = "1"
        param["pageSize"] = "50"

        network.request(type: .post, url: "http://192.168.31.99/zb_users/plugin/haloapi/api.php?act=qryArticle", parameters: param)
        
        mainTableView = UITableView(frame: CGRect(x: 0, y: UI_TOP_HEIGHT, width: UI_SCREEN_FWIDTH, height: ViewDefaultHeight), style: .grouped)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        self.view.addSubview(mainTableView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        network.delegate = nil
        network = nil
    }
    
    deinit {
        print("关闭了")
    }
    
    override func loadDataSuccess(responseData: Any, identifier: String) {
        let dict = responseData as! NSDictionary
        
        let resultDesc = dict["resultDesc"] as! NSDictionary
        let errCode = resultDesc["errCode"] as! NSInteger
        
        if errCode == 200 {
            if identifier == "qryArticle" {
                let resultData = dict["resultData"] as! NSArray
                
//                let array = NSArray.modelArray(with: ZBlogArticleModelOC.self, json: resultData)
                let list = [ZBlogArticleModel].deserialize(from: resultData)
                let model = ZBlogArticleModel.deserialize(from: resultData[0] as? NSDictionary)
                
                print(list)
                // 自个写
                //            var array = [LectionModel]()
                //
                //            for item in resultData {
                //                let model = LectionModel.init(withDict: item as! NSDictionary)
                //
                //                if model != nil {
                //                    array.append(model)
                //                }
                //            }
                
//                modelArray = array as! [ZBlogArticleModelOC]
                
//                self.doLoop()
                self.mainTableView.reloadData()
            } else if identifier == "qryArticleDetails" {
                // 拿到详情了
                let resultData = dict["resultData"] as! NSDictionary
                let model = ZBlogArticleModelOC.model(withJSON: resultData)
                
                self.updateModel(id: model!.id, model: model!)
                
//                _ = self.insertLectionToDB(model: model!, dbHelper: DBHelper.shareInstance())
            }
        }
    }
    
    fileprivate func doLoop() {
        for item in modelArray {
            // 走第二步，拿详情
            let param = NSMutableDictionary()
            param["artId"] = item.id
            param["formSource"] = "iOS"
            param["filter"] = "true"
            
            network.setHttpHeader(method: "qryArticleDetails")
            network.request(type: .post, url: "http://192.168.31.99/zb_users/plugin/haloapi/api.php?act=qryArticleDetails", parameters: param)
        }
    }
    
    fileprivate func updateModel(id: String, model: ZBlogArticleModelOC) {
        for item in modelArray {
            if item.id == id {
                item.content = model.content
                break
            }
        }
    }
    
    /// 插入数据到数据库
    func insertLectionToDB(model: ZBlogArticleModelOC, dbHelper: DBHelper) -> Bool {
        //插入SQL语句
        let insertSQL = "INSERT INTO 'lection' (lection_id,lection_name,lection_pic,lection_content,lection_isHot) VALUES ('\(model.id!)','\(model.title!)','\(model.cover!)','\(model.content!)','2');"
        
        if dbHelper.execSQL(SQL: insertSQL) {
            print("插入数据成功")
            return true
        } else {
            return false
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CellDefaultHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: kCellIdentifier)
        }
        
        let model = itemArray[indexPath.row]
        cell?.textLabel?.text = model.lection_name
        
        return cell!
    }
}
