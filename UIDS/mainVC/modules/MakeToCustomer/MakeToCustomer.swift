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


class CustomerForm: FormViewController {
   
    var FormObj: FromModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.FormObj?.FormTitles?.count != 0 {
            genderVC(FormTitles: self.FormObj?.FormTitles, formName: (self.FormObj?.FormTitle!)!)
        }
    }
    
    
    func genderVC(FormTitles: [FromData]?,formName: String) {
    
        //创建form实例
        let form = FormDescriptor()
        form.title = formName
        
        //第一个section分区
        let section1 = FormSectionDescriptor(headerTitle: formName, footerTitle: nil)
        
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
        let message = self.form.formValues().description
        print(message)
    
        let sub_val = JSON.init(self.form.formValues()).rawString()
        
        Util.svploading(str: "提交中...")
        
        let params = NSMutableDictionary()
        params.setSafeObject(self.FormObj?.FormTitle!, forKey: "classify_name" as NSCopying)
        params.setSafeObject(sub_val, forKey: "sub_val" as NSCopying)
        
        ApiUtil.share.saveSubscribe(params: params) { (status, data, msg) in
            
            Util.svpStop(ok: true,callback: {
               VCController.pop(with: VCAnimationClassic.defaultAnimation())
            })
        }
        
    }
}


class MakeToCustomer: BaseModuleView {

    
    public func genderInit(FormObj: FromModel){
        
    
        let formVC = CustomerForm(style: UITableViewStyle.plain)
        formVC.FormObj = FormObj
        self.addSubview(formVC.view)
        formVC.view.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: CGFloat(((FormObj.FormTitles?.count)! + 1)*90))
        
        self.height = formVC.view.bottom + 10.0
        self.layer.masksToBounds = true
    }
    
}
