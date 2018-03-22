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
import SwiftyJSON
enum RelationshipType{
    case friend
    case follow
    case funs
    case release
    case huoKe
    case qiangDan
}

class RelationsVC: NaviBarVC,UITableViewDelegate, UITableViewDataSource {
    //信息列表
    var userList : [UserInfoData]?
    var orderList: [OrderCData]?
    var topicList: [TopicData]?
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
        case RelationshipType.release:
            self.naviBar().setTitle("发布列表")
        case RelationshipType.huoKe:
            self.naviBar().setTitle("预约获客")
        case RelationshipType.qiangDan:
            self.naviBar().setTitle("获客抢单")
        }
        setUI()
        
        getInfo()
        self.tableView?.register(UINib.init(nibName: "RelationCell", bundle: nil), forCellReuseIdentifier: "relation")
        self.tableView?.register(UINib.init(nibName: "GrapCell", bundle: nil),forCellReuseIdentifier:"order")
        self.tableView?.register(UINib.init(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "oning")
        self.tableView?.register(UINib.init(nibName: "TopicCell", bundle: nil), forCellReuseIdentifier: "topic")
        
        
    }
    func setUI(){
        self.tableView = UITableView(frame: self.view.frame, style: .plain)
        self.tableView?.height = kScreenH - 64
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.top = self.naviBar().bottom
        self.tableView?.separatorStyle = .none
        self.tableView?.es.addPullToRefresh {
            self.page = 1
            self.getInfo()
        }
        self.tableView?.es.addInfiniteScrolling {
            self.page = self.page! + 1
            self.getInfo()
        }
        self.view.addSubview(tableView!)
        switch self.relationType!{
        case .friend,.follow,.funs:
            self.tableView?.rowHeight = 60
        default:
            break
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
//MARK:- tableView Delegate
extension RelationsVC {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var relationCell = RelationCell()
        var grapCell = GrapCell()
        var oningCell = OrderCell()
        var topicCell = TopicCell()
        
        switch self.relationType ?? .follow {
        case .follow,.friend,.funs:
            relationCell = tableView.dequeueReusableCell(withIdentifier: "relation") as! RelationCell
        case .qiangDan:
            oningCell = tableView.dequeueReusableCell(withIdentifier: "oning") as! OrderCell
            oningCell.selectionStyle = .none
        case .huoKe:
            grapCell = tableView.dequeueReusableCell(withIdentifier: "order") as! GrapCell
            grapCell.selectionStyle = .none
            grapCell.iconButton.isUserInteractionEnabled = false
        case .release:
            topicCell = tableView.dequeueReusableCell(withIdentifier: "topic") as! TopicCell
            topicCell.selectionStyle = .none
            topicCell.icon.isUserInteractionEnabled = false
            
        }
        
        switch self.relationType ?? .follow{
        case .follow:
            relationCell.actionBtn.setTitle("取消关注", for: .normal)
            relationCell.itemData = self.userList![indexPath.row]
            return relationCell
        case .friend:
            relationCell.actionBtn.setTitle("删除好友", for: .normal)
            relationCell.itemData = self.userList![indexPath.row]
            return relationCell
        case .funs:
            if self.userList![indexPath.row].follow_status == 0{
                relationCell.actionBtn.setTitle("添加关注", for: .normal)
            }else{
                relationCell.actionBtn.setTitle("取消关注", for: .normal)
            }
            relationCell.itemData = self.userList![indexPath.row]
            return relationCell
        case .huoKe:
            grapCell.cellData   = self.orderList?[indexPath.row]
            return grapCell
        case .qiangDan:
            oningCell.cellData = self.orderList?[indexPath.row]
            return oningCell
        case .release:
            topicCell.cellObj = self.topicList?[indexPath.row]
            return topicCell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = self.userList?.count ?? 0
        let count2 = self.orderList?.count ?? 0
        let count3 = self.topicList?.count ?? 0
        if count > 0{
            return count
        }else if count2 > 0{
            return count2
        }else if count3 > 0{
            return count3
        }else{
            return 0
        }
        
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if self.relationType == .release{
//            var height = 0.0
//            let size = topicList![indexPath.row].summarize.getSize(font: UIFont.systemFont(ofSize: 15), viewWidth: (kScreenW - 30))
//            
//            height = Double(115 + size.height)
//            
//            let imgs = self.topicList![indexPath.row].attachment_value.components(separatedBy: ",")
//            var imgHeight = 0.0
//            if imgs.count != 0{
//                let row = (imgs.count) / 3 + 1
//                //每个Item宽高
//                let W = (Int(kScreenW - 30) - 20)/3
//                let H = W
//                //每行间距
//                let rowMargin = 5
//                imgHeight = Double(row * H + (row + 1) * rowMargin)
//            }
//            
//            return CGFloat(height + imgHeight)
//        }else if self.relationType == .huoKe{
//            return 153
//            
//        }else if self.relationType == .qiangDan{
//            let itemData = self.orderList![indexPath.row]
//            
//            let getStr = JSON.init(parseJSON: (itemData.value)!).rawString()?.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "")
//            let size = getStr?.getSize(font: UIFont.systemFont(ofSize: 15), viewWidth: kScreenW - 30.0)
//            
//            return 153 + (size?.height)!
//        }else{
//            return 80
//        }
//        
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.relationType == .huoKe || self.relationType == .release || self.relationType == .qiangDan{
            return
        }
        let getPage = OpenVC.share.getPageKey(pageType: PAGE_TYPE_PersonInfo, actionType: "PersonInfo")
        getPage?.anyObj = self.userList?[indexPath.row]
        if (getPage != nil) {
            OpenVC.share.goToPage(pageType: (getPage?.page_type)!, pageInfo: getPage)
        }
    }
}
extension RelationsVC{
    // MARK:- 获取数据
    
    func getInfo(){
        let params = NSMutableDictionary()
        params.setValue(20, forKey: "page_context")
        params.setValue(self.page, forKey: "page")
        if self.relationType == .follow{
            ApiUtil.share.getFollowerList(params: params) {[weak self] (status, data, msg) in
                if status == B_ResponseStatus.success{
                    let list  =  UserListModel.deserialize(from: data)?.data
                    if list == nil || list?.count == 0{
                        self?.tableView?.es.stopPullToRefresh()
                        self?.tableView?.es.noticeNoMoreData()
                        return
                    }
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
            ApiUtil.share.getFriendList(params: params, finish: {[weak self] (status, data, msg) in
                if status == B_ResponseStatus.success{
                    let list  =  UserListModel.deserialize(from: data)?.data
                    if list == nil || list?.count == 0{
                        self?.tableView?.es.stopPullToRefresh()
                        self?.tableView?.es.noticeNoMoreData()
                        return
                    }
                    if self?.page == 1{
                        self?.userList = list
                    }else{
                        self?.userList = (self?.userList)! + list!
                        
                    }
                }
                DispatchQueue.main.async {
                    self?.tableView?.reloadData()
                    self?.tableView?.es.stopPullToRefresh()
                    self?.tableView?.es.stopLoadingMore()
                }
            })
        }else if self.relationType == .funs{
            ApiUtil.share.getFunsList(params: params, finish: {[weak self] (status, data, msg) in
                if status == B_ResponseStatus.success{
                    let list  =  UserListModel.deserialize(from: data)?.data
                    if list == nil || list?.count == 0{
                        self?.tableView?.es.stopPullToRefresh()
                        self?.tableView?.es.noticeNoMoreData()
                        return
                    }
                    if self?.page == 1{
                        self?.userList = list
                    }else{
                        self?.userList = (self?.userList)! + list!
                    }
                }
                DispatchQueue.main.async {
                    self?.tableView?.reloadData()
                    self?.tableView?.es.stopPullToRefresh()
                    self?.tableView?.es.stopLoadingMore()
                }
            })
        }else if self.relationType == .release{
            ApiUtil.share.getCreatedInvitationListByUser(params: params, finish: {[weak self] (status, data, msg) in
                if status == B_ResponseStatus.success{
                    let tmpList = TopicModel.deserialize(from: data)?.data
                    if tmpList == nil || tmpList?.count == 0{
                        self?.tableView?.es.stopPullToRefresh()
                        self?.tableView?.es.noticeNoMoreData()
                        return
                    }
                    if self?.page == 1{
                        self?.topicList = tmpList
                    }else{
                        self?.topicList = (self?.topicList)! + tmpList!
                    }
                }
                DispatchQueue.main.async {
                    self?.tableView?.reloadData()
                    self?.tableView?.es.stopPullToRefresh()
                    self?.tableView?.es.stopLoadingMore()
                }
            })
        }else if self.relationType == .huoKe{
            params.setValue("0", forKey: "status")
            ApiUtil.share.getUserFormList(params: params){[weak self] (status, data, msg) in
                if status == B_ResponseStatus.success{
                    let datalist  = OrderCModel.deserialize(from: data)?.data
                    if datalist == nil || datalist?.count == 0{
                        self?.tableView?.es.stopPullToRefresh()
                        self?.tableView?.es.noticeNoMoreData()
                        return
                    }
                    if self?.page == 1{
                        self?.orderList = datalist
                    }else{
                        self?.orderList = (self?.orderList)! + datalist!
                    }
                }
                DispatchQueue.main.async {
                    self?.tableView?.reloadData()
                    self?.tableView?.es.stopPullToRefresh()
                    self?.tableView?.es.stopLoadingMore()
                }
            }
        }else if self.relationType == .qiangDan{
            params.setValue("1", forKey: "status")
            ApiUtil.share.getUserFormList(params: params) {[weak self] (status, data, msg) in
                if status == B_ResponseStatus.success{
                let datalist  = OrderCModel.deserialize(from: data)?.data
                    if datalist == nil || datalist?.count == 0{
                        self?.tableView?.es.stopPullToRefresh()
                        self?.tableView?.es.noticeNoMoreData()
                        return
                    }
                if self?.page == 1{
                    self?.orderList = datalist
                }else{
                    self?.orderList = (self?.orderList)! + datalist!
                }
                }
                DispatchQueue.main.async {
                    self?.tableView?.reloadData()
                self?.tableView?.es.stopPullToRefresh()
                self?.tableView?.es.stopLoadingMore()
                }
            }
        }
        
    }
}

