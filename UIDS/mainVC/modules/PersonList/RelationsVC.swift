//
//  RelationsVC.swift
//  UIDS
//
//  Created by Hobson on 2018/3/12.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import ReusableKit
import ESPullToRefresh
enum RelationshipType{
    case friend
    case follow
    case funs
}

class RelationsVC: NaviBarVC,UITableViewDelegate, UITableViewDataSource {
    //信息列表
    var userList : [UserInfoData]?
    //信息类型
    var relationType : RelationshipType?
    //页码
    var page : Int?
    var tableView:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.page = 1
        self.setNaviDefulat()
        switch self.relationType! {
        case RelationshipType.follow :
            self.naviBar().setTitle("关注列表")
        case RelationshipType.friend :
            self.naviBar().setTitle("好友列表")
        case RelationshipType.funs :
            self.naviBar().setTitle("粉丝列表")
        }
        setUI()
        
        getInfo()
        
        self.tableView?.register(UINib.init(nibName: "RelationCell", bundle: nil), forCellReuseIdentifier: "relation")
    }
    func setUI(){
        self.tableView = UITableView(frame: self.view.frame, style: .plain)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.top = self.naviBar().bottom
        self.tableView?.tableFooterView = UIView()
        self.tableView?.es.addPullToRefresh {
            self.page = 1
            self.getInfo()
        }
        self.tableView?.es.addInfiniteScrolling {
            self.page = self.page! + 1
            self.getInfo()
        }
        self.view.addSubview(tableView!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- 获取数据
    
    func getInfo(){
        let params = NSMutableDictionary()
        params.setValue(20, forKey: "page_context")
        params.setValue(self.page, forKey: "page")
        if self.relationType == .follow{
            ApiUtil.share.getFollowerList(params: params) {[weak self] (status, data, msg) in
                if status == B_ResponseStatus.success{
                    let list  =  UserListModel.deserialize(from: data)?.data
                    if self?.page == 1{
                        self?.userList = list
                    }else{
                        self?.userList = (self?.userList)! + list!
                    }
                }
                
                DispatchQueue.main.async {
                    self?.tableView?.reloadData()
                }
                self?.tableView?.es.stopPullToRefresh()
                self?.tableView?.es.stopLoadingMore()
            }
        }else if self.relationType == .friend{
            ApiUtil.share.getFunsList(params: params, finish: {[weak self] (status, data, msg) in
                if status == B_ResponseStatus.success{
                    let list  =  UserListModel.deserialize(from: data)?.data
                    if self?.page == 1{
                        self?.userList = list
                    }else{
                        self?.userList = (self?.userList)! + list!
                    }
                }
                DispatchQueue.main.async {
                    self?.tableView?.reloadData()
                }
                self?.tableView?.es.stopPullToRefresh()
                self?.tableView?.es.stopLoadingMore()
            })
        }else {
            ApiUtil.share.getFriendList(params: params, finish: {[weak self] (status, data, msg) in
                if status == B_ResponseStatus.success{
                    let list  =  UserListModel.deserialize(from: data)?.data
                    if self?.page == 1{
                        self?.userList = list
                    }else{
                        self?.userList = (self?.userList)! + list!
                    }
                }
                DispatchQueue.main.async {
                    self?.tableView?.reloadData()
                }
                self?.tableView?.es.stopPullToRefresh()
                self?.tableView?.es.stopLoadingMore()
            })
        }
        
    }
}
//MARK:- tableView Delegate
extension RelationsVC {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemData = self.userList![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "relation") as! RelationCell
        switch self.relationType ?? .follow{
        case .follow:
            cell.actionBtn.setTitle("取消关注", for: .normal)
        case .friend:
            cell.actionBtn.removeFromSuperview()
        case .funs:
            cell.actionBtn.setTitle("添加关注", for: .normal)
        }
        cell.itemData = itemData
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = self.userList?.count ?? 0
        return count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


