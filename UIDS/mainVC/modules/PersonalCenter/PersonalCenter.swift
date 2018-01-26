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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.genderView();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func genderView(){
        
        header = (Bundle.main.loadNibNamed("JFProfileHeaderView", owner: nil, options: nil)?.last as! JFProfileHeaderView)
        header?.initView()
        header?.delegate = self
        header?.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height:  200)
        self.height = (header?.bottom)!
        self.addSubview(header!)
        
        self.getInfo()
    }
    
    override func reloadViewData() -> Bool {
        
        self.getInfo()

        return false
    }
    
    func getInfo() {
        
        ApiUtil.share.getInfo(params: NSMutableDictionary()) { [weak self] (status, data, msg) in
            let userInfo = UserUtil.share.appUserInfo
            self?.header?.nameLabel.text = userInfo?.nick_name
            
            if userInfo?.relations.count == 0 {
                
            }else {
                self?.header?.showMenu(list: (userInfo?.relations)!)
            }
        }
        
    }
    
}

extension PersonalCenter: JFProfileHeaderViewDelegate{
    
    func didTappedAvatarButton() {
        
        if UserUtil.isValid() {
            
        }else {
            
            let gotoLogin = LoginView.init(name: "LoginView")
            VCController.push(gotoLogin!, with: VCAnimationBottom.defaultAnimation())
            
        }
        
    }
    
    func didTappedCollectionButton() {
        
    }
    
    func didTappedCommentButton() {
        
    }
    
    func didTappedInfoButton() {
        
    }
    
    func reloadViewSize() {
//        self.height = (header?.bottom)!
        self.reloadCell?()
    }
}
