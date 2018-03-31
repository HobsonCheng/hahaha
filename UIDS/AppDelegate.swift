//
//  AppDelegate.swift
//  UIDS
//
//  Created by one2much on 2018/1/5.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import JMessage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var app_launchOptions: [UIApplicationLaunchOptionsKey: Any]?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        app_launchOptions = launchOptions
//        BQLAuthEngine.single.registerApp()
        IQKeyboardManager.sharedManager().enable = true
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JMessage.registerDeviceToken(deviceToken)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
       resetBadge(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        resetBadge(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
//        if url.scheme == WECHAT_APPID {
//            return WXApi.handleOpen(url, delegate: BQLAuthEngine.single)
//        }
//        else if url.scheme == "tencent" + QQ_APPID {
//            return TencentOAuth.handleOpen(url)
//        }
//        else if url.scheme == "wb" + SINA_APPKEY {
//            return WeiboSDK.handleOpen(url, delegate: BQLAuthEngine.single)
//        }
        return true
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        
//        if url.scheme == WECHAT_APPID {
//            return WXApi.handleOpen(url, delegate: BQLAuthEngine.single)
//        }
//        else if url.scheme == "tencent" + QQ_APPID {
//            return TencentOAuth.handleOpen(url)
//        }
//        else if url.scheme == "wb" + SINA_APPKEY {
//            return WeiboSDK.handleOpen(url, delegate: BQLAuthEngine.single)
//        }
        return true
    }
    private func resetBadge(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
//        application.cancelAllLocalNotifications()
        JMessage.resetBadge()
    }
}



//MARK: - JMessage Delegate
extension AppDelegate: JMessageDelegate {
    func onDBMigrateStart() {
        MBProgressHUD_JChat.showMessage(message: "数据库升级中", toView: nil)
    }
    
    func onDBMigrateFinishedWithError(_ error: Error!) {
        MBProgressHUD_JChat.hide(forView: nil, animated: true)
        MBProgressHUD_JChat.show(text: "数据库升级完成", view: nil)
    }
    
    func onReceive(_ event: JMSGNotificationEvent!) {
        switch event.eventType {
        case .receiveFriendInvitation, .acceptedFriendInvitation, .declinedFriendInvitation:
            cacheInvitation(event: event)
        case .loginKicked, .serverAlterPassword, .userLoginStatusUnexpected:
            _logout()
        case .deletedFriend, .receiveServerFriendUpdate:
            NotificationCenter.default.post(name: Notification.Name(rawValue: kUpdateFriendList), object: nil)
        default:
            break
        }
    }
    
    private func cacheInvitation(event: JMSGNotificationEvent) {
        let friendEvent =  event as! JMSGFriendNotificationEvent
        _ = friendEvent.getFromUser()
        _ = friendEvent.getReason()
        
        if UserDefaults.standard.object(forKey: kUnreadInvitationCount) != nil {
            let count = UserDefaults.standard.object(forKey: kUnreadInvitationCount) as! Int
            UserDefaults.standard.set(count + 1, forKey: kUnreadInvitationCount)
        } else {
            UserDefaults.standard.set(1, forKey: kUnreadInvitationCount)
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: kUpdateVerification), object: nil)
    }
    
    func _logout() {
        
    }
}

