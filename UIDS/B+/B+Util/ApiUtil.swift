//
//  ApiUtil.swift
//  UIDS
//
//  Created by one2much on 2018/1/19.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

typealias ApiUtilFinished = (_ status: B_ResponseStatus, _ result: String?, _ tipString: String?) -> ()

class ApiUtil: NSObject {

    static let share = ApiUtil()
    
    //MARK: - 注册
    func userRegist(params: NSMutableDictionary,fininsh: ApiUtilFinished?) {
        
        params.setValue("uc", forKey: "sn")
        params.setValue("userRegist", forKey: "ac")
        params.setValue("regist", forKey: "auth_code_type")
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                fininsh?(status,data,msg)
            }else {
                Util.msg(msg: msg!, 3)
            }
        }
    }
    //MARK: - 登录
    func userLogin(params: NSMutableDictionary,fininsh: ApiUtilFinished?) {
        
        params.setValue("uc", forKey: "sn")
        params.setValue("userLogin", forKey: "ac")
        params.setValue("login", forKey: "auth_code_type")
        
        BRequestHandler.shared.get(APIString: "userLogin", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                fininsh?(status,data,msg)
            }else {
                Util.msg(msg: msg!, 3)
            }
        }
    }
    //MARK: - phone 登录
    func userLoginByPhone(params: NSMutableDictionary,fininsh: ApiUtilFinished?) {
        
        params.setValue("uc", forKey: "sn")
        params.setValue("userLoginByPhone", forKey: "ac")
        params.setValue("login", forKey: "auth_code_type")
        
        BRequestHandler.shared.get(APIString: "userLoginByPhone", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                fininsh?(status,data,msg)
            }else {
                Util.msg(msg: msg!, 3)
            }
        }
    }
    
    //MARK: - 获取页面信息
    func getPage(params: NSMutableDictionary,fininsh: ApiUtilFinished?) {
        
        params.setValue("project", forKey: "sn")
        params.setValue("getPage", forKey: "ac")
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                fininsh?(status,data,msg)
            }else {
                Util.msg(msg: msg!, 3)
            }
        }
    }
    
    //MARK: - 获取所有页面
    func getPageList(fininsh: ApiUtilFinished?) {
        
        let params = NSMutableDictionary()
        params.setValue("project", forKey: "sn")
        params.setValue("getPageKeyList", forKey: "ac")
        
        let appinfo = AppInfoData.shared.appModel
        params.setValue(appinfo?.app_id, forKey: "app_id")
        params.setValue(appinfo?.group_id, forKey: "group_id")
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                fininsh?(status,data,msg)
            }else {
                Util.msg(msg: msg!, 3)
            }
        }
    }
    //MARK: - 推荐新闻
    func getInvitationList(params: NSMutableDictionary,fininsh: ApiUtilFinished?)  {
        params.setValue("getInvitationList", forKey: "ac")
        params.setValue("cms", forKey: "sn")
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                fininsh?(status,data,msg)
            }else {
                Util.msg(msg: msg!, 3)
            }
        }
    }
    //MARK: - 话题列表
    func getGroupList(params: NSMutableDictionary,fininsh: ApiUtilFinished?)  {
        params.setValue("getGroupList", forKey: "ac")
        params.setValue("cms", forKey: "sn")
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                fininsh?(status,data,msg)
            }else {
                Util.msg(msg: msg!, 3)
            }
        }
    }
    //MARK: - 创建群组
    func addGroup(params: NSMutableDictionary,fininsh: ApiUtilFinished?) {
        params.setValue("addGroup", forKey: "ac")
        params.setValue("cms", forKey: "sn")
        params.setValue("4", forKey: "classify_id")
        params.setValue("1", forKey: "has_sign_in")
        params.setValue("1", forKey: "invitation_authority")
        params.setValue("1", forKey: "reply_authority")
        params.setValue("2", forKey: "replay_authority")
        params.setValue("1", forKey: "attachment")
        params.setValue("cms", forKey: "sn")
        
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                fininsh?(status,data,msg)
            }else {
                Util.msg(msg: msg!, 3)
            }
        }
    }
    //MARL:- 发布话题
    func addInvitation(params: NSMutableDictionary,fininsh: ApiUtilFinished?)  {
        params.setValue("addInvitation", forKey: "ac")
        params.setValue("cms", forKey: "sn")
        params.setValue("1", forKey: "can_reply")
        params.setValue("2", forKey: "can_replay")
        params.setValue("1", forKey: "can_store")
        params.setValue("1", forKey: "can_out")
        params.setValue("2", forKey: "can_see_reply")
        params.setValue("1", forKey: "use_signature")
        params.setValue("1", forKey: "attechment")
        params.setValue("1", forKey: "pay_type")
        params.setValue("一几网络_IOS", forKey: "source")
        params.setValue("119", forKey: "x_coord")
        params.setValue("39", forKey: "y_coord")
        
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                fininsh?(status,data,msg)
            }else {
                Util.msg(msg: msg!, 3)
            }
        }
    }
    //MARK: - 获取token 七牛云
    func getuptoken(callback: (_ token: String) -> ()) {
        let getTokenApi = "http://121.42.154.36:11124/getuptoken"
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    
                    // Print out dictionary
                    print(convertedJsonIntoDict)
                    
                    // Get value by key
                    let firstNameValue = convertedJsonIntoDict["userName"] as? String
                    print(firstNameValue!)
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
        
        
    }
}
