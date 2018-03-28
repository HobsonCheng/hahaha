//
//  TopicList.swift
//  UIDS
//
//  Created by bai on 2018/1/21.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class TopicList: BaseModuleView {
    
    var groupItem: GroupData?
    
    private var page: Int?
    var groupList: [TopicData]?
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
    func genderList(callback:  @escaping ReloadOver) {
        
        self.reloadOver = callback
        self.page = 1
        
        self.request()
        
    }
    
    func request(){
        let vc = VCController.getTopVC()
        if self.page == 1{
            
            vc?.startLoadEmpty(nil)
        }
        
        let params = NSMutableDictionary()
        params.setValue(self.page, forKey: "page")
        params.setValue("20", forKey: "page_context")
        params.setValue(self.groupItem?.name, forKey: "name")
        params.setValue(self.groupItem?.id, forKey: "cms_group_id")
        params.setValue(self.groupItem?.pid, forKey: "group_pid")
        ApiUtil.share.getInvitationList(params: params) { [weak self] (status, data, msg) in
            let tmpList: [TopicData]! = TopicModel.deserialize(from: data)?.data
            
            if self?.page == 1{
                self?.height = 0
                self?.removeAllSubviews()
                self?.groupList = tmpList
            }else {
                self?.groupList = (self?.groupList)! + tmpList
            }
            self?.refreshES?()
            
            self?.genderlist(moveList: tmpList!)
            vc?.stopLoadEmpty()
        }
        
    }
    func reload(){
        let params = NSMutableDictionary()
        let context = self.page! * 20
        params.setValue(1, forKey: "page")
        params.setValue(context, forKey: "page_context")
        params.setValue(self.groupItem?.name, forKey: "name")
        params.setValue(self.groupItem?.id, forKey: "cms_group_id")
        params.setValue(self.groupItem?.pid, forKey: "group_pid")
        ApiUtil.share.getInvitationList(params: params) { [weak self] (status, data, msg) in
            let tmpList: [TopicData]! = TopicModel.deserialize(from: data)?.data
            self?.height = 0
            self?.removeAllSubviews()
            self?.groupList = tmpList
            self?.refreshES?()
            self?.genderlist(moveList: tmpList)
        }
    }
    
    private func genderlist(moveList: [TopicData]!){
        
        for item in moveList!{
            
            let cell = self.genderCellView(itemObj: item)
            cell.top = self.height + 0.5
            self.addSubview(cell)
            self.height = cell.bottom
        }
        
        self.reloadOver?()
    }
    private func genderCellView(itemObj: TopicData) -> TopicCell {
        
        let cell: TopicCell? = TopicCell.loadFromXib_Swift() as? TopicCell
        cell?.cellObj = itemObj
        cell?.frame = CGRect.init(x: 0, y: 0, width: self.width, height: 125)
        
        let size = itemObj.summarize.getSize(font: (cell?.content.font)!, viewWidth: (cell?.content.width)!)
        
        cell?.height = 115 + size.height
        
        if itemObj.attachment_value.count != 0 {
            cell?.height = (cell?.height)! + (cell?.imgViewHeight.constant)!
        }
        
        return cell!
    }
}
