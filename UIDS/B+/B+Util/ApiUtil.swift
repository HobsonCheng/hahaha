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
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
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
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
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
}
