//
//  GroupTopicSendVC.swift
//  UIDS
//
//  Created by one2much on 2018/1/22.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import Font_Awesome_Swift
import KMPlaceholderTextView
import TextFieldEffects
import LPDQuoteImagesView

class GroupTopicSendVC: NaviBarVC, LPDQuoteImagesViewDelegate {

    var pageData: PageInfo?
    var mainScroll: UIScrollView?
    var titleTextF: KaedeTextField?
    var contentTxt: KMPlaceholderTextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNaviDefulat()
        self.naviBar().setTitle("发布")

        self.genderNavi()
        
        self.genderRoot()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK:- 导航信息
extension GroupTopicSendVC {

    func genderNavi() {
        
        let left = NaviBarItem.init(imageItem: CGRect.init(x: 0, y: 0, width: 44, height: 22), target: self, action: #selector(GroupTopicSendVC.goBack(_:)))
        left?.button.setFAIcon(icon: FAType.FAClose, iconSize: 20, forState: UIControlState.normal)
        self.naviBar().setLeftBarItem(left!)
        
        let right = NaviBarItem.init(imageItem: CGRect.init(x: 0, y: 0, width: 44, height: 22), target: self, action: #selector(GroupTopicSendVC.sendTxt))
        right?.tag = NAV_BAR_TYPE.NAV_BAR_TYPE_ADD_TOPOC.rawValue
        right?.button.setFAIcon(icon: FAType.FASendO, iconSize: 20, forState: UIControlState.normal)
        self.naviBar().setRightBarItem(right!)
        
    }
    
    func sendTxt() {
        
        if self.titleTextF?.text?.count == 0 {
            
            self.titleTextF?.becomeFirstResponder()
            
            Util.msg(msg: "标题不能为空", 3)
            return
        }
        
        if self.contentTxt?.text.count == 0 {
            
            self.contentTxt?.becomeFirstResponder()
            Util.msg(msg: "随便写点...", 3)
            return
        }
        
        let groupData: GroupData = self.pageData?.anyObj as! GroupData
        
        let params = NSMutableDictionary()
        params.setValue(groupData.name, forKey: "name")
        params.setValue(groupData.id, forKey: "group_id")
        params.setValue(self.titleTextF?.text, forKey: "title")
        params.setValue(self.titleTextF?.text, forKey: "summarize")
        params.setValue(self.contentTxt?.text, forKey: "content")
        
        
        self.startLoadBlock(nil, withHint: "发布中...")
        ApiUtil.share.addInvitation(params: params) { [weak self] (status, data, msg) in
            
            self?.stopLoadBlock()
            
            Util.msg(msg: "发布成功", 2)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                VCController.pop(with: VCAnimationBottom.defaultAnimation())
            }
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.stopLoadBlock()
        }
    
    }
    
}

extension GroupTopicSendVC {
    
    func genderRoot() {
        
        self.mainScroll = UIScrollView.init(frame: CGRect.init(x: 0, y: self.naviBar().bottom, width: self.view.width, height: self.view.height - self.naviBar().bottom))
        self.view.addSubview(self.mainScroll!)
        
        
        //标题
        let textField = KaedeTextField(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 40))
        textField.placeholderColor = UIColor.white
        
        let bgColor: String? = Util.get_defult(key: B_USER_KEY_NAV_BG_COLOR) as? String
        if bgColor != nil {
            let bgColor = UIColor.init(hexString: bgColor, withAlpha: 1)
            
            textField.foregroundColor = bgColor
        }
        textField.backgroundColor = UIColor.white
        textField.placeholder = "加个标题呦...（点我）"
        self.mainScroll?.addSubview(textField)
        self.titleTextF = textField
        
        //生成文本输入信息
        let placeholderTextView = KMPlaceholderTextView(frame: CGRect.init(x: 0, y: textField.bottom + 0.5, width: self.view.width, height: 150))
        placeholderTextView.placeholder = "来吧，尽情发挥吧..."
        placeholderTextView.font = UIFont.systemFont(ofSize: 15)
        
        
        self.mainScroll?.addSubview(placeholderTextView)
        self.contentTxt = placeholderTextView
        self.contentTxt?.becomeFirstResponder()
        
        let bgView = UIView.init(frame: CGRect.init(x: 0, y: placeholderTextView.bottom + 0.5, width: self.view.width, height: 280))
        bgView.backgroundColor = UIColor.white
        self.mainScroll?.addSubview(bgView)
        
        //添加图片
        let photoImg = LPDQuoteImagesView.init(frame: CGRect.init(x: 10, y: 0, width: self.view.width-20, height: 280), withCountPerRowInView: 4, cellMargin: 10)
        photoImg?.navcDelegate = self
        photoImg?.isShowTakePhotoSheet = true
        photoImg?.maxSelectedCount = 9
        bgView.addSubview(photoImg!)
        
        if (self.mainScroll?.height)! > bgView.bottom {
            self.mainScroll?.contentSize = CGSize.init(width: 0, height: (self.mainScroll?.height)! + 1)
        }else{
            self.mainScroll?.contentSize = CGSize.init(width: 0, height: bgView.bottom)
        }
        
    }
    
}
