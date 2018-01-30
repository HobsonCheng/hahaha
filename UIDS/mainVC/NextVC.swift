//
//  NextVC.swift
//  UIDS
//
//  Created by one2much on 2018/1/10.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class NextVC: NaviBarVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let scoket = WSUtil.share()
        scoket.delegate = self
        scoket.connectSever()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension NextVC: WSUtilDelegate {
    func callBackOrderStaus(order: NoticObj?, cancel: Bool) {
    }
    
    func websocketDidConnect(sock: WSUtil) {
        
    }
    
    func websocketDidDisconnect(socket: WSUtil, error: NSError?) {
        
    }
    
    func websocketDidReceiveMessage(socket: WSUtil, text: String) {
        
    }
    
    func websocketDidReceiveData(socket: WSUtil, data: NSData) {
        
    }

}
