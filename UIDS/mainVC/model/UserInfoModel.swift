//
//  UserInfoModel.swift
//  UIDS
//
//  Created by one2much on 2018/1/16.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class UserInfoModel: BaseModel {
    var data: UserInfoData?
}

class UserInfoData: HandyJSON {
    
    var birthday : String!
    var explanation : String!
    var gender : Int!
    var head_portrait : String!
    var id : Int!
    var interests : String!
    var labels : String!
    var nick_name : String!
    var pid : Int!
    var signature : String!
    var uid : Int!

    var add_time : String!
    var header : String!
    var status : Int!
    var update_time : String!
    var user_code : String!
    var user_code_code : Int!
    var username : String!
    var username_code : Int!
    var zh_name : String!
    
    
    var Authorization: String!
    
    required init() {}
}
