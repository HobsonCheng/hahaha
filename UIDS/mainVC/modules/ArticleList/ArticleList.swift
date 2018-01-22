//
//  ArticleList.swift
//  UIDS
//
//  Created by one2much on 2018/1/15.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

typealias ReloadOver = () -> ()

class ArticleList: BaseModuleView {

    var articleList: [AritcleItem]?
    var reloadOver: ReloadOver?
    //MARK: 创建页面
    func genderView(callback: @escaping ReloadOver){
        
        self.reloadOver = callback

        let params = NSMutableDictionary()
        params.setValue("1", forKey: "page")
        params.setValue("10", forKey: "page_context")
        params.setValue("51", forKey: "group_id")
        
        ApiUtil.share.getInvitationList(params: params) { [weak self] (status, result, tipString) in
            self?.articleList = AritcleModel.deserialize(from: result)?.data
            self?.genderlist()
        }

    }

    private func genderCellView(itemObj: AritcleItem) -> ArticleListCell {
        
        let cell: ArticleListCell? = ArticleListCell.loadFromXib_Swift() as? ArticleListCell
        cell?.cellObj = itemObj
        cell?.frame = CGRect.init(x: 0, y: 0, width: self.width, height: 44)
        cell?.textLabel?.text = itemObj.title
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell!
    }
    
    private func genderlist(){
        
        for item in self.articleList!{
            
            let cell = self.genderCellView(itemObj: item)
            cell.top = self.height + 0.5
            self.addSubview(cell)
            self.height = cell.bottom
        }
        
        self.reloadOver?()
    }
}
