//
//  RegVCService.swift
//  UIDS
//
//  Created by one2much on 2018/1/19.
//  Copyright © 2018年 one2much. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

//注册发起
class RegVCService {

    let loginBtnEnable: Driver<Bool>
    let loginResult: Driver<Bool>
    
    
    init(input: (userName: UITextField,pwd: UITextField,pwd2: UITextField, nickName: UITextField,codeNum: UITextField, regButton: UIButton), codekey: String) {
       
        let accountDriver = input.userName.rx.text.orEmpty.asDriver()
        let passwordDriver = input.pwd.rx.text.orEmpty.asDriver()
        let password2Driver = input.pwd2.rx.text.orEmpty.asDriver()
        let nickNameDriver = input.nickName.rx.text.orEmpty.asDriver()
        let codeDriver = input.codeNum.rx.text.orEmpty.asDriver()
        let regButtonDriver = input.regButton.rx.tap.asDriver()
        
        let accountAndPassword = Driver.combineLatest(accountDriver, passwordDriver, password2Driver,nickNameDriver,codeDriver) {
            
            return ($0, $1, $2, $3, $4)
        }
        
        
        loginBtnEnable = accountAndPassword.flatMap({ (user,pwd,pwd2,nick,code) in
        
            //处理逻辑
            if user.isEmpty || pwd.isEmpty || pwd2.isEmpty || nick.isEmpty || code.isEmpty {
                return Observable.just(false).asDriver(onErrorJustReturn: false)
            }
            if pwd != pwd2 {
                return Observable.just(false).asDriver(onErrorJustReturn: false)
            }
            
            return Observable.just(true).asDriver(onErrorJustReturn: false)
        })
        
        loginResult = regButtonDriver.withLatestFrom(accountAndPassword).flatMapLatest({ (user,pwd,pwd2,nick,code) in
            
            let params = NSMutableDictionary()
            params.setValue(user, forKey: "username")
            params.setValue(pwd, forKey: "password")
            params.setValue(nick, forKey: "zh_name")
            params.setValue(code, forKey: "auth_code")
            params.setValue(codekey, forKey: "code_key")
            
            ApiUtil.share.userRegist(params: params, fininsh: { (status, data, msg) in
               
                
                Util.msg(msg: "注册成功", 2)
                
                UserUtil.share.saveUser(userInfo: data)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    
                    VCController.pop(with: VCAnimationClassic.defaultAnimation())
                };
            })
            

            return Observable.just(false).asDriver(onErrorJustReturn: false)
        })
    
    }
    
}
