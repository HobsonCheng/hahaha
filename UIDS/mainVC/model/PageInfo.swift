//
//  PageInfo.swift
//  UIDS
//
//  Created by one2much on 2018/1/15.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

private let shareModel = PageListInfo()

class PageListInfo: NSObject {
    
    
    public var pageListModel: Array<PageInfo>?
    
    static var shared: PageListInfo {
        return shareModel
    }
    
    fileprivate override init(){
        super.init()
        self.initData()
    }
    
    func initData(){
        
        if !DownData.find_resourse_PageListInfo() {
            return
        };
        
        let file = FileHandle.init(forReadingAtPath: DownData.resoursePathPageListInfo())
        let tmpData = file?.readDataToEndOfFile()
        let jsonStr = String(data: tmpData!, encoding: String.Encoding.utf8)
        
        self.pageListModel = PageListModel.deserialize(from: jsonStr)?.data
    }
}


class PageInfoModel: BaseModel {
    var data: PageInfo?
}

class PageInfo: BaseData{
    
    var page_id: Int?
    var app_id: Int?
    var group_id: Int?
    var parent_id: Int?
    var page_type: String?
    var name: String?
    var icon: String?
    var icon_sel: String?
    var action_type: String?
    var child: [PageInfo]?;
    var config_key: String?
    var css_key: String?
    var page_key: String?
    var model_id: String?
    var jump_url: String?
    
    var page_name: String?
    
    
    
    //扩展属性  便于特殊页面获取信息值
    var anyObj: AnyObject?

}

class PageListModel: BaseModel {
    var data: [PageInfo]?
}

