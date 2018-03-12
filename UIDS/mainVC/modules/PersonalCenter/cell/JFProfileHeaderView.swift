//
//  JFProfileHeaderView.swift
//  BaoKanIOS
//
//  Created by zhoujianfeng on 16/5/20.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit
import Font_Awesome_Swift
import Then
import RxSwift
protocol JFProfileHeaderViewDelegate {
    
    func didTappedAvatarButton()
    func didTappedCollectionButton()
    func didTappedCommentButton()
    func didTappedFollowerButton()
    func didTappedFunsButton()
    func didTappedFriendsButton()
    func didTappedInfoButton()
    func didTappedAddFriendButton(type:String)
    func didTappedAddFollowButton(type:String)
    func reloadViewSize()
}

class JFProfileHeaderView: UIView {

    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var autyHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var menuView: UIView!
    // 声明属性
    var buttons = [UIButton]()
    var container : UIView?
    var labels =  [UILabel]()
    var image :UIImage?
    var list = [Relation]()
    var delegate: JFProfileHeaderViewDelegate?
   
    @IBAction func didTappedAvatarButton() {
        delegate?.didTappedAvatarButton()
    }
    
    func initView() {
        self.backgroundColor = Util.getNavBgColor()
    }
    
    
    func showMenu() {

        self.menuView.removeAllSubviews()

        var col = 5
        let nums = list.count
        
        if nums <= 5 {
            col = nums
        }

        // 设置格子的高和宽
        self.image = UIImage(named: "comment_profile_mars.png")
        let heigth:CGFloat = 90
        let width:CGFloat = 90
        
        // 设置格子的间距
        let screenSize:CGSize = self.menuView.frame.size
        
        let hMargin:CGFloat = (screenSize.width - (CGFloat(col) * width)) / CGFloat((col+1))
        let vMargin:CGFloat = 10
        
        var row:Int = 0
        
        var getHeight: CGFloat? = 0.0
        
        for i in 0..<nums {
            
            let item = list[i]
            if i != 0 {
                if i%col == 0 {
                    row = row + 1
                }
            }
            
            let x:CGFloat = hMargin + (width + hMargin) * CGFloat(i%col)
            let y:CGFloat = vMargin + (heigth + vMargin) * CGFloat(row)
            
            let button = UIButton().then({
                $0.setFAIcon(icon: FAType.FAAddressCard, forState: .normal)
                $0.tag = item.relation_type
                $0.rx.tap.do(onNext: { [weak self] in
                    self?.touchMenuBtn(tag:(self?.buttons[i].tag)!)
                }).subscribe().disposed(by: rx.disposeBag)
                $0.backgroundColor = UIColor.init(hexString: item.color)
                $0.width = 60
                $0.left = 15
                $0.height = 60
                $0.layer.cornerRadius = 30
                $0.layer.masksToBounds = true
            })
            let lable = UILabel().then({
                $0.font = UIFont.systemFont(ofSize: 15)
                $0.text = item.relation_name
                $0.width = 90
                $0.textAlignment = NSTextAlignment.center
                $0.textColor = kThemeWhiteColor
                $0.top = 70
                $0.height = 15
            })
            self.labels.append(lable)
            self.buttons.append(button)
            self.container = UIView().then({

                $0.frame = CGRect.init(x: x, y: y, width: width, height: heigth)
                $0.addSubview(self.buttons[i])
                $0.addSubview(self.labels[i])
            })
            switch (self.buttons[i].tag ){
            case 10:
                self.buttons[i].setFAIcon(icon: .FAExchange,iconSize: 18,forState: .normal)
            case 11:
                self.buttons[i].setFAIcon(icon: .FAUsers, iconSize: 18, forState: .normal)
            case 17:
                self.buttons[i].setFAIcon(icon: .FAPodcast, iconSize: 18, forState: .normal)
            case 18:
                self.buttons[i].setFAIcon(icon: .FAWpforms, iconSize: 18, forState: .normal)
            default:
                self.buttons[i].setFAIcon(icon: FAType.FAAddressCard, forState: .normal)
            }
            
            self.menuView.addSubview(self.container!)
            self.labels[i].text = item.relation_name
            getHeight = (self.container?.bottom)! + 10
        }
        
        self.autyHeight.constant = getHeight!
        self.height = getHeight! + 135
        
        self.delegate?.reloadViewSize()
        
        
    }
    
}

extension JFProfileHeaderView{
    @objc func touchMenuBtn(tag:Int){
        switch tag {
        case 10:
            self.delegate?.didTappedFollowerButton()
        case 11:
            self.delegate?.didTappedFunsButton()
        case 17:
            gotoPage(pageType: PAGE_TYPE_CustomerOrderList, actionType: "")
        case 18:
            gotoPage(pageType: PAGE_TYPE_CustomerOrderList, actionType: "")
        case 12:
            self.delegate?.didTappedFriendsButton()
        case 889 :
            self.delegate?.didTappedAddFriendButton(type: "添加好友")
            self.labels[1].text = "删除好友"
            self.buttons[1].tag = 886
        case 886:
            self.delegate?.didTappedAddFriendButton(type: "删除好友")
            self.labels[1].text = "添加好友"
            self.buttons[1].tag = 889
        case 998:
            self.delegate?.didTappedAddFollowButton(type: "关注")
            self.labels[0].text = "取消关注"
            self.buttons[0].tag = 996
//        case "双向关注":
//            self.delegate?.didTappedFollowButton(type: "关注")
//            self.labels[0].text = "取消关注"
//            self.list[0].relation_name = "取消关注"
        case 996:
            self.delegate?.didTappedAddFollowButton(type: "取消关注")
            self.labels[0].text = "添加关注"
            self.buttons[0].tag = 998
        default:
            print("点击了其他")
        }
    }
    //跳转
    private func gotoPage(pageType:String,actionType:String){
        let getPage = OpenVC.share.getPageKey(pageType: pageType, actionType: actionType)
        if (getPage != nil) {
            OpenVC.share.goToPage(pageType: (getPage?.page_type)!, pageInfo: getPage)
        }
    }
    
}
