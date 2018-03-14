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

class OrderTwoCell: UITableViewCell {


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
                iconButton.sd_setImage(with: URL.init(string: cellData?.form_user.head_portrait ?? ""), for: .normal, completed: nil)
                userName.text = cellData?.form_user.zh_name
                
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
      
        self.iconButton.layer.cornerRadius = 20
        self.iconButton.layer.masksToBounds = true
        
        self.eventbt.layer.cornerRadius = 6
        self.eventbt.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func gotoPersonalCenter(_ sender: Any) {
        let getPage = OpenVC.share.getPageKey(pageType: PAGE_TYPE_PersonInfo, actionType: "PersonInfo")
        getPage?.anyObj = self.cellData?.form_user
        if (getPage != nil) {
            OpenVC.share.goToPage(pageType: (getPage?.page_type)!, pageInfo: getPage)
        }
    }
}
