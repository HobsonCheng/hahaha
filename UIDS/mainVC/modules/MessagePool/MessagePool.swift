//
//  MessagePool.swift
//  UIDS
//
//  Created by Hobson on 2018/3/7.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import ReusableKit
import SwiftyJSON
private enum Reusable {
    private static let topicCell = ReusableCell<TopicCell>(nibName: "TopicCell")
}

class MessagePool: BaseModuleView {
    private var page: Int?
    var messagePoolData: [MessagePoolData]?
    var reloadOver: ReloadOver?
    var isOwner = true
    var itemObj: UserInfoData?{
        didSet{
            let userInfo = UserUtil.share.appUserInfo
            if itemObj == nil{
                isOwner = true
                itemObj = userInfo
            }else if itemObj?.uid == userInfo?.uid || itemObj?.user_name == userInfo?.user_name{
                isOwner = true
            }else{
                isOwner = false
            }
            self.request()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.refreshCB = { [weak self] in
            self?.page = (self?.page)! + 1
            self?.request()
        }
        self.autoresizesSubviews = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func reloadViewData()-> Bool {
        self.page = 1
        self.request()
        return false
    }
    
    
    //MARK: - 生成
    func genderList(callback: @escaping ReloadOver,itemObj : UserInfoData?) {
        self.itemObj = itemObj
        self.reloadOver = callback
        self.page = 1
        
    }

    private func request(){
        if isOwner{
            let params = NSMutableDictionary()
            let userInfo = UserUtil.share.appUserInfo
            params.setValue(userInfo?.uid, forKey: "user_id")
            params.setValue(userInfo?.pid, forKey: "user_pid")
            params.setValue(20, forKey: "page_context")
            params.setValue(0, forKey: "feed_type")
            params.setValue(self.page,forKey: "page")
            ApiUtil.share.getMessagePool(params: params, finish: { (status, data, msg) in
                let tmpList:[MessagePoolData]? = MessagePoolModel.deserialize(from: data)?.data
                guard let list = tmpList else{
                    return
                }
                if tmpList?.count == 0 {
                    
                    self.refreshES!()
                    if let vc = self.getVC() as? RootVC{
                        vc.mainView?.es.noticeNoMoreData()
                    }
                }
                if self.page == 1 {
                    self.height = 0
                    self.removeAllSubviews()
                    self.messagePoolData = list
                }else{
                    if let temp = self.messagePoolData{
                       self.messagePoolData =  temp + list
                    }
                }
                self.refreshES?()
                DispatchQueue.main.async {
                    self.genderlist(moveList: list)
                }
            })
        }else{
            let userInfo = itemObj!
            let params = NSMutableDictionary()
            params.setValue(0, forKey: "feed_type")
            params.setValue(20, forKey: "page_context")
            params.setValue(self.page, forKey: "page")
            if userInfo.uid == nil{
                params.setValue(userInfo.appkey, forKey: "appkey")
                params.setValue(userInfo.user_name, forKey: "username")
            }else{
                params.setValue(userInfo.uid, forKey: "user_id")
                params.setValue(userInfo.pid, forKey: "user_pid")
            }

            ApiUtil.share.getOthersMessagePool(params: params, finish: { (status, data, msg) in
                let tmpList:[MessagePoolData]? = MessagePoolModel.deserialize(from: data)?.data
                guard let list = tmpList else{
                    return
                }
                if tmpList?.count == 0 {

                    self.refreshES!()
                    if let vc = self.getVC() as? RootVC{
                        vc.mainView?.es.noticeNoMoreData()
                    }
                }
                if self.page == 1 {
                    self.height = 0
                    self.removeAllSubviews()
                    self.messagePoolData = list
                }else{
                    self.messagePoolData = (self.messagePoolData)! + list
                }
                self.refreshES?()
                DispatchQueue.main.async {
                    self.genderlist(moveList: list)
                }
            })
        }
    }
    
}


//MARK: - 绘制画面
extension MessagePool{
    private func genderlist(moveList: [MessagePoolData]!){
        
        for item in moveList!{
            guard let itemObj = item.object else{
                continue
            }
            let cell : UITableViewCell?
            
            switch item.feed_type ?? 0{
            case 11:
                let itemData = TopicData.deserialize(from: itemObj)
                cell = genderTopicCell(itemObj: itemData!)
            case 15:
                let itemObj = OrderCData.deserialize(from: itemObj)
                cell = genderOrderCell( itemData: itemObj!)
            default:
                continue
            }
            
            cell?.top = self.height + 1
            self.addSubview(cell!)
            self.height = (cell?.bottom)!
        }
        
        self.reloadOver?()
    }
    
    private func genderOrderCell(itemData : OrderCData) -> GrapCell?{
        let cell: GrapCell? = GrapCell.loadFromXib_Swift() as? GrapCell
        cell?.cellData = itemData
        //计算高度
        let getStr = JSON.init(parseJSON: (itemData.value)!).rawString()?.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "")
        let size = getStr?.getSize(font: UIFont.systemFont(ofSize: 15), viewWidth: kScreenW - 30.0)
        let height =  153 - 37 + (size?.height)!
        cell?.iconButton.isUserInteractionEnabled = false
        cell?.height = height
        cell?.width = kScreenW
        return cell
    }
    
    private func genderTopicCell(itemObj: TopicData) -> TopicCell {
        
        let cell: TopicCell? = TopicCell.loadFromXib_Swift() as? TopicCell
        cell?.frame = CGRect.init(x: 0, y: 0, width: self.width, height: 125)
        cell?.icon.isUserInteractionEnabled = false
        cell?.cellObj = itemObj
        let size = itemObj.summarize.getSize(font: (cell?.content.font)!, viewWidth: (cell?.content.width)!)
        
        cell?.height = 115 + size.height
        
        if itemObj.attachment_value.count != 0 {
            cell?.height = (cell?.height)! + (cell?.imgViewHeight.constant)!
        }
        return cell!
    }
}
