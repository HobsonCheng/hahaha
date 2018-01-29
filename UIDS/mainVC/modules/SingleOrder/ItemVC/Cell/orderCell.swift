//
//  orderCell.swift
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



class orderCell: UITableViewCell {

    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var overButton: UIButton!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var fromName: UILabel!
    @IBOutlet weak var iconButton: UIButton!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var addtime: UILabel!
    
    
//    public struct EventData {
//        let eventType = 0
//        let cellObj = OrderCData()
//    }
//
//    var changeEvent: Variable<EventData>
//
    
    var cellData: OrderCData? {
        didSet {
            if cellData != nil {
                content.text = ""
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
        self.iconButton.layer.cornerRadius = 25
        self.iconButton.layer.masksToBounds = true
        
        self.overButton.layer.cornerRadius = 6
        self.overButton.layer.masksToBounds = true
        
        self.cancelButton.layer.cornerRadius = 6
        self.cancelButton.layer.masksToBounds = true
        
        self.overButton.rx.tap.do(onNext: { [weak self] in
            
            let params = NSMutableDictionary()
            params.setValue(self?.cellData?.id ?? "", forKey: "order_id")
            
            ApiUtil.share.confirmSubscribe(params: params, fininsh: { [weak self] (status, data, msg) in
                
                Util.msg(msg: "订单完成", 2)
                
//                var eventData = EventData.init(eventType: 1, cellObj: (self?.cellData)!)
//                self?.changeEvent.value = eventData
                
            })
            
        }).subscribe().disposed(by: rx.disposeBag)
        
        
        self.cancelButton.rx.tap.do(onNext: { [weak self] in
            
            let params = NSMutableDictionary()
            params.setValue(self?.cellData?.id ?? "", forKey: "order_id")
            params.setValue(self?.cellData?.pid ?? "", forKey: "form_pid")
            
            ApiUtil.share.cancelOrderSubscribe(params: params, fininsh: { [weak self] (status, data, msg) in
                
                Util.msg(msg: "订单已取消", 2)
                
//                var eventData = EventData.init(eventType: 2, cellObj: (self?.cellData)!)
//                self?.changeEvent.value = eventData
                
            })
            
        }).subscribe().disposed(by: rx.disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
