//
//  ArticleList.swift
//  UIDS
//
//  Created by one2much on 2018/1/15.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class ArticleList: UIView {

    //MARK: 创建页面
    func genderView(){
        
        let appinfo = AppInfoData.shared.appModel
        let apiHandler = BRequestHandler.shared
        
        let params = NSMutableDictionary()
        params.setValue("getInvitationList", forKey: "ac")
        params.setValue("cms", forKey: "sn")
        params.setValue("1", forKey: "page")
        params.setValue("20", forKey: "page_context")
        let groudid = String.init(format: "%zd", (appinfo?.group_id)!)
        params.setValue(groudid, forKey: "group_id")
        
        apiHandler.get(APIString: "mt", parameters: params as! [String : Any]) { (status, result, tipString) in
            
        }
        
    }

}
