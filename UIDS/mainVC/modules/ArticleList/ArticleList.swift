//
//  ArticleList.swift
//  UIDS
//
//  Created by one2much on 2018/1/15.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

typealias ReloadOver = () -> ()

class ArticleList: UIView {

    var articleList: [AritcleItem]?
    var reloadOver: ReloadOver?
    //MARK: 创建页面
    func genderView(callback: @escaping ReloadOver){
        
        self.reloadOver = callback
        let apiHandler = BRequestHandler.shared
        
        let params = NSMutableDictionary()
        params.setValue("getInvitationList", forKey: "ac")
        params.setValue("cms", forKey: "sn")
        params.setValue("1", forKey: "page")
        params.setValue("10", forKey: "page_context")
        params.setValue("51", forKey: "group_id")
        
        weak var selfWeak = self
        apiHandler.get(APIString: "mt", parameters: params as? [String : Any]) { (status, result, tipString) in
            
            if B_ResponseStatus.success == status {
            
                selfWeak?.articleList = AritcleModel.deserialize(from: result)?.data
                selfWeak?.genderlist()
            }
        }
    }

    private func genderCellView(itemObj: AritcleItem) -> ArticleListCell {
        
        let cell: ArticleListCell? = ArticleListCell.loadFromXib_Swift() as? ArticleListCell
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
