//
//  relationCell.swift
//  UIDS
//
//  Created by Hobson on 2018/3/10.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class RelationCell: UITableViewCell {

    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var icon: UIButton!
    
    var itemData : UserInfoData?{
        didSet{
            setInfo()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.actionBtn.rx.tap.do(onNext: {[weak self] in
                let text = self?.actionBtn.titleLabel?.text! ?? "添加好友"
                switch  text{
                case "添加好友":
                    self?.didTappedFreindButton(type: "添加好友")
                    self?.actionBtn.setTitle("删除好友", for: .normal)
                case "删除好友":
                    self?.didTappedFreindButton(type: "删除好友")
                    self?.actionBtn.setTitle("添加好友", for: .normal)
                case "添加关注":
                    self?.didTappedFollowButton(type: "添加关注")
                    self?.actionBtn.setTitle("取消关注", for: .normal)
                case "取消关注":
                    self?.didTappedFollowButton(type: "取消关注")
                    self?.actionBtn.setTitle("添加关注", for: .normal)
                default:
                    print("点击了其他")
                }
        }).subscribe().disposed(by: rx.disposeBag)
        self.icon.rx.tap.do(onNext: {
            let getPage = OpenVC.share.getPageKey(pageType: PAGE_TYPE_PersonInfo, actionType: "PersonInfo")
            getPage?.anyObj = self.itemData
            if (getPage != nil) {
                OpenVC.share.goToPage(pageType: (getPage?.page_type)!, pageInfo: getPage)
            }
        }).subscribe().disposed(by: rx.disposeBag)
        self.selectionStyle = .none
    }
    func setInfo()  {
        self.nameLabel.text = itemData?.zh_name
        if let urlStr = itemData?.head_portrait{
            if urlStr == "" {
                return 
            }
            self.icon.sd_setImage(with: URL.init(string: urlStr), for: .normal)
        }
    }
    
    @IBAction func portraitClick(_ sender: UIButton) {
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func didTappedFollowButton(type: String) {
        if type == "添加关注"{
            let dic = NSMutableDictionary()
            dic.setValue(itemData?.uid, forKey: "follow_uid")
            dic.setValue(itemData?.pid, forKey: "follow_pid")
            ApiUtil.share.addFollower(params: dic) { (status, data, msg) in
                if status == B_ResponseStatus.success{
                    Util.msg(msg: "已添加关注", 1)
                }
            }
        }else{
            let dic = NSMutableDictionary()
            dic.setValue(itemData?.uid, forKey: "follow_uid")
            dic.setValue(itemData?.pid, forKey: "follow_pid")
            ApiUtil.share.deleteFollower(params: dic) { (status, data, msg) in
                if status == B_ResponseStatus.success{
                    Util.msg(msg: "已取消关注", 1)
                }
            }
        }
    }
    

    func didTappedFreindButton(type: String) {
        if type == "添加好友"{
            let dic = NSMutableDictionary()
            dic.setValue("",forKey: "answer")
            dic.setValue(itemData?.uid, forKey: "friend_uid")
            dic.setValue(itemData?.pid, forKey: "friend_pid")
            ApiUtil.share.addFriend(params: dic) { (status, data, msg) in
                if status == B_ResponseStatus.success{
                    Util.msg(msg: "添加成功", 1)
                }
            }
        }else{
            let dic = NSMutableDictionary()
            dic.setValue(itemData?.uid, forKey: "friend_uid")
            dic.setValue(itemData?.pid, forKey: "friend_pid")
            ApiUtil.share.deleteFriend(params: dic) { (status, data, msg) in
                if status == B_ResponseStatus.success{
                    Util.msg(msg: "已删除", 1)
                }
            }
        }
    }
}
