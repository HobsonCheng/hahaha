//
//  UserUtil.swift
//  UIDS
//
//  Created by one2much on 2018/1/19.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

private let MY_APP_USER_INFO = "MY_APP_USER_INFO"


class UserUtil: NSObject {

    var appUserInfo: UserInfoData?
    
    //存储登录信息
    static let share =  UserUtil()
    
    override init() {
        super.init()
        self.getUserInfo()
    }
    
    //MARK: 是否登录
    static func isValid() -> Bool {
        
        if (UserUtil.share.appUserInfo != nil) {
            return true
        }
        return false
    }
    
    //MARK: 存储登录用户信息
    func saveUser(userInfo: String?) {
        if (userInfo?.isEmpty)! {
            return
        }
        ZZDiskCacheHelper.saveObj(MY_APP_USER_INFO, value: userInfo)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] _ in
            self?.getUserInfo()
        }
    }

    func getUserInfo(){
        ZZDiskCacheHelper.getObj(MY_APP_USER_INFO) { [weak self] (obj) in
            if (obj != nil){
                self?.appUserInfo = UserInfoModel.deserialize(from: String.init(format: "%@", obj as! CVarArg))?.data
            }else {
                self?.appUserInfo = nil
            }
        }
    }
    
    func removerUser(){
        ZZDiskCacheHelper.saveObj(MY_APP_USER_INFO, value: nil)
    }
    
}
