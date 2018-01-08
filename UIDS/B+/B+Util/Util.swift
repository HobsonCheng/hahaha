//
//  Util.swift
//  UIDS
//
//  Created by one2much on 2018/1/8.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import iRate

private let singleUtil = Util()

final class Util: NSObject,iRateDelegate{
    
    var mainVC: UIViewController?
    
    static var shared: Util {
        return singleUtil
    }
    
    fileprivate override init() {
        super.init();
        //初始化 配置信息
        self.setup()
    }
    func setup(){
        iRate.sharedInstance().delegate = self
        // 初始化Appstore id
        iRate.sharedInstance().applicationBundleID = "com.charcoaldesign.rainbowblocks"
        // 启动或者回到前台就尝试提醒
        iRate.sharedInstance().promptAtLaunch = false
        // 每个版本都弹
        iRate.sharedInstance().promptForNewVersionIfUserRated = true
        // 使用几次后开始弹出
        iRate.sharedInstance().usesUntilPrompt = 2
        // 多少天后开始弹出，默认10次
        iRate.sharedInstance().daysUntilPrompt = 3
        // 选择“稍后提醒我”后的再提醒时间间隔，默认是1天
        iRate.sharedInstance().remindPeriod = 3
        iRate.sharedInstance().declinedThisVersion = false
    }
    func setAlertContent(){
        let rateTitle: String = "给我评价"
        let rateText: String = "觉得这个app怎么样，喜欢就来评价一下唄"
        
        iRate.sharedInstance().messageTitle = rateTitle
        iRate.sharedInstance().message = rateText
        iRate.sharedInstance().updateMessage = rateText
        iRate.sharedInstance().rateButtonLabel? = "喜欢，支持一下"
        iRate.sharedInstance().remindButtonLabel? = "不喜欢，去吐槽"
        iRate.sharedInstance().cancelButtonLabel? = "以后再说"
    }
    
    
    public func checkAndRateWithController(vc :UIViewController){
        self.mainVC = vc
        if iRate.sharedInstance().shouldPromptForRating(){
            iRate.sharedInstance().promptForRating();
        }
    }
    
    //TODO: irateDelegate
    func iRateUserDidRequestReminderToRateApp() {
        
    }
    func iRateUserDidDeclineToRateApp() {
        
    }
    func shouldPromptForRating() -> Bool {
        return false
    }
}
