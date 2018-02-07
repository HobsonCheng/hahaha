//
//  Util.swift
//  UIDS
//
//  Created by one2much on 2018/1/8.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
//import iRate
import SVProgressHUD





private let singleUtil = Util()

final class Util: NSObject{
    
    var mainVC: UIViewController?
    var upLoadImgToken: String?
    
    static var shared: Util {
        return singleUtil
    }
    
    fileprivate override init() {
        super.init();
        //初始化 配置信息
        self.setup()
    }
    func setup(){
//        iRate.sharedInstance().delegate = self
//        // 初始化Appstore id
//        iRate.sharedInstance().applicationBundleID = "com.charcoaldesign.rainbowblocks"
//        // 启动或者回到前台就尝试提醒
//        iRate.sharedInstance().promptAtLaunch = false
//        // 每个版本都弹
//        iRate.sharedInstance().promptForNewVersionIfUserRated = true
//        // 使用几次后开始弹出
//        iRate.sharedInstance().usesUntilPrompt = 2
//        // 多少天后开始弹出，默认10次
//        iRate.sharedInstance().daysUntilPrompt = 3
//        // 选择“稍后提醒我”后的再提醒时间间隔，默认是1天
//        iRate.sharedInstance().remindPeriod = 3
//        iRate.sharedInstance().declinedThisVersion = false
    }
    func setAlertContent(){
//        let rateTitle: String = "给我评价"
//        let rateText: String = "觉得这个app怎么样，喜欢就来评价一下唄"
//
//        iRate.sharedInstance().messageTitle = rateTitle
//        iRate.sharedInstance().message = rateText
//        iRate.sharedInstance().updateMessage = rateText
//        iRate.sharedInstance().rateButtonLabel? = "喜欢，支持一下"
//        iRate.sharedInstance().remindButtonLabel? = "不喜欢，去吐槽"
//        iRate.sharedInstance().cancelButtonLabel? = "以后再说"
    }
    
    
    public func checkAndRateWithController(vc :UIViewController){
//        self.mainVC = vc
//        if iRate.sharedInstance().shouldPromptForRating(){
//            iRate.sharedInstance().promptForRating();
//        }
    }
    
    //TODO: irateDelegate
//    func iRateUserDidRequestReminderToRateApp() {
//
//    }
//    func iRateUserDidDeclineToRateApp() {
//
//    }
//    func shouldPromptForRating() -> Bool {
//        return false
//    }
    
    //MARK: 存储 user set 信息
    static func save_defult(key: String,value: String?){
        
        let userd = UserDefaults.standard
        
        userd.set(value, forKey: key)
        userd.synchronize()
    }
    static func get_defult(key: String) -> Any?{
        let userd = UserDefaults.standard
        return userd.object(forKey: key)
    }
    
    
    //MARK: 获取验证码
    static func getImgCode(callback: @escaping (_ Url: String?,_ codekey: String?)->()) {
        
        var codeUrl: String?
        
        BRequestHandler.shared.get(APIString: "authCodeKey", parameters: nil) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                let codedata = CodeMode.deserialize(from: data)?.data
                
                let temp = Int(arc4random()%10000)+1
                
                codeUrl = String.init(format: "%@/authCode?%zd&sn=uc&ac=getAuthCode&auth_type=login&code_key=%@",BRequestHandler.shared.appHostName!,temp,(codedata?.code_key)!)
                
                callback(codeUrl,codedata?.code_key)
            }
        }
    }
    static func getCodeUrl(codeKey: String) -> String {
        let temp = Int(arc4random()%10000)+1
        
        let codeUrl = String.init(format: "%@/authCode?%zd&sn=uc&ac=getAuthCode&auth_type=login&code_key=%@",BRequestHandler.shared.appHostName!,temp,(codeKey))
        
        return codeUrl
    }
    
    static func getSMSCode(phone: String,codekey: String,auth_code: String,callback: @escaping (_ code: String?) -> ()) {
        
        let params = NSMutableDictionary()
        params.setValue("getPhoneEmailAuthCode", forKey: "ac")
        params.setValue("uc", forKey: "sn")
        params.setValue("phone_login", forKey: "auth_type")
        params.setValue(codekey, forKey: "code_key")
        params.setValue(phone, forKey: "phone_Email_num")
        params.setValue(auth_code, forKey: "auth_code")
        
        
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            if B_ResponseStatus.success == status {
                callback("1111")
            }else{
                callback(nil)
            }
        }
        
    }
    
    //MARK: TOASD 1: 普通 2：成功 3： 失败
    static func msg(msg: String,_ type: Int) {
        
        let view = VCController.getTopVC()
        
        view?.view.dodo.style.bar.hideAfterDelaySeconds = 3
        view?.view.dodo.style.bar.hideOnTap = true
//        view?.view.dodo.style.bar.locationTop = false

        
        if (view?.isKind(of: NSClassFromString("NaviBarVC")!))!{
            let navToP: NaviBarVC = view as! NaviBarVC
            if navToP.naviBar() != nil {
                navToP.view.dodo.topAnchor = navToP.naviBar().bottomAnchor
            }else {
                //寻找 navi
                let navBarView = VCController.getTopVC()?.view.viewWithTag(1000000000000)
                view?.view.dodo.topAnchor = navBarView?.bottomAnchor
            }
        }else {
            //寻找 navi
            let navBarView = VCController.getTopVC()?.view.viewWithTag(1000000000000)
            view?.view.dodo.topAnchor = navBarView?.bottomAnchor
        }
        
        if type == 2 {
            view?.view.dodo.success(msg)
        }else if type == 3 {
            view?.view.dodo.error(msg)
        }else{
            view?.view.dodo.show(msg)
        }
        
    }
    
    static func getNavBgColor() -> UIColor {
        
        let bgColor: String? = Util.get_defult(key: B_USER_KEY_NAV_BG_COLOR) as? String
        
        if bgColor != nil {
            
            let bgColorObj = UIColor.init(hexString: bgColor, withAlpha: 1)
            
            return bgColorObj ?? UIColor.blue
        }
    
        return UIColor.blue
    }
    
    static func svploading(str: String) {
        
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.native)
        
        SVProgressHUD.show(withStatus: str)
    }
    
    static func svpStop(ok: Bool,callback: @escaping ()-> ()){
        
        if ok {
            SVProgressHUD.showSuccess(withStatus: "ok")
        }else {
            SVProgressHUD.showError(withStatus: "失败")
        }
        SVProgressHUD.dismiss(withDelay: 1) {
            callback()
        }
        
    }
    
    /**
     正则表达式获取目的值
     - parameter pattern: 一个字符串类型的正则表达式
     - parameter str: 需要比较判断的对象
     - imports: 这里子串的获取先转话为NSString的[以后处理结果含NS的还是可以转换为NS前缀的方便]
     - returns: 返回目的字符串结果值数组(目前将String转换为NSString获得子串方法较为容易)
     - warning: 注意匹配到结果的话就会返回true，没有匹配到结果就会返回false
     */
    static func regexGetSub(pattern:String, str:String) -> [String] {
        var subStr = [String]()
        let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        let results = regex?.matches(in: str, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, str.count))
    
        //解析出子串
        for  rst in results! {
            let nsStr = str as  NSString  //可以方便通过range获取子串
            subStr.append(nsStr.substring(with: rst.range))
            //str.substring(with: Range<String.Index>) //本应该用这个的，可以无法直接获得参数，必须自己手动获取starIndex 和 endIndex作为区间
        }
        return subStr
    }
    
    static func strToByte(str: String) -> [Character]{
        var bytes: [Character] = [Character]()
        for ch in str.characters {
            bytes.append(ch)
        }
        return bytes
    }
    
}


// MARK:- 常用按钮颜色

let kThemeWhiteColor = UIColor.init(hexString: "0xFFFFFF")
let kThemeWhiteSmokeColor = UIColor.init(hexString: "0xF5F5F5")
let kThemeGainsboroColor = UIColor.init(hexString: "0xF3F4F5")  // 亮灰色
let kThemeOrangeRedColor = UIColor.init(hexString: "0xFF4500")  // 橙红色
let kThemeSnowColor = UIColor.init(hexString: "0xFFFAFA")
let kThemeLightGreyColor = UIColor.init(hexString: "0xD3D3D3")
let kThemeGreyColor = UIColor.init(hexString: "0xA9A9A9")
let kThemeTomatoColor = UIColor.init(hexString: "0x5c92e0")
let kThemeDimGrayColor = UIColor.init(hexString: "0x696969")
let kThemeBlackColor = UIColor.init(hexString: "0x000000")
let kThemeBackgroundColor = UIColor.init(hexString: "0xF4F4F4")
let kThemeTitielColor = UIColor.init(hexString: "0x9E9E9E")


// 屏幕宽度
let kScreenH = UIScreen.main.bounds.height
// 屏幕高度
let kScreenW = UIScreen.main.bounds.width


// MARK:- 常量
struct MetricGlobal {
    static let padding: CGFloat = 10.0
    static let margin: CGFloat = 10.0
}


//适配iPhoneX
let is_iPhoneX = (kScreenW == 375.0 && kScreenH == 812.0 ?true:false)
let kNavibarH: CGFloat = is_iPhoneX ? 88.0 : 64.0
let kTabbarH: CGFloat = is_iPhoneX ? 49.0+34.0 : 49.0
let kStatusbarH: CGFloat = is_iPhoneX ? 44.0 : 20.0
let iPhoneXBottomH: CGFloat = 34.0
let iPhoneXTopH: CGFloat = 24.0



