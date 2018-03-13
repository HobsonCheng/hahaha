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
    var dispose : Disposable?
    
    var cellData: OrderCData? {
        didSet {
            if cellData != nil {
                
                let getStr = JSON.init(parseJSON: (cellData?.value)!).rawString()?.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "")
                
                content.text = getStr
                userName.text = cellData?.user_name
                
                fromName.text = cellData?.classify_name
                iconButton.sd_setImage(with: URL.init(string: cellData?.head_portrait ?? ""), for: UIControlState.normal, completed: nil)
                addtime.text = cellData?.add_time
                
                changebtnTitle(itemData: cellData!)
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
        self.eventbt.setTitle("等待接单", for: .normal)
        
    }
    //根据订单状态切换Title
    func changebtnTitle(itemData : OrderCData){
        let status = itemData.form_status
        if status == 0{
            self.isUserInteractionEnabled = true
            let userInfo = UserUtil.share.appUserInfo
            if itemData.platform_uid == userInfo?.uid{
                dispose?.dispose()
                self.eventbt.setTitle("取消订单", for: .normal)
                dispose = self.eventbt.rx.tap.do(onNext : { [weak self] in
                    let params = NSMutableDictionary()
                    params.setObject(self?.cellData?.id ?? "", forKey: "form_id" as NSCopying)
                    params.setObject(self?.cellData?.pid ?? "", forKey: "form_pid" as NSCopying)
                    ApiUtil.share.cancelSubscribe(params: params, finish: { (status, data, msg) in
                        Util.msg(msg: "取消订单成功",2)
                    })
                    if let messagePool = self?.superview as? MessagePool{
                                _ = messagePool.reloadViewData()
                    }
                }).subscribe()
            }else{
                dispose?.dispose()
                dispose =  self.eventbt.rx.tap.do(onNext: {[weak self] in //触发点击抢单
                    
                    let params = NSMutableDictionary()
                    params.setObject(self?.cellData?.id ?? "", forKey: "form_id" as NSCopying)
                    params.setObject(self?.cellData?.pid ?? "", forKey: "form_pid" as NSCopying)
                    
                    ApiUtil.share.orderSubscribe(params: params, fininsh: { (status, data, msg) in
                        Util.msg(msg: "抢单成功", 2)
                    })
                    
                }).subscribe()
                
            }
            
        }else if status == 1{
            self.eventbt.setTitle((itemData.order_user.zh_name ?? "") + "正在处理您的订单 ►", for: .normal)
            self.eventbt.backgroundColor = UIColor.init(hexString: "#FC614C")
        }else if status == 2{
            self.eventbt.setTitle("您的订单已完成 ✓", for: .normal)
            self.eventbt.backgroundColor = UIColor.init(hexString: "#5A5A5A")
        }else if status == 3{
            self.eventbt.setTitle("已取消 ✕", for: .normal)
            self.eventbt.backgroundColor = UIColor.init(hexString: "#C1C1C1")
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func goPersonCenter(_ sender: UIButton) {
        let getPage = OpenVC.share.getPageKey(pageType: PAGE_TYPE_PersonInfo, actionType: "PersonInfo")
        getPage?.anyObj = self.cellData?.form_user
        if (getPage != nil) {
            OpenVC.share.goToPage(pageType: (getPage?.page_type)!, pageInfo: getPage)
        }
    }
}
