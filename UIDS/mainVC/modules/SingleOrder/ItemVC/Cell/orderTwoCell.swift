//
//  orderTwoCell.swift
//  UIDS
//
//  Created by bai on 2018/1/28.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import SwiftyJSON
import RxCocoa
import RxSwift
import NSObject_Rx

class orderTwoCell: UITableViewCell {


    @IBOutlet weak var eventbt: UIButton!
    @IBOutlet weak var fromName: UILabel!
    @IBOutlet weak var iconButton: UIButton!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var addtime: UILabel!
    
    var cellData: OrderCData? {
        didSet {
            if cellData != nil {
                
                fromName.text = cellData?.classify_name
                addtime.text = cellData?.order_time
                if cellData?.order_user != nil {
                    userName.text = cellData?.order_user.nick_name
                }else {
                    userName.text = cellData?.form_user.nick_name
                }
                
                if cellData?.order_status == 2 {
                    eventbt.setTitle("已完成", for: UIControlState.normal)
                }else if cellData?.order_status == 0 {
                    eventbt.setTitle("已取消", for: UIControlState.normal)
                }
                
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        self.iconButton.layer.cornerRadius = 25
        self.iconButton.layer.masksToBounds = true
        
        self.eventbt.layer.cornerRadius = 6
        self.eventbt.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
