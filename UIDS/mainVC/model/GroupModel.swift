//
//  GroupModel.swift
//  UIDS
//
//  Created by bai on 2018/1/20.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class GroupModel: BaseModel {
    var data: [GroupData]?
}

class GroupData: HandyJSON {
    
    var addTime : String!
    var addType : Int!
    var address : String!
    var areaId : Int!
    var attachment : Int!
    var blockId : Int!
    var buildUid : Int!
    var canOut : Int!
    var canShare : Int!
    var canSubscribe : Int!
    var cityId : Int!
    var classifyId : Int!
    var countryId : Int!
    var currentTop : Int!
    var groupStencil : Int!
    var groupType : Int!
    var hasSignIn : Int!
    var id : Int!
    var identify : Int!
    var indexId : String!
    var indexPic : String!
    var introduction : String!
    var invitationAuthority : Int!
    var invitationNum : Int!
    var invitationTypes : String!
    var labels : String!
    var maxBM : Int!
    var maxTop : Int!
    var maxUser : Int!
    var name : String!
    var nameCode : Int!
    var payPerpetualMoney : Int!
    var payTemporaryMoney : String!
    var payType : Int!
    var pid : Int!
    var proId : Int!
    var replayAuthority : Int!
    var replyAuthority : Int!
    var scoreRule : String!
    var status : Int!
    var updateTime : String!
    var useJurisdiction : Int!
    var userAuthority : Int!
    var userNum : Int!
    var xCoord : Int!
    var yCoord : Int!
    
    required init() {}
}
