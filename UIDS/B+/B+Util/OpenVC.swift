//
//  OpenVC.swift
//  UIDS
//
//  Created by one2much on 2018/1/19.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

let PAGE_TYPE_login = "login"
let PAGE_TYPE_custom = "custom"
let PAGE_TYPE_default = "default"
let PAGE_TYPE_news = "news"
let PAGE_TYPE_TopicList = "TopicList"
let PAGE_TYPE_navLeft = "navLeft"
let PAGE_TYPE_navRight = "navRight"
let PAGE_TYPE_AppSet = "AppSet"
let PAGE_TYPE_PersonInfo = "PersonInfo"
let PAGE_TYPE_PerSonList = "PerSonList"
let PAGE_TYPE_CustomerOrderList = "CustomerOrderList"
let PAGE_TYPE_CustomerList = "CustomerList"


class OpenVC: NSObject {

    var pageList: [PageInfo]?
    
    static let share = OpenVC()
    
    override init() {
        super.init()
        self.getPageList()
    }
    
    //MARK: -获取所有页面list
    func getPageKey(pageType: String?, actionType: String?) ->  PageInfo?{

        var tmpPageInfo: PageInfo?
        for item in self.pageList!.enumerated() {
            if item.element.action_type == actionType && item.element.page_type == pageType {
                tmpPageInfo = item.element
                break
            }
            //迭代子元素，查找页面信息
            if let items = item.element.child{
                for it in items{
                   if it.action_type == actionType && it.page_type == pageType{
                        tmpPageInfo = it
                        break
                    }
                }
            }
        }
        
        return tmpPageInfo
    }
    
    //MARK: - 打开page
    func goToPage(pageType: String,pageInfo: PageInfo?) {
        
        switch pageType {
        case PAGE_TYPE_login:
            
            if UserUtil.isValid() {
                let appset = AppSet.init(name: "AppSet")
                VCController.push(appset!, with: VCAnimationClassic.defaultAnimation())
            }else {
                let nextv = LoginView.init(name: "LoginView")
                VCController.push(nextv!, with: VCAnimationBottom.defaultAnimation());
            }
            
            break
        case PAGE_TYPE_custom:
            Util.msg(msg: "hybrid - 牛逼", 1)
            break
        case PAGE_TYPE_news:
            let detail = NewsDetailVC.init(name: "DetatilVC")
            detail?.pageData = pageInfo
            VCController.push(detail!, with: VCAnimationClassic.defaultAnimation())
        case PAGE_TYPE_navLeft:
            if pageInfo?.action_type == "AppSet" {
                let appset = AppSet.init(name: "AppSet")
                appset?.pageData = pageInfo
                VCController.push(appset!, with: VCAnimationClassic.defaultAnimation())
            }else{
                let rootVC = RootVC.init(name: "RootVC")
                rootVC?.pageData = pageInfo
                VCController.push(rootVC!, with: VCAnimationClassic.defaultAnimation())
            }
            break
        case PAGE_TYPE_navRight:
            if pageInfo?.action_type == "AppSet" {
                let appset = AppSet.init(name: "AppSet")
                appset?.pageData = pageInfo
                VCController.push(appset!, with: VCAnimationClassic.defaultAnimation())
            }else{
                let rootVC = RootVC.init(name: "RootVC")
                rootVC?.pageData = pageInfo
                VCController.push(rootVC!, with: VCAnimationClassic.defaultAnimation())
            }
            break
        case PAGE_TYPE_AppSet:
            let appset = AppSet.init(name: "AppSet")
            appset?.pageData = pageInfo
            VCController.push(appset!, with: VCAnimationClassic.defaultAnimation())
            break
        default:
            let rootVC = RootVC.init(name: "RootVC")
            rootVC?.pageData = pageInfo
            VCController.push(rootVC!, with: VCAnimationClassic.defaultAnimation())
            break
            
        }
    }
    
    
    //MARK: - 获取所有页面信息
    private func getPageList() {//[weak self] 
        ApiUtil.share.getPageList { [weak self] (status, data, msg) in
            self?.pageList = PageListModel.deserialize(from: data)?.data
        }
    }
    
}
