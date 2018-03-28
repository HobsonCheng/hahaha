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
    var articleList: [TopicData]?
    var reloadOver: ReloadOver?
//    var articleCSS: ArticleCSSModel?
    var page : Int = 1
    //MARK: 创建页面
    func genderView(callback: @escaping ReloadOver){
        
        self.reloadOver = callback
        request()

    }
    private func request(){
        let params = NSMutableDictionary()
        params.setValue(self.page, forKey: "page_index")
        params.setValue("20", forKey: "page_context")
        params.setValue(self.model_code, forKey: "code")
        params.setValue(self.pageData.page_key, forKey: "page")
        
        ApiUtil.share.getArticleByModel(params: params) { [weak self] (status, result, tipString) in
            self?.articleList = AritcleModel.deserialize(from: result)?.data ?? [TopicData]()
            self?.genderlist()
        }
    }
    private func genderCellView(itemObj: TopicData) -> ArticleListCell {
        
        let cell: ArticleListCell? = ArticleListCell.loadFromXib_Swift() as? ArticleListCell
        cell?.cellObj = itemObj
        cell?.frame = CGRect.init(x: 0, y: 0, width: self.width, height: 44)
        cell?.textLabel?.text = itemObj.title
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell!
    }
    override func reloadViewData() -> Bool {
        self.page = 1
        request()
        return false
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
