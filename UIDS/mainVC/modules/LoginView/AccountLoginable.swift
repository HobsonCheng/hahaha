//
//  AccountLoginable.swift
//  UIDS
//
//  Created by one2much on 2018/1/17.
//  Copyright © 2018年 one2much. All rights reserved.
//

import Foundation
import UIKit
import Then
import RxSwift
import RxCocoa
import NSObject_Rx
import Font_Awesome_Swift

// MARK:- 事件
struct AccountLoginEvent {
    
    // MARK:- 事件类型
    enum AccountLoginType {
        
        case login
        case forget
        case weixin
        case weibo
        case qq
    }
    
    var type: AccountLoginType
    var title: String?
    
    init(type: AccountLoginType, title: String?) {
        
        self.type = type
        self.title = title
    }
}

public struct Metric {
    
    static let fieldHeight: CGFloat = 45.0
    
    static let tipBtnWidth: CGFloat = 40.0
    static let borderWidth: CGFloat = 1.0
    static let cornerRadius: CGFloat = 3.0
    
    static let fontSize = UIFont.systemFont(ofSize: 18)
    
    static let loginBtnHeight: CGFloat = 40.0
    static let loginBtnFontSize = UIFont.systemFont(ofSize: 16)
    static let forgetFontSize = UIFont.systemFont(ofSize: 13)
    static let loginBtnTitle = "登录"
    static let regBtnTitle = "注册"
    static let forgetBtnTitle = "忘记密码？"
    static let accountLeftTip = "+86"
    static let accountPlaceholder = "请输入手机号/邮箱"
    static let passswordPlaceholder = "请输入密码"
    static let imgCodePlaceholder = "请输入验证码"
    
    static let leftTitle = "账号密码登录"
    static let rightTitle = "快捷免密登录"
    
    static let pagerBarFontSize = UIFont.systemFont(ofSize: 15.0)
    static let pagerBarHeight: CGFloat = 49.0
}

protocol AccountLoginable {
    
}

// MARK:- 自定义组件
extension AccountLoginable where Self : BaseNameVC{
    
    // MARK:- 其他登录方式
    func initOtherLoginView(onNext: @escaping (_ event: AccountLoginEvent)->Void) -> UIView {
        
        // 创建
        let otherLoginView = HCOtherLoginModeView.loadFromNib()
        
        otherLoginView.weixinBtn.rx.tap.do(onNext: {
            onNext(AccountLoginEvent.init(type: .weixin, title: "微信登陆"))
        }).subscribe().disposed(by: rx.disposeBag)

        otherLoginView.weiboBtn.rx.tap.do(onNext: {
            onNext(AccountLoginEvent.init(type: .weibo, title: "微博登陆"))
        }).subscribe().disposed(by: rx.disposeBag)

        otherLoginView.qqBtn.rx.tap.do(onNext: {
            onNext(AccountLoginEvent.init(type: .qq, title: "QQ登陆"))
        }).subscribe().disposed(by: rx.disposeBag)
        
        return otherLoginView
    }
    
    // MARK:- 登录按钮部分
    func initLoginBtnView(showFP: Bool,onNext: @escaping (_ event: AccountLoginEvent)->Void) -> (UIView, UIButton) {
        
        // 创建
        let btnView = UIView().then {
            $0.backgroundColor = kThemeWhiteColor
        }
        
        let loginBtn = UIButton().then {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = Metric.cornerRadius
            $0.setBackgroundImage(UIImage.init(from: kThemeTomatoColor), for: .normal)
            $0.titleLabel?.font = Metric.loginBtnFontSize
            $0.setTitleColor(kThemeWhiteColor, for: .normal)
            $0.setTitle(Metric.loginBtnTitle, for: .normal)
            $0.rx.tap.do(onNext: {
                onNext(AccountLoginEvent.init(type: .login, title: "登陆按钮"))
            }).subscribe().disposed(by: rx.disposeBag)
        }
    
        
        let forgetBtn = UIButton().then {
            $0.setTitleColor(kThemeTomatoColor, for: .normal)
            $0.setTitle(Metric.forgetBtnTitle, for: .normal)
            $0.titleLabel?.font = Metric.forgetFontSize
            $0.rx.tap.do(onNext: {
                onNext(AccountLoginEvent.init(type: .forget, title: "忘记密码"))
            }).subscribe().disposed(by: rx.disposeBag)
        }
        
        // 添加
        btnView.addSubview(loginBtn)
        if showFP {
            btnView.addSubview(forgetBtn)
        }
        
        
        // 布局
        loginBtn.snp.makeConstraints { (make) in
            
            make.left.right.top.equalToSuperview()
            make.height.equalTo(Metric.loginBtnHeight)
        }
        
        if showFP {
            forgetBtn.snp.makeConstraints { (make) in
                make.top.equalTo(loginBtn.snp.bottom).offset(MetricGlobal.margin)
                make.right.equalTo(loginBtn.snp.right)
                if let width = forgetBtn.titleLabel?.text?.getSize(font: Metric.forgetFontSize).width {
                    make.width.equalTo(width)
                }
                make.height.equalTo(30)
                make.bottom.equalToSuperview().offset(-MetricGlobal.margin)
            }
        }
        
        
        return (btnView, loginBtn)
    }
    
    // MARK:- 账号输入框
    func initAccountField(onNext: @escaping ()->Void) -> UITextField {
        
        let field = UITextField().then {
            $0.layer.masksToBounds = true
            $0.layer.borderColor = kThemeGainsboroColor?.cgColor
            $0.layer.borderWidth = Metric.borderWidth
            $0.layer.cornerRadius = Metric.cornerRadius
            $0.borderStyle = .none
            $0.leftViewMode = .always
            $0.leftView = self.accountLeftView()
            $0.placeholder = Metric.accountPlaceholder
        }
        
        // 输入内容 校验
        let fieldObservable = field.rx.text.skip(1).throttle(0.75, scheduler: MainScheduler.instance).map { (input: String?) -> Bool in
            guard let input  = input else { return false }
            print("\(input)")
            return InputValidator.isValidEmail(email: input)
        }
        
        fieldObservable.map { (valid: Bool) -> UIColor in
            let color = valid ? kThemeGainsboroColor : kThemeOrangeRedColor
            return color!
            }.subscribe(onNext: { (color) in
                field.layer.borderColor = color.cgColor
            }).disposed(by: rx.disposeBag)
        
        return field
    }
    
    // MARK:- 密码输入框
    func initPasswordField(onNext: @escaping ()->Void) -> UITextField {
        
        let field = UITextField().then {
            $0.layer.masksToBounds = true
            $0.layer.borderColor = kThemeGainsboroColor?.cgColor
            $0.layer.borderWidth = Metric.borderWidth
            $0.layer.cornerRadius = Metric.cornerRadius
            $0.isSecureTextEntry = true
            $0.borderStyle = .none
            $0.leftViewMode = .always
            $0.leftView = self.passwordLeftView()
            $0.placeholder = Metric.passswordPlaceholder
        }
        
        // 输入内容 校验
        let fieldObservable = field.rx.text.skip(1).throttle(0.75, scheduler: MainScheduler.instance).map { (input: String?) -> Bool in
            guard let input  = input else { return false }
            print("\(input)")
            return InputValidator.isvalidationPassword(password: input)
        }
        
        fieldObservable.map { (valid: Bool) -> UIColor in
            let color = valid ? kThemeGainsboroColor : kThemeOrangeRedColor
            return color!
            }.subscribe(onNext: { (color) in
                field.layer.borderColor = color.cgColor
            }).disposed(by: rx.disposeBag)
        
        return field
    }
    
    // MARK:- 账号输入框 左视图
    private func accountLeftView() -> UIView {
        
        let leftView = UIView().then {
            $0.frame = CGRect(x: 0, y: 0, width: 40, height: 44)
        }
        
        let tipLab = UILabel().then {
            $0.textAlignment = .center
            $0.font = Metric.fontSize
            $0.textColor = kThemeTitielColor
            $0.setFAIcon(icon: .FAUserO, iconSize: 18)
        }
        
        
        // 添加
        leftView.addSubview(tipLab)
        
        tipLab.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(MetricGlobal.margin)
            make.right.equalToSuperview().offset(-MetricGlobal.margin)
            make.width.equalTo(Metric.tipBtnWidth)
        }
        
        return leftView
    }
    
    // MARK:- 密码输入框 左视图
    private func passwordLeftView() -> UIView {
        
        let leftView = UIView().then {
            $0.frame = CGRect(x: 0, y: 0, width: 40, height: 44)
        }
        
        let tipBtn = UIButton().then {
            $0.contentMode = .scaleAspectFit
            $0.isUserInteractionEnabled = false
            $0.setTitleColor(kThemeTitielColor!, for: UIControlState.normal)
            $0.setFAIcon(icon: FAType.FALock, iconSize: 18, forState: UIControlState.normal)
        }
        
        // 添加
        leftView.addSubview(tipBtn)
        
        tipBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(MetricGlobal.margin)
            make.right.equalToSuperview().offset(-MetricGlobal.margin)
            make.width.equalTo(Metric.tipBtnWidth)
        }
        
        return leftView
    }
    
    //MARK: - 图片验证码入口
    func initImgCodeView(onNext: @escaping ()->Void) -> UITextField {
        
        let field = UITextField().then {
            $0.layer.masksToBounds = true
            $0.layer.borderColor = kThemeGainsboroColor?.cgColor
            $0.layer.borderWidth = Metric.borderWidth
            $0.layer.cornerRadius = Metric.cornerRadius
            $0.borderStyle = .none
            $0.leftViewMode = .always
            $0.leftView = self.ImgCodeViewLeft()
            $0.rightViewMode = .always
            $0.rightView = self.ImgCodeViewRight()
            $0.placeholder = Metric.imgCodePlaceholder
        }
        
        // 输入内容 校验
        let fieldObservable = field.rx.text.skip(1).throttle(0.75, scheduler: MainScheduler.instance).map { (input: String?) -> Bool in
            guard let input  = input else { return false }
            print("\(input)")
            return !(input.isEmpty)
        }
        
        fieldObservable.map { (valid: Bool) -> UIColor in
            let color = valid ? kThemeGainsboroColor : kThemeOrangeRedColor
            return color!
            }.subscribe(onNext: { (color) in
                field.layer.borderColor = color.cgColor
            }).disposed(by: rx.disposeBag)
        

        
        return field
    }
    
    private func ImgCodeViewLeft() -> UIView {
        
        let leftView = UIView().then {
            $0.frame = CGRect(x: 0, y: 0, width: 40, height: 44)
        }
        
        let tipBtn = UIButton().then {
            $0.contentMode = .scaleAspectFit
            $0.isUserInteractionEnabled = false
            $0.setTitleColor(kThemeTitielColor!, for: UIControlState.normal)
            $0.setFAIcon(icon: FAType.FAFileCodeO, iconSize: 18, forState: UIControlState.normal)
        }
        
        // 添加
        leftView.addSubview(tipBtn)
        
        tipBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(MetricGlobal.margin)
            make.right.equalToSuperview().offset(-MetricGlobal.margin)
            make.width.equalTo(Metric.tipBtnWidth)
        }
        
        return leftView
        
    }
    
    private func ImgCodeViewRight() -> UIView {
        
        
        let rightView = UIView().then {
            $0.frame = CGRect(x: 0, y: 0, width: 130, height: 44)
        }
        
        
        
        let tipBtn = UIButton().then {
            $0.contentMode = .scaleAspectFit
        }
        
        Util.getImgCode { (codeUrl) in
            tipBtn.sd_setImage(with: URL.init(string: codeUrl!), for: UIControlState.normal, completed: nil)
        }
        
        tipBtn.rx.tap.do(onNext: {
            Util.getImgCode { (codeUrl) in
                tipBtn.sd_setImage(with: URL.init(string: codeUrl!), for: UIControlState.normal, completed: nil)
            }
        }).subscribe().disposed(by: rx.disposeBag)
        
        // 添加
        rightView.addSubview(tipBtn)
        
        tipBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(1)
            make.width.equalTo(Metric.tipBtnWidth)
        }
        
        
        return rightView
        
    }
    
    
    //MARK: - 手机短信验证码入口
    
    func initSMSCode(onNext: @escaping ()->Void) -> UITextField{
        
        let field = UITextField().then {
            $0.layer.masksToBounds = true
            $0.layer.borderColor = kThemeGainsboroColor?.cgColor
            $0.layer.borderWidth = Metric.borderWidth
            $0.layer.cornerRadius = Metric.cornerRadius
            $0.isSecureTextEntry = true
            $0.borderStyle = .none
            $0.leftViewMode = .always
            $0.leftView = self.SMSCodeLeft()
            $0.rightViewMode = .always
            $0.rightView = self.SMSCodeRight()
            $0.placeholder = Metric.passswordPlaceholder
        }
        
        // 输入内容 校验
        let fieldObservable = field.rx.text.skip(1).throttle(0.75, scheduler: MainScheduler.instance).map { (input: String?) -> Bool in
            guard let input  = input else { return false }
            print("\(input)")
            return InputValidator.isvalidationPassword(password: input)
        }
        
        fieldObservable.map { (valid: Bool) -> UIColor in
            let color = valid ? kThemeGainsboroColor : kThemeOrangeRedColor
            return color!
            }.subscribe(onNext: { (color) in
                field.layer.borderColor = color.cgColor
            }).disposed(by: rx.disposeBag)
        
        return field
    }
    private func SMSCodeLeft() -> UIView {
        
        
        let leftView = UIView().then {
            $0.frame = CGRect(x: 0, y: 0, width: 40, height: 44)
        }
        
        let tipBtn = UIButton().then {
            $0.contentMode = .scaleAspectFit
            $0.isUserInteractionEnabled = false
            $0.setTitleColor(kThemeTitielColor!, for: UIControlState.normal)
            $0.setFAIcon(icon: FAType.FACommentO, iconSize: 18, forState: UIControlState.normal)
        }
        
        // 添加
        leftView.addSubview(tipBtn)
        
        tipBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(MetricGlobal.margin)
            make.right.equalToSuperview().offset(-MetricGlobal.margin)
            make.width.equalTo(Metric.tipBtnWidth)
        }
        
        return leftView
        
    }
    
    private func SMSCodeRight() -> UIView {
        
        let rightView = UIView().then {
            $0.frame = CGRect(x: 0, y: 0, width: 130, height: 44)
        }
        
        
        
        let tipBtn = UIButton().then {
            $0.contentMode = .scaleAspectFit
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            $0.backgroundColor = UIColor.init(hexString: "#4895e0")
            $0.setTitle("获取验证码", for: UIControlState.normal)
            $0.setTitleColor(UIColor.white, for: UIControlState.normal)
        }
    
        tipBtn.rx.tap.do(onNext: { [weak self] _ in
            self?.getCode(button: tipBtn)
        }).subscribe().disposed(by: rx.disposeBag)
        
        // 添加
        rightView.addSubview(tipBtn)
        
        tipBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(1)
            make.width.equalTo(Metric.tipBtnWidth)
        }
        
        
        return rightView
    }
    
    private func getCode(button: UIButton) {
        
        button.isUserInteractionEnabled = false

        Util.getSMSCode { (code) in
            
            if code != nil {
                button.startTime()
            }else{
                button.isUserInteractionEnabled = true
                button.setTitle("获取失败请重试", for: UIControlState.normal)
            }
        }
    }

}


