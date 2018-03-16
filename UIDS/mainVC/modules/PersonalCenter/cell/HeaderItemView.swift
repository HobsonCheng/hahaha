//
//  HeaderItemView.swift
//  YJ
//
//  Created by Hobson on 2018/3/13.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
//import Font_Awesome_Swift

protocol HeaderItemProtocol {
    func didClickItemButton(sender:HeaderItemView)
}
class HeaderItemView: UIView {
    
    var button : UIButton?
    var lable : UILabel?
    var iconCode : String?
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
            case .chat:
                self.lable?.text = "私聊"
            default :
                self.lable?.text = "其他"
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
            $0.setYJIcon(icon: .cart, forState: .normal)
            $0.backgroundColor = UIColor.init(hexString: relation.color)
            $0.rx.tap.do(onNext: {
                self.delegate?.didClickItemButton(sender: self)
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
//        if let code = iconCode{
//            self.button?.setYJIcon(icon: YJType(rawValue:iconCode), iconSize: 25, forState: .normal)
//            self.button?.setYJIconWithCode(iconCode: code, forState: .normal)
//        }
        
        switch (self.type!){
        case .follower:
            self.button?.setYJIcon(icon: .follow, iconSize: 25, forState: .normal)
        case .funs:
            self.button?.setYJIcon(icon: .funs, iconSize: 25, forState: .normal)
        case .huoKe:
            self.button?.setYJIcon(icon: .users, iconSize: 25, forState: .normal)
        case .oder:
            self.button?.setYJIcon(icon: .eGrab0Order, iconSize: 25, forState: .normal)
        case .deletFriend,.addFriend:
            self.button?.setYJIcon(icon: .funs2, iconSize: 25, forState: .normal)
        case .addFollower,.deleteFollower:
            self.button?.setYJIcon(icon: .follow4, iconSize: 25, forState: .normal)
        case .chat:
            self.button?.setYJIcon(icon: .comment2, iconSize: 25, forState: .normal)
        case .release:
            self.button?.setYJIcon(icon: .release, iconSize: 25, forState: .normal)
        case .friend:
            self.button?.setYJIcon(icon: .users4, iconSize: 25, forState: .normal)
        default:
            self.button?.setYJIcon(icon: .cart, iconSize: 25, forState: .normal)
        }
        self.addSubview(self.button!)
        self.addSubview(self.lable!)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
