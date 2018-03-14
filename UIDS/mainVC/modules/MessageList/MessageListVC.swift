//
//  MessageListVCViewController.swift
//  UIDS
//
//  Created by Hobson on 2018/3/2.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class MessageListVC: NaviBarVC {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let parmas = NSMutableDictionary()
        parmas.setValue(1, forKey: "page")
        parmas.setValue(20, forKey: "page_context")
        ApiUtil.share.getNotificationList(params: parmas) { (status, data, msg) in
            
        }
        self.naviBar().setTitle("消息列表")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
