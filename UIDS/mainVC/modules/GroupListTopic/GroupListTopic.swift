//
//  GroupListTopic.swift
//  UIDS
//
//  Created by bai on 2018/1/20.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class GroupListTopic: BaseModuleView {

    private var page: Int?
    var groupList: [GroupData]?
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
        params.setValue(self.page, forKey: "page_index")
        params.setValue("20", forKey: "page_context")
        params.setValue(self.model_code, forKey: "code")
        params.setValue(self.pageData.page_key, forKey: "page")
        
        ApiUtil.share.getGroupByModel(params: params) { [weak self] (status, data, msg) in
            
            let tmpList: [GroupData]! = GroupModel.deserialize(from: data)?.data
            if tmpList != nil {
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
    }
    
    private func genderCellView(itemObj: GroupData) -> GroupCell {
        
        let cell: GroupCell? = GroupCell.loadFromXib_Swift() as? GroupCell
        cell?.cellObj = itemObj
        cell?.showData()
        cell?.frame = CGRect.init(x: 0, y: 0, width: self.width, height: 60)
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell!
    }
    
    private func genderlist(moveList: [GroupData]!){
        
        for item in moveList!{
            
            let cell = self.genderCellView(itemObj: item)
            cell.top = self.height + 0.5
            self.addSubview(cell)
            self.height = cell.bottom
        }
        
        self.reloadOver?()
    }
}

