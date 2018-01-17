//
//  AritcleModel.swift
//  UIDS
//
//  Created by one2much on 2018/1/16.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class AritcleModel: BaseModel {
    
    var data: [AritcleItem]?
    
}

class AritcleItem: HandyJSON {
    
    var addTime : String!
    var address : String!
    var allValNum : Int!
    var areaId : Int!
    var attachment : Int!
    var attachmentDownload : Int!
    var attachmentSize : Int!
    var attachmentValue : String!
    var best : Int!
    var blockId : Int!
    var buildUid : Int!
    var canOut : Int!
    var canReplay : Int!
    var canReply : Int!
    var canSeeReply : Int!
    var canStore : Int!
    var cityId : Int!
    var content : String!
    var countryId : Int!
    var groupId : Int!
    var groupInvitationId : Int!
    var id : Int!
    var identify : Int!
    var indexId : String!
    var intraId : Int!
    var invitationType : Int!
    var isEmpty : Int!
    var labels : String!
    var lastReadUrl : String!
    var lastReplyTime : String!
    var lastVersion : Int!
    var payPerpetualMoney : Int!
    var payTemporaryMoney : String!
    var payType : Int!
    var pid : Int!
    var praiseNum : Int!
    var proId : Int!
    var readNum : Int!
    var remarks : String!
    var replay : AnyObject!
    var replayNum : Int!
    var source : String!
    var sourcePid : Int!
    var status : Int!
    var storeNum : Int!
    var subclass : Int!
    var summarize : String!
    var task : AnyObject!
    var title : String!
    var topicId : Int!
    var updateTime : String!
    var useSignature : Int!
    var userAuthority : Int!
    var userInfo : UserInfoData!
    var vote : AnyObject!
    var xCoord : Int!
    var yCoord : Int!
    
    
    required init() {}
}
