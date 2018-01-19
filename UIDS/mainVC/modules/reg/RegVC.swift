//
//  RegVC.swift
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


class RegVC: NaviBarVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNaviDefulat()
        self.naviBar().setTitle("注册")
        
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
extension RegVC: AccountLoginable {
    
    
    // MARK:- 初始化 登录 输入框
    func initEnableMudule() {
        
        // 创建 容器组件
        let scrollView = UIScrollView().then {
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
        }
        
        // 创建 协议组件
        let accountField = initOtherField(type: 1, titleStr: "用户名") { }
        let passwordField = initOtherField(type: 2, titleStr: "密码") { }
        let passwordField_2 = initOtherField(type: 2, titleStr: "确认密码") {}
        let nicknameField = initOtherField(type: 3, titleStr: "昵称") {}
        let (regBtnView, regBT) = initRegBtnView { event in print(event ) }
        weak var tmpimgCodeView: UITextField?
        tmpimgCodeView = UITextField()
        let imgCodeView = initImgCodeView { [weak self] (codekey) in
            let regServise = RegVCService(input: (accountField, passwordField, passwordField_2, nicknameField, tmpimgCodeView!, regBT), codekey: codekey!)
            
            regServise.loginBtnEnable.drive(onNext: { (beel) in
                
                regBT.isEnabled = beel
                
            }).disposed(by: (self?.rx.disposeBag)!)
            regServise.loginResult.drive().disposed(by: (self?.rx.disposeBag)!)
    
        }
        
        tmpimgCodeView = imgCodeView
        
        // 添加
        view.addSubview(scrollView)
        scrollView.addSubview(accountField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(passwordField_2)
        scrollView.addSubview(nicknameField)
        scrollView.addSubview(imgCodeView)
        scrollView.addSubview(regBtnView)
        
        // 布局
        scrollView.snp.makeConstraints { [weak self] (make) in
            make.left.bottom.equalToSuperview()
            make.top.equalTo((self?.naviBar().bottom)!)
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
            make.top.equalTo(accountField.snp.bottom).offset(MetricGlobal.margin * 1)
            make.height.equalTo(Metric.fieldHeight)
        }
        
        passwordField_2.snp.makeConstraints { (make) in
            make.left.equalTo(passwordField.snp.left)
            make.right.equalTo(passwordField.snp.right)
            make.top.equalTo(passwordField.snp.bottom).offset(MetricGlobal.margin * 1)
            make.height.equalTo(Metric.fieldHeight)
        }
        
        nicknameField.snp.makeConstraints { (make) in
            make.left.equalTo(passwordField_2.snp.left)
            make.right.equalTo(passwordField_2.snp.right)
            make.top.equalTo(passwordField_2.snp.bottom).offset(MetricGlobal.margin * 1)
            make.height.equalTo(Metric.fieldHeight)
        }
        
        imgCodeView.snp.makeConstraints { (make) in
            
            make.left.equalTo(nicknameField.snp.left)
            make.right.equalTo(nicknameField.snp.right)
            make.top.equalTo(nicknameField.snp.bottom).offset(MetricGlobal.margin * 1)
            make.height.equalTo(Metric.fieldHeight)
            
        }
        
        regBtnView.snp.makeConstraints { (make) in
            make.left.equalTo(imgCodeView.snp.left)
            make.right.equalTo(imgCodeView.snp.right)
            make.top.equalTo(imgCodeView.snp.bottom).offset(MetricGlobal.margin * 2)
            make.height.equalTo(Metric.fieldHeight)
        }
    
    }
    
    
}
