//
//  GroupListTopic.swift
//  UIDS
//
//  Created by bai on 2018/1/20.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class GroupListTopic: UIView {

    
    var groupList: [GroupData]?
    var reloadOver: ReloadOver?
    
    //MARK: - 生成
    func genderList(callback: @escaping ReloadOver) {
        
        self.reloadOver = callback
        
        
        
        
        
        let params = NSMutableDictionary()
        params.setValue("1", forKey: "page")
        params.setValue("30", forKey: "page_context")
        
        ApiUtil.share.getGroupList(params: params) { [weak self] (status, data, msg) in
            self?.groupList = GroupModel.deserialize(from: data)?.data
            self?.genderlist()
        }
        
        
        let tmplist = NSMutableArray()
        for item in 1...9 {
            let newI = GroupData()
            newI.name = String.init(format: "index_%d", item)
            tmplist.add(newI)
        }
        self.groupList = tmplist as? [GroupData]
        self.genderlist()
        
    }

    private func genderCellView(itemObj: GroupData) -> GroupCell {
        
        let cell: GroupCell? = GroupCell.loadFromXib_Swift() as? GroupCell
        cell?.cellObj = itemObj
        cell?.frame = CGRect.init(x: 0, y: 0, width: self.width, height: 44)
        cell?.textLabel?.text = itemObj.name
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell!
    }
    
    private func genderlist(){
        
        for item in self.groupList!{
            
            let cell = self.genderCellView(itemObj: item)
            cell.top = self.height + 0.5
            self.addSubview(cell)
            self.height = cell.bottom
        }
        
        self.reloadOver?()
    }
}
