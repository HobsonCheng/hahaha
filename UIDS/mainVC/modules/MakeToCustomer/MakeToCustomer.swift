//
//  MakeToCustomer.swift
//  UIDS
//
//  Created by one2much on 2018/1/26.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import SwiftForms
import Then
import SwiftyJSON
import RxSwift

class CustomerForm: FormViewController {
   
    var FormObj: FromModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let titles = self.FormObj?.FormTitles {
            genderVC(FormTitles: titles, formName: (self.FormObj?.FormTitle!)!)
        }
    }
    
    
    func genderVC(FormTitles: [FromData]?,formName: String) {
    
        //创建form实例
        let form = FormDescriptor()
        
        //第一个section分区
        let section1 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        
        var row: FormRowDescriptor
        
        for item in FormTitles ?? [] {
            
            row = FormRowDescriptor(tag: item.name!, type: .text, title: item.name!)
            row.configuration.cell.appearance = ["textField.placeholder" : "请输入\(item.name!)" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
            section1.rows.append(row)
        }
        
        //第二个section分区
        let section2 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        //提交按钮
        row = FormRowDescriptor(tag: "button", type: .button, title: "提交")
        row.configuration.button.didSelectClosure = { _ in
            self.submit()
        }
        section2.rows.append(row)
        
        form.sections = [section1,section2]
        
        self.form = form
    }
    
    func submit() {
        //取消当前编辑状态
        self.view.endEditing(true)
        
        //将表单中输入的内容打印出来
        for (_,value) in self.form.formValues().enumerated(){
            if value.value is NSNull{
                Util.msg(msg: "请将表单填写完整", 1)
                return
            }
        }
        
    
        let sub_val = JSON.init(self.form.formValues()).rawString()
        
//        Util.svploading(str: "提交中...")
        
        let params = NSMutableDictionary()
        params.setSafeObject(self.FormObj?.FormTitle!, forKey: "classify_name" as NSCopying)
        params.setSafeObject(sub_val, forKey: "sub_val" as NSCopying)
        
        ApiUtil.share.saveSubscribe(params: params) { (status, data, msg) in
            Util.msg(msg: "提交成功", 2)
//            Util.svpStop(ok: true,callback: {
//            
////               VCController.pop(with: VCAnimationClassic.defaultAnimation())
//            },hint: "提交成功")
        }
        
    }
}


class MakeToCustomer: BaseModuleView {

    
    public func genderInit(FormObj: FromModel,appKey:String,pageId:Int){
        
        let formVC = CustomerForm(style: UITableViewStyle.grouped)
        formVC.FormObj = FormObj
        formVC.tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: 50))
        //复制按钮
        let button = UIButton.init(type: .infoDark)
        button.tintColor = UIColor.gray
        button.frame = CGRect.init(x: kScreenW - 40, y: 30, width: 30, height: 30)
        formVC.tableView.addSubview(button)
        let appInfo = AppInfoData.shared.appModel
        let app_id = appInfo?.app_id ?? 0
        let group_id = UserUtil.getGroupId()
        button.rx.tap.do(onNext: {
            let board = UIPasteboard.general
            board.string = "www.uidashi.com/hy?appid=\(app_id)&groupid=\(group_id)&pagekey=\(appKey)&pageid=\(pageId)&isfrom=two&type=default"
            Util.msg(msg: "复制成功", 2)
        }).subscribe().disposed(by: rx.disposeBag)
        //标题
        let lable = UILabel.init(frame: CGRect.init(x: 15, y: 0, width: kScreenW, height: 30))
        lable.text = FormObj.FormTitle
        formVC.tableView.addSubview(lable)
        self.addSubview(formVC.view)
        let count = FormObj.FormTitles?.count ?? 0
        let height = CGFloat((count + 1)*44) + 110
        formVC.tableView.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: height)
        
        self.height = formVC.view.bottom
        self.layer.masksToBounds = true
    }
    
}
