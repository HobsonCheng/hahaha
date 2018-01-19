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
    var headPortrait : String!
    var id : Int!
    var interests : String!
    var labels : String!
    var nickName : String!
    var pid : Int!
    var signature : String!
    var uid : Int!

    var addTime : String!
    var header : String!
    var status : Int!
    var updateTime : String!
    var userCode : String!
    var userCodeCode : Int!
    var username : String!
    var usernameCode : Int!
    var zhName : String!
    
    required init() {}
}
