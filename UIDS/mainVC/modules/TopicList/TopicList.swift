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
    
    override func reloadViewData() {
        super.reloadViewData()
        self.page = 1
        self.request()
    }
    
    
    //MARK: - 生成
    func genderList(callback: @escaping ReloadOver) {
        
        self.reloadOver = callback
        self.page = 1
        
        self.request()
        
    }
    
    private func request(){
        let params = NSMutableDictionary()
        params.setValue(self.page, forKey: "page")
        params.setValue("20", forKey: "page_context")
        params.setValue(self.groupItem?.name, forKey: "name")
        params.setValue(self.groupItem?.id, forKey: "group_id")
        ApiUtil.share.getInvitationList(params: params) { [weak self] (status, data, msg) in
            let tmpList: [TopicData]! = TopicModel.deserialize(from: data)?.data

            if self?.page == 1 {
                self?.height = 0
                self?.removeAllSubviews()
                self?.groupList = tmpList
            }else {
                self?.groupList = (self?.groupList)! + tmpList
            }

            self?.refreshES?()

            self?.genderlist(moveList: tmpList!)
        }
    }
    
    private func genderCellView(itemObj: TopicData) -> TopicCell {
        
        let cell: TopicCell? = TopicCell.loadFromXib_Swift() as? TopicCell
        cell?.cellObj = itemObj
        cell?.showData()
        cell?.frame = CGRect.init(x: 0, y: 0, width: self.width, height: 125)
        
        let size = itemObj.summarize.getSize(font: (cell?.content.font)!, viewWidth: (cell?.content.width)!)
        
        cell?.height = 115 + size.height
    
        return cell!
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

}
