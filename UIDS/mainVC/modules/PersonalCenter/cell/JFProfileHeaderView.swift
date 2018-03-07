//
//  JFProfileHeaderView.swift
//  BaoKanIOS
//
//  Created by zhoujianfeng on 16/5/20.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

protocol JFProfileHeaderViewDelegate {
    
    func didTappedAvatarButton()
    func didTappedCollectionButton()
    func didTappedCommentButton()
    func didTappedInfoButton()
    func reloadViewSize()
}

class JFProfileHeaderView: UIView {

    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var autyHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var menuView: UIView!
    // 声明属性
    var button :UIButton?
    var image :UIImage?
    
    func initView() {
        self.backgroundColor = Util.getNavBgColor()
    }

    var delegate: JFProfileHeaderViewDelegate?
    
    @IBAction func didTappedAvatarButton() {
        delegate?.didTappedAvatarButton()
    }
    
    
    func showMenu(list: [Relation]) {

        self.menuView.removeAllSubviews()
        
        var col = 5
        let nums = list.count
        
        if nums <= 5 {
            col = nums
        }

        // 设置格子的高和宽
        self.image = UIImage(named: "comment_profile_mars.png")
        let heigth:CGFloat = 60
        let width:CGFloat = 60
        
        // 设置格子的间距
        let screenSize:CGSize = self.menuView.frame.size
        
        let hMargin:CGFloat = (screenSize.width - (CGFloat(col) * width)) / CGFloat((col+1))
        let vMargin:CGFloat = 10
        
        var row:Int = 0
        
        var getHeight: CGFloat? = 0.0
        
        for i in 0..<nums {
            
            let item = list[i]
            
            self.button = UIButton()
//            self.button!.setFAIcon(icon: FAType.FAAddressCard, iconSize: 20, forState: UIControlState.normal)
            self.button?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            self.button?.setTitle(item.relation_name, for: UIControlState.normal)
            self.button?.layer.cornerRadius = 30
            self.button?.layer.masksToBounds = true
            self.button?.backgroundColor = UIColor.init(hexString: item.color)
            self.button?.addTarget(self , action: #selector(touchMenuBtn(btn:)), for: UIControlEvents.touchUpInside)
            
            
            if i != 0 {
                if i%col == 0 {
                    row = row + 1
                }
            }


            let x:CGFloat = hMargin + (width + hMargin) * CGFloat(i%col)
            let y:CGFloat = vMargin + (heigth + vMargin) * CGFloat(row)
            
            self.button!.frame = CGRect.init(x: x, y: y, width: width, height: heigth)
            self.menuView.addSubview(self.button!)
            
            getHeight = (self.button?.bottom)! + 10
        }
        
        self.autyHeight.constant = getHeight!
        
        self.height = getHeight! + 135
        
        self.delegate?.reloadViewSize()
        
        
    }
    
}
extension JFProfileHeaderView{
    @objc func touchMenuBtn(btn:UIButton){
        let text = (btn.titleLabel?.text)!
        switch text {
        case "关注":
            let params = NSMutableDictionary()
            let userInfo = UserUtil.share.appUserInfo
            params.setValue(userInfo?.uid, forKey: "user_id")
            params.setValue(20, forKey: "page_context")
            params.setValue(0, forKey: "feed_type")
            params.setValue(1,forKey: "page")
            ApiUtil.share.getMessagePool(params: params, finish: { (status, data, msg) in
                
            })
        case "粉丝":
            print("点击了粉丝")
        case "好友":
            print("点击了好友")
        default:
            print("点击了其他")
        }
    }
}
