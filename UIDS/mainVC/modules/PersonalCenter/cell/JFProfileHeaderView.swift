//
//  JFProfileHeaderView.swift
//  BaoKanIOS
//
//  Created by zhoujianfeng on 16/5/20.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit
//import Font_Awesome_Swift
import Then
import RxSwift
protocol JFProfileHeaderViewDelegate {
    
    func didTappedAvatarButton()
    func didTappedChatButton()
    func didTappedFollowerButton()
    func didTappedFunsButton()
    func didTappedFriendsButton()
    func didTappedAddFriendButton(type:String)
    func didTappedAddFollowButton(type:String)
    func didTappedHuoke()
    func didTappedQiangdan()
    func reloadViewSize()
    func didTappedReleaseButton()
}
enum HeaderItemTyep:Int {
    case follower = 10
    case funs = 11
    case huoKe = 17
    case oder = 18
    case friend = 12
    case addFriend = 889
    case deletFriend = 886
    case addFollower = 998
    case deleteFollower = 996
    case chat = 666
    case release = 8
    case other
}
class JFProfileHeaderView: UIView {
    
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var autyHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var menuView: UIView!
    // 声明属性
    var buttons = [UIButton]()
    var itemViews =  [HeaderItemView]()
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
        if list.count == 0 {
            return
        }
        self.height = 0
        self.menuView.removeAllSubviews()
        self.menuView.width = kScreenW
        var col = 5
        let nums = list.count
        
        if nums <= 5 {
            col = nums
        }
        
        // 设置格子的高和宽
        self.image = UIImage(named: "comment_profile_mars.png")
        let heigth:CGFloat = 90
        let width:CGFloat = 90
        
        
        let hMargin:CGFloat = (kScreenW - (CGFloat(col) * width)) / CGFloat((col+1))
        let vMargin:CGFloat = 10
        
        var row:Int = 0
        
//        var getHeight: CGFloat! = 0.0
        
        for i in 0..<nums {
            
            let item = list[i]
            if i != 0 {
                if i%col == 0 {
                    row = row + 1
                }
            }
            
            let x:CGFloat = hMargin + (width + hMargin) * CGFloat(i%col)
            let y:CGFloat = vMargin + (heigth + vMargin) * CGFloat(row)
            
            
            let itemview = HeaderItemView().then({
                $0.frame = CGRect.init(x: x, y: y, width: width, height: heigth)
                $0.delegate = self
                $0.iconCode = item.icon
                $0.setUI(type: HeaderItemTyep(rawValue: item.relation_type!)!, relation: item)
            })
            
            self.itemViews.append(itemview)
            
            self.menuView.addSubview(itemview)
            self.menuView.height = itemview.bottom + 10
        }
//        self.autyHeight.constant = getHeight!
        self.height = self.menuView.bottom
    
        self.delegate?.reloadViewSize()
        
        
    }
}
extension JFProfileHeaderView:HeaderItemProtocol{
    
    func didClickItemButton(sender: HeaderItemView){
        switch sender.type! {
        case .follower:
            self.delegate?.didTappedFollowerButton()
        case .funs:
            self.delegate?.didTappedFunsButton()
        case .huoKe:
            self.delegate?.didTappedHuoke()
        case .oder:
            self.delegate?.didTappedQiangdan()
        case .friend:
            self.delegate?.didTappedFriendsButton()
        case .addFriend:
            self.delegate?.didTappedAddFriendButton(type: "添加好友")
            sender.type = .deletFriend
        case .deletFriend:
            self.delegate?.didTappedAddFriendButton(type: "删除好友")
            sender.type = .addFriend
        case .addFollower:
            self.delegate?.didTappedAddFollowButton(type: "关注")
            sender.type = .deleteFollower
        case .deleteFollower:
            self.delegate?.didTappedAddFollowButton(type: "取消关注")
            sender.type = .addFollower
        case .chat:
            self.delegate?.didTappedChatButton()
        case .release:
            self.delegate?.didTappedReleaseButton()
        case .other: break
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

