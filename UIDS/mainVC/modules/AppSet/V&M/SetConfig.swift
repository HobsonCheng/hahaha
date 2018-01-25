//
//  SetConfig.swift
//  UIDS
//
//  Created by one2much on 2018/1/25.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class SetConfig: NSObject {

}

// MARK:- 外部访问方法
extension SetConfig {
    
    // MARK:- 我的
    class func loadMineModels() -> [[SettingCellModel]] {
        
        let model1_1 = SettingCellModel(leftIcon: "comment_profile_mars.png",
                                          title: "编辑我",
                                          description: nil,
                                          dotIcon: nil,
                                          rightIcon: "meRecord",
                                          isHiddenBottomLine: true,
                                          cellType: .rightRecordButton)
        
        
        let model3_1 = SettingCellModel(leftIcon: "scan_scan.png",
                                          title: "扫一扫",
                                          description: nil,
                                          dotIcon: nil,
                                          rightIcon: "cell_arrow.pnf")
        
        let model4_1 = SettingCellModel(leftIcon: "me_setting_feedback.png",
                                          title: "帮助与反馈",
                                          description: nil,
                                          dotIcon: nil,
                                          rightIcon: "cell_arrow.png")
        let model4_2 = SettingCellModel(leftIcon: "me_setting_setting.png",
                                          title: "设置",
                                          description: nil,
                                          dotIcon: "noread_icon.png",
                                          rightIcon: "cell_arrow.png",
                                          isHiddenBottomLine: true)
        
        
        var models = [[SettingCellModel]]()
        
        // 充当 SectionHeader 数据模型
        let placeModel = SettingCellModel()
        
        models.append([placeModel, model1_1])
        models.append([placeModel])
        models.append([placeModel, model3_1])
        models.append([placeModel, model4_1, model4_2])
        
        
        
        return models
    }
    
    // MARK:- 设置
    class func loadSettingModels() -> [[SettingCellModel]] {
        
        let model1_1 = SettingCellModel(leftIcon: nil,
                                          title: "账号与安全",
                                          description: nil,
                                          dotIcon: nil,
                                          rightIcon: "cell_arrow.png",
                                          isHiddenBottomLine: true)
        
        
        let model2_1 = SettingCellModel(leftIcon: nil,
                                          title: "新消息通知",
                                          description: nil,
                                          dotIcon: nil,
                                          rightIcon: "cell_arrow.png")
        let model2_2 = SettingCellModel(leftIcon: nil,
                                          title: "隐私",
                                          description: nil,
                                          dotIcon: nil,
                                          rightIcon: "cell_arrow.png",
                                          isHiddenBottomLine: true)
        let model2_3 = SettingCellModel(leftIcon: nil,
                                        title: "通用",
                                        description: nil,
                                        dotIcon: nil,
                                        rightIcon: "cell_arrow.png",
                                        isHiddenBottomLine: true)
        
        let model3_1 = SettingCellModel(leftIcon: nil,
                                          title: "推送设置",
                                          description: "别错过重要信息，去开启",
                                          dotIcon: nil,
                                          rightIcon: "cell_arrow.png")
        
        
        let model4_1 = SettingCellModel(leftIcon: nil,
                                          title: "清理占用空间",
                                          description: "0.0M",
                                          dotIcon: nil,
                                          rightIcon: "cell_arrow.png",
                                          isHiddenBottomLine: true,
                                          cellType: .rightTextLab)
        
        
        let model5_1 = SettingCellModel(leftIcon: nil,
                                          title: "特色功能",
                                          description: "",
                                          dotIcon: nil,
                                          rightIcon: "cell_arrow.png")
        let model5_2 = SettingCellModel(leftIcon: nil,
                                          title: "新版本介绍",
                                          description: "",
                                          dotIcon: "noread_icon.png",
                                          rightIcon: "cell_arrow.png")
        let model5_3 = SettingCellModel(leftIcon: nil,
                                          title: "给个好评",
                                          description: "",
                                          dotIcon: nil,
                                          rightIcon: "cell_arrow.png")
        let model5_4 = SettingCellModel(leftIcon: nil,
                                          title: "关于",
                                          description: "",
                                          dotIcon: nil,
                                          rightIcon: "cell_arrow.png",
                                          isHiddenBottomLine: true)
        
        
        var models = [[SettingCellModel]]()
        
        // 充当 SectionHeader 数据模型
        let placeModel = SettingCellModel()
        
        models.append([placeModel, model1_1])
        models.append([placeModel, model2_1, model2_2,model2_3])
        models.append([placeModel, model3_1])
        models.append([placeModel, model4_1])
        models.append([placeModel, model5_1, model5_2, model5_3, model5_4])
        
        
        //登出按钮
        if UserUtil.isValid() {
            let model6_1 = SettingCellModel.init(leftIcon: nil, title: "退出登录", description: "", dotIcon: nil, rightIcon: nil, isHiddenBottomLine: true, cellType: .outType)
            
            models.append([placeModel, model6_1])
        }
        
        
        return models
    }
}
