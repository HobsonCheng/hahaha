//
//  MessagePool.swift
//  UIDS
//
//  Created by Hobson on 2018/3/7.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import ReusableKit

private enum Reusable {
    private static let topicCell = ReusableCell<TopicCell>(nibName: "TopicCell")
}

class MessagePool: BaseModuleView {
    private var page: Int?
    var messagePoolData: [MessagePoolData]?
    var reloadOver: ReloadOver?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.refreshCB = { [weak self] in
            self?.page = (self?.page)! + 1
            self?.request()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func reloadViewData()-> Bool {
        self.page = 1
        self.request()
        return true
    }
    
    
    //MARK: - 生成
    func genderList(callback: @escaping ReloadOver) {
        
        self.reloadOver = callback
        self.page = 1
        
        self.request()
        
    }
    
    private func request(){
        let params = NSMutableDictionary()
        let userInfo = UserUtil.share.appUserInfo
        params.setValue(userInfo?.uid, forKey: "user_id")
        params.setValue(20, forKey: "page_context")
        params.setValue(0, forKey: "feed_type")
        params.setValue(1,forKey: "page")
        ApiUtil.share.getMessagePool(params: params, finish: { (status, data, msg) in
            let tmpList:[MessagePoolData]? = (MessagePoolModel.deserialize(from: data)?.data)
            guard let list = tmpList else{
                return
            }
            if self.page == 1 {
                self.height = 0
                self.removeAllSubviews()
                self.messagePoolData = list
            }else{
                self.messagePoolData = (self.messagePoolData)! + list
            }
            self.refreshES?()
            self.genderlist(moveList: list)
        })
        
    }
    
    private func genderCellView(itemObj: TopicData) -> TopicCell {
        
        let cell: TopicCell? = TopicCell.loadFromXib_Swift() as? TopicCell
        cell?.frame = CGRect.init(x: 0, y: 0, width: self.width, height: 125)
        
        let size = itemObj.summarize.getSize(font: (cell?.content.font)!, viewWidth: (cell?.content.width)!)
        
        cell?.height = 115 + size.height
        
        if itemObj.attachment_value.count != 0 {
            cell?.height = (cell?.height)! + (cell?.imgViewHeight.constant)!
        }
        return cell!
    }
    
    private func genderlist(moveList: [MessagePoolData]!){
        
        for item in moveList!{
            guard let itemObj = item.object else{
                return
            }
            let cell = self.genderCellView(itemObj: itemObj)
            cell.cellObj = item.object
            cell.top = self.height + 0.5
            self.addSubview(cell)
            self.height = cell.bottom
        }
        
        self.reloadOver?()
    }
    

}
