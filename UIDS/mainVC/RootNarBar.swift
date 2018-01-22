//
//  RootNarBar.swift
//  UIDS
//
//  Created by one2much on 2018/1/22.
//  Copyright © 2018年 one2much. All rights reserved.
//

import Foundation
import Font_Awesome_Swift

enum NAV_BAR_TYPE: Int {
    case NAV_BAR_TYPE_ADD_GROUP = 10000
    case NAV_BAR_TYPE_ADD_TOPOC
}

//拓展 导航按钮信息
extension RootVC {
    
    func gender_extension_Right_navbar(type: NAV_BAR_TYPE) {
        
        //导航右部信息
        let tmpRightList = self.naviBar().rightBarItems
        
        for barView in tmpRightList! {
            if (barView as AnyObject).tag == type.rawValue {
                return;
            }
        }
        
        switch type {
        case  .NAV_BAR_TYPE_ADD_GROUP:
            self.genderAdd_group()
            break
        case  .NAV_BAR_TYPE_ADD_TOPOC:
            self.genderAdd_topoc()
            break
        default:
            break
        }
    }
    
    private func genderAdd_group(){
        
        let right = NaviBarItem.init(imageItem: CGRect.init(x: 0, y: 0, width: 44, height: 22), target: self, action: #selector(RootVC.touchAddGroup))
        right?.tag = NAV_BAR_TYPE.NAV_BAR_TYPE_ADD_GROUP.rawValue
        right?.button.setFAIcon(icon: FAType.FAPlus, iconSize: 20, forState: UIControlState.normal)
 
        let tmpRights = NSMutableArray.init(array: self.naviBar().rightBarItems)
        tmpRights.add(right as Any)
        
        self.naviBar().rightBarItems = tmpRights as? [Any]
    }
    private func genderAdd_topoc(){
        
        let right = NaviBarItem.init(imageItem: CGRect.init(x: 0, y: 0, width: 44, height: 22), target: self, action: #selector(RootVC.touchAddTopice))
        right?.tag = NAV_BAR_TYPE.NAV_BAR_TYPE_ADD_TOPOC.rawValue
        right?.button.setFAIcon(icon: FAType.FAPencil, iconSize: 20, forState: UIControlState.normal)
        
        let tmpRights = NSMutableArray.init(array: self.naviBar().rightBarItems)
        tmpRights.add(right as Any)
        
        self.naviBar().rightBarItems = tmpRights as? [Any]
    }
    
}
//MARK: - action
extension RootVC {
    
    func touchAddGroup() {
        
        let alert = LSXAlertInputView.init(title: "创建群组", placeholderText: "请输入创建群组名", withKeybordType: LSXKeyboardType.default) {(contents) in
            let params = NSMutableDictionary()
            params.setValue(contents, forKey: "name")
            ApiUtil.share.addGroup(params: params, fininsh: { (status, data, msg) in
                
                Util.msg(msg: "提交成功", 2)
                
            })
        }
        alert?.show()
    }
    
    func touchAddTopice() {
        
        let topiceSend = GroupTopicSendVC.init(name: "GroupTopicSendVC")
        topiceSend?.pageData = self.pageData
        VCController.push(topiceSend!, with: VCAnimationBottom.defaultAnimation())
        
    }
    
}
