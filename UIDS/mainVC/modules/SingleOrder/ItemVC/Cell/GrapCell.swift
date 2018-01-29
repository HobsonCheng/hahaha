//
//  GrapCell.swift
//  UIDS
//
//  Created by one2much on 2018/1/25.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import SwiftyJSON
import RxCocoa
import RxSwift
import NSObject_Rx

class GrapCell: UITableViewCell {

    
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var eventbt: UIButton!
    @IBOutlet weak var fromName: UILabel!
    @IBOutlet weak var iconButton: UIButton!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var addtime: UILabel!
    
    var cellData: OrderCData? {
        didSet {
            if cellData != nil {
                
                let getStr = JSON.init(parseJSON: (cellData?.value)!).rawString()?.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "")
                
                content.text = getStr
                fromName.text = cellData?.classify_name
                addtime.text = cellData?.order_time
                if cellData?.order_user != nil {
                    userName.text = cellData?.order_user.nick_name
                }else {
                    userName.text = cellData?.form_user.nick_name
                }
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        self.iconButton.layer.cornerRadius = 25
        self.iconButton.layer.masksToBounds = true
        
        self.eventbt.layer.cornerRadius = 6
        self.eventbt.layer.masksToBounds = true
        
        
    
        self.eventbt.rx.tap.do(onNext: {[weak self] in //触发点击抢单
            
            let params = NSMutableDictionary()
            params.setObject(self?.cellData?.id ?? "", forKey: "form_id" as NSCopying)
            params.setObject(self?.cellData?.pid ?? "", forKey: "form_pid" as NSCopying)
            
            ApiUtil.share.orderSubscribe(params: params, fininsh: { (status, data, msg) in
                Util.msg(msg: "抢单成功", 2)
            })
            
        }).subscribe().disposed(by: rx.disposeBag)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}