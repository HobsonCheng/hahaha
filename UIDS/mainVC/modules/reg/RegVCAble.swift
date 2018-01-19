//
//  RegVCAble.swift
//  UIDS
//
//  Created by one2much on 2018/1/18.
//  Copyright © 2018年 one2much. All rights reserved.
//

import Foundation
import UIKit
import Then
import RxSwift
import RxCocoa
import NSObject_Rx
import Font_Awesome_Swift

//MARK: 注册扩展 那边太拥挤了
extension AccountLoginable where Self : BaseNameVC {//协议扩展
    
    
    // MARK:- 注册按钮
    func initRegBtnView(onNext: @escaping (_ event: Bool)->Void) -> (UIView, UIButton) {
        
        // 创建
        let btnView = UIView().then {
            $0.backgroundColor = kThemeWhiteColor
        }
        
        let regBtn = UIButton().then {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = Metric.cornerRadius
            $0.setBackgroundImage(UIImage.init(from: kThemeTomatoColor), for: .normal)
            $0.titleLabel?.font = Metric.loginBtnFontSize
            $0.setTitleColor(kThemeWhiteColor, for: .normal)
            $0.setTitle(Metric.regBtnTitle, for: .normal)
            $0.rx.tap.do(onNext: {
                onNext(true)
            }).subscribe().disposed(by: rx.disposeBag)
        }
        
        
        // 添加
        btnView.addSubview(regBtn)
     
        // 布局
        regBtn.snp.makeConstraints { (make) in
            
            make.left.right.top.equalToSuperview()
            make.height.equalTo(Metric.loginBtnHeight)
        }
        

        return (btnView, regBtn)
    }
    
    
    // MARK:- 账号输入框
    func initOtherField(type: Int?,titleStr: String? ,onNext: @escaping ()->Void) -> UITextField {
        
        let field = UITextField().then {
            $0.layer.masksToBounds = true
            $0.layer.borderColor = kThemeGainsboroColor?.cgColor
            $0.layer.borderWidth = Metric.borderWidth
            $0.layer.cornerRadius = Metric.cornerRadius
            $0.borderStyle = .none
            $0.leftViewMode = .always
            $0.leftView = self.OtherLeftView(type: type, titleStr: titleStr)
            $0.placeholder = String.init(format: "请输入%@", titleStr!)
            if type == 2 {//密码
                $0.isSecureTextEntry = true
            }
        }
        
//        // 输入内容 校验
        let fieldObservable = field.rx.text.skip(1).throttle(0.1, scheduler: MainScheduler.instance).map { (input: String?) -> Bool in
            guard let input  = input else { return false }
            print("\(input)")
            return !input.isEmpty
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
    private func OtherLeftView(type: Int?,titleStr: String?) -> UIView {
        
        let leftView = UIView().then {
            $0.frame = CGRect(x: 0, y: 0, width: 40, height: 44)
        }
        
        let tipLab = UILabel().then {
            $0.textAlignment = .center
            $0.font = Metric.fontSize
            $0.textColor = kThemeTitielColor
            if type == 1 {//用户名
                $0.setFAIcon(icon: .FAUserO, iconSize: 18)
            }else if type == 2 {//密码
                $0.setFAIcon(icon: FAType.FALock, iconSize: 18)
            }else if type == 3 {//昵称
                $0.setFAIcon(icon: FAType.FAUserSecret, iconSize: 18)
            }
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
    
}
