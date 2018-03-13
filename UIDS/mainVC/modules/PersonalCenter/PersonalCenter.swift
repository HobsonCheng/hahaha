//
//  PersonalCenter.swift
//  UIDS
//
//  Created by one2much on 2018/1/15.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class PersonalCenter: BaseModuleView {
    
    var reloadCell: ReloadOver?
    var header: JFProfileHeaderView?
    var isOwner: Bool = true
    var itemObj: UserInfoData?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.genderView()
        
//        self.layer.masksToBounds = tru
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func genderView(){
        header = (Bundle.main.loadNibNamed("JFProfileHeaderView", owner: nil, options: nil)?.last as! JFProfileHeaderView)
        header?.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height:  200)
        header?.initView()
        header?.delegate = self
        self.addSubview(header!)
        //        setHeaderInfo()
    }
    
    
    func setHeaderInfo() {    //自己的个人中心
        self.isOwner = true
        let params = NSMutableDictionary()
        ApiUtil.share.getInfo(params: params, fininsh: { [weak self](status, data, msg) in
            let userInfo = UserUtil.share.appUserInfo
            self?.header?.nameLabel.text = userInfo?.nick_name
            self?.header?.avatarButton.sd_setImage(with: URL.init(string: (userInfo?.head_portrait ?? "")), for: .normal, completed: nil)
            self?.header?.nameLabel.text = userInfo?.zh_name
            if userInfo?.relations.count == 0 {
                
            }else {
                if let relations = userInfo?.relations{
                    self?.header?.list = relations
                    self?.header?.showMenu()
                }
                
            }
            DispatchQueue.main.async {
                self?.refreshES!()
            }
        })
    }
    func  setOthersHeaderInfo() {//别人的个人中心
        self.isOwner = false
        ApiUtil.share.getRelationInfo(user_id: (itemObj?.uid ?? 0),app_id :itemObj?.pid ?? 0, finish: { (status, data, msg) in
            let info = UserInfoModel.deserialize(from: data)?.data
            self.header?.nameLabel.text = info?.zh_name
            self.header?.avatarButton.sd_setImage(with: URL.init(string: info?.head_portrait ?? ""), for: .normal, completed: nil)
                var relationList =  [Relation]()
                let r1 = Relation()
                if info?.follow_status != 0 {
                    r1.relation_name = "取消关注"
                    
                    r1.relation_type = 996
                }else{
                    r1.relation_name = "添加关注"
                    r1.relation_type = 998
                }
                r1.color = info?.relations[0].color
                let r2 = Relation()
                if info?.is_friend == 1{
                    r2.relation_name = "删除好友"
                    r2.relation_type = 886
                    
                }else{
                    r2.relation_name = "添加好友"
                    r2.relation_type = 889
                }
                relationList.append(r1)
                relationList.append(r2)
            self.header?.list = relationList
            DispatchQueue.main.async { [weak self] in
                self?.header?.showMenu()
                self?.refreshES!()
            }
            self.header?.avatarButton.isUserInteractionEnabled = false

            
        })
    }
    //MARK :- 下拉刷新调用
    override func reloadViewData() -> Bool {
        if isOwner{
            self.setHeaderInfo()
        }else{
            self.setOthersHeaderInfo()
        }
        return false
    }
}

extension PersonalCenter: JFProfileHeaderViewDelegate{
    
    
    func didTappedAvatarButton() {
        
        if UserUtil.isValid() {
            let gotoSet = AppSet.init(name: "SetView")
            VCController.push(gotoSet!, with: VCAnimationClassic.defaultAnimation())
        }else {
            
            let gotoLogin = LoginView.init(name: "LoginView")
            VCController.push(gotoLogin!, with: VCAnimationClassic.defaultAnimation())
            
        }
        
    }
    
    func didTappedCollectionButton() {
        
    }
    
    func didTappedCommentButton() {
        
    }
    
    func didTappedInfoButton() {
        
    }
    func didTappedAddFriendButton(type:String) {
        if type == "添加好友"{
            let dic = NSMutableDictionary()
            dic.setValue("",forKey: "answer")
            dic.setValue(itemObj?.uid, forKey: "friend_uid")
            dic.setValue(itemObj?.pid, forKey: "friend_pid")
            ApiUtil.share.addFriend(params: dic) { (status, data, msg) in
                if status == B_ResponseStatus.success{
                    Util.msg(msg: "添加成功", 1)
                }
            }
        }else{
            let dic = NSMutableDictionary()
            dic.setValue(itemObj?.uid, forKey: "friend_uid")
            dic.setValue(itemObj?.pid, forKey: "friend_pid")
            ApiUtil.share.deleteFriend(params: dic) { (status, data, msg) in
                if status == B_ResponseStatus.success{
                    Util.msg(msg: "已删除", 1)
                }
            }
        }
        
    }
    
    func didTappedAddFollowButton(type : String) {
        if type == "关注"{
            let dic = NSMutableDictionary()
            dic.setValue(itemObj?.uid, forKey: "follow_uid")
            dic.setValue(itemObj?.pid, forKey: "follow_pid")
            ApiUtil.share.addFollower(params: dic) { (status, data, msg) in
                if status == B_ResponseStatus.success{
                    Util.msg(msg: "已添加关注", 1)
                }
            }
        }else{
            let dic = NSMutableDictionary()
            dic.setValue(itemObj?.uid, forKey: "follow_uid")
            dic.setValue(itemObj?.pid, forKey: "follow_pid")
            ApiUtil.share.deleteFollower(params: dic) { (status, data, msg) in
                if status == B_ResponseStatus.success{
                    Util.msg(msg: "已取消关注", 1)
                }
            }
        }
    }
    func didTappedFriendsButton() {
        let vc = RelationsVC()
        vc?.relationType = RelationshipType.friend
        VCController.push(vc!, with: VCAnimationClassic.defaultAnimation())
    }
    func didTappedFollowerButton() {
        let vc = RelationsVC()
        vc?.relationType = RelationshipType.follow
        VCController.push(vc!, with: VCAnimationClassic.defaultAnimation())
    }
    func didTappedFunsButton() {
        let vc = RelationsVC()
        vc?.relationType = RelationshipType.funs
        VCController.push(vc!, with: VCAnimationClassic.defaultAnimation())
    }
    func reloadViewSize() {
        self.height = (self.header?.bottom)!
        self.reloadCell!()
    }
}
