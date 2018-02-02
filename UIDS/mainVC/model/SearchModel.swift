//
//  SearchModel.swift
//  UIDS
//
//  Created by one2much on 2018/2/2.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

struct SearchModel: HandyJSON {
    var data : SearchData!
}

struct SearchData: HandyJSON {
    
    var projects : [Project]!
    var total : Int!
}

struct ProjectList: HandyJSON {
    var data: [Project]!
}

struct Project: HandyJSON {
    
    var app_name: String!
    var add_time : String!
    var icon : String!
    var industry_id : Int!
    var intro_info : String!
    var pid : Int!
    var pname : String!
    var pname_code : Int!
    var group_id: Int!
    
}


