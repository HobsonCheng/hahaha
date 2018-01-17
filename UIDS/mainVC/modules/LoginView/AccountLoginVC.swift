//
//  AccountLoginVC.swift
//  UIDS
//
//  Created by one2much on 2018/1/17.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import Then
import RxCocoa
import RxSwift
import RxGesture
import NSObject_Rx

// MARK:- 常量
fileprivate struct Metric {
    
    static let fieldHeight: CGFloat = 45.0
}

class AccountLoginVC: BaseNameVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = kThemeWhiteColor
        view.rx.tapGesture().do(onNext: { [weak self] _ in
            self?.view.endEditing(true)
        }).subscribe().disposed(by: rx.disposeBag)
//
        initEnableMudule()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: 初始化
extension AccountLoginVC: AccountLoginable {
    
    
    // MARK:- 初始化 登录 输入框
    func initEnableMudule() {
        
        // 创建 容器组件
        let scrollView = UIScrollView().then {
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
        }
        
        // 创建 协议组件
        let accountField = initAccountField { }
        let passwordField = initPasswordField { }
        let (loginBtnView, loginBtn) = initLoginBtnView { event in print(event.title ?? "") }
        let otherLoginView = initOtherLoginView { event in print(event.title ?? "") }
        
        // 创建 视图模型
        let accountLoginView = HCAccountLoginViewModel(input: (accountField, passwordField, loginBtn), service: HCAccountLoginService.shareInstance)

        accountLoginView.accountUseable.drive(accountField.rx.validationResult).disposed(by: rx.disposeBag)
        accountLoginView.passwordUseable.drive(passwordField.rx.validationResult).disposed(by: rx.disposeBag)
        accountLoginView.loginBtnEnable.drive(onNext: { (beel) in
            loginBtn.isEnabled = beel
        }).disposed(by: rx.disposeBag)
        accountLoginView.loginResult.drive(onNext: { (result) in
            switch result {
            case .ok:
                print("\(result.description)")
                break
            case .empty:
                break
            case .failed:
                print("\(result.description)")
                break
            }
        }).disposed(by: rx.disposeBag)
        
        // 添加
        view.addSubview(scrollView)
        scrollView.addSubview(accountField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginBtnView)
        scrollView.addSubview(otherLoginView)
        
        // 布局
        scrollView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(kScreenW)
        }
        
        accountField.snp.makeConstraints { (make) in
            if kScreenW <= 320 {
                make.left.equalToSuperview().offset(MetricGlobal.margin * 2)
            } else {
                make.left.equalToSuperview().offset(MetricGlobal.margin * 3)
            }
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(MetricGlobal.margin * 2)
            make.height.equalTo(Metric.fieldHeight)
        }
        
        passwordField.snp.makeConstraints { (make) in
            make.left.equalTo(accountField.snp.left)
            make.right.equalTo(accountField.snp.right)
            make.top.equalTo(accountField.snp.bottom).offset(MetricGlobal.margin * 2)
            make.height.equalTo(Metric.fieldHeight)
        }
        
        loginBtnView.snp.makeConstraints { (make) in
            make.left.equalTo(accountField.snp.left)
            make.right.equalTo(accountField.snp.right)
            make.top.equalTo(passwordField.snp.bottom).offset(MetricGlobal.margin * 2)
        }
    
        otherLoginView.snp.makeConstraints { (make) in
        
            if kScreenW <= 320 {
                make.left.equalTo(accountField.snp.left).offset(-MetricGlobal.margin * 1)
            } else {
                make.left.equalTo(accountField.snp.left).offset(-MetricGlobal.margin * 2)
            }
            make.centerX.equalToSuperview()
            make.top.equalTo(loginBtnView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    
}
