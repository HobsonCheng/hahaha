//
//  HeaderItemView.swift
//  UIDS
//
//  Created by Hobson on 2018/3/13.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

protocol HeaderItemProtocol {
    func didClickItemButton(type:HeaderItemTyep)
}
class HeaderItemView: UIView {
    
    var button : UIButton?
    var lable : UILabel?
    var type : HeaderItemTyep?{
        didSet{
            switch type!{
            case HeaderItemTyep.deletFriend:
                self.lable?.text = "删除好友"
            case HeaderItemTyep.addFriend:
                self.lable?.text = "添加好友"
            case HeaderItemTyep.addFollower:
                self.lable?.text = "添加关注"
            case HeaderItemTyep.deleteFollower:
                self.lable?.text = "取消关注"
            default:
                self.lable?.text = " "
            }
            
        }
    }
    var relation : Relation?
    var delegate : HeaderItemProtocol?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    func setUI(type:HeaderItemTyep,relation:Relation){
        self.type = type
        self.button = UIButton().then({
            $0.setFAIcon(icon: FAType.FAAddressCard, forState: .normal)
            $0.backgroundColor = UIColor.init(hexString: relation.color)
            $0.rx.tap.do(onNext: {
                self.delegate?.didClickItemButton(type: self.type!)
            }).asObservable().subscribe().disposed(by: rx.disposeBag)
            $0.width = 60
            $0.left = 15
            $0.height = 60
            $0.layer.cornerRadius = 30
            $0.layer.masksToBounds = true
        })
        self.lable = UILabel().then({
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.text = relation.relation_name
            $0.width = 90
            $0.textAlignment = NSTextAlignment.center
            $0.textColor = kThemeWhiteColor
            $0.top = 70
            $0.height = 15
        })
        switch (self.type!){
        case .follower:
            self.button?.setFAIcon(icon: .FAExchange,iconSize: 18,forState: .normal)
        case .funs:
            self.button?.setFAIcon(icon: .FAUsers, iconSize: 18, forState: .normal)
        case .huoKe:
            self.button?.setFAIcon(icon: .FAPodcast, iconSize: 18, forState: .normal)
        case .oder:
            self.button?.setFAIcon(icon: .FAWpforms, iconSize: 18, forState: .normal)
        default:
            self.button?.setFAIcon(icon: FAType.FAAddressCard, forState: .normal)
        }
        self.addSubview(self.button!)
        self.addSubview(self.lable!)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
