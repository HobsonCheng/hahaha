//
//  OrderVC.swift
//  UIDS
//
//  Created by one2much on 2018/1/25.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

public enum ORDER_TYPE: Int {
    case grab = 1 //抢单
    case oning //正在进行
    case over //完成
}

class OrderVC: BaseNameVC {

    var orderType: ORDER_TYPE? = ORDER_TYPE.grab
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
