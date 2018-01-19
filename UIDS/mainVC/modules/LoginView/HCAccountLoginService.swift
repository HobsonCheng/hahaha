//
//  HCAccountLoginService.swift
//  RxXMLY
//
//  Created by sessionCh on 2018/1/3.
//  Copyright © 2018年 sessionCh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HCAccountLoginService {

    // 单例类
    static let shareInstance = HCAccountLoginService()
    private init() {}

    // 验证账号是否合法
    func validationAccount(_ account: String) -> Observable<HCAccountLoginResult> {
        
        if InputValidator.isValidPhone(phoneNum: account) == false {
            return Observable.just(HCAccountLoginResult.failed(message: "账号非法"))
        }
      
        return Observable.just(HCAccountLoginResult.ok(message: "账号合法"))
    }
    
    // 验证密码是否合法
    func validationPassword(_ passsword: String) -> Observable<HCAccountLoginResult> {
        
        if InputValidator.isvalidationPassword(password: passsword) == false {
            return Observable.just(HCAccountLoginResult.failed(message: "密码非法"))
        }
        
        return Observable.just(HCAccountLoginResult.ok(message: "密码合法"))
    }
        
    // 登录请求
    func login(account: String, password: String) -> Observable<HCAccountLoginResult> {
        
        if account.count > 10 {
            return Observable.just(HCAccountLoginResult.ok(message: "登录成功"))
        } else {
            return Observable.just(HCAccountLoginResult.failed(message: "密码错误"))
        }
    }
    
    // 登录按钮是否可用
    func loginBtnEnable(account: String, password: String,codeStr: String) -> Observable<Bool> {
        
        if InputValidator.isValidPhone(phoneNum: account) && InputValidator.isvalidationPassword(password: password) && !(codeStr.isEmpty){
            return Observable.just(true)
        } else {
            return Observable.just(false)
        }
    }
    //在验证吗是否填写
    func chechText(codeStr: String) -> Observable<Bool> {
        if !codeStr.isEmpty {
            return Observable.just(true)
        }else{
            return Observable.just(false)
        }
    }
    
    
    /*
     BQLAuthEngine.single.auth_qq_login(success: { (response) in
     
     print("success")
     
     }) { (error) in
     
     print("error" + error!)
     }
     
     BQLAuthEngine.single.auth_wechat_login(success: { (response) in
     
     print("success")
     
     }) { (error) in
     
     print("error" + error!)
     }
     
     
     
     BQLAuthEngine.single.auth_sina_login(success: { (response) in
     
     print(response!)
     
     }) { (error) in
     
     print("error" + error!)
     }
     
     
     
     
     
     
     
     
     
     
     
     
     */
    
    
}