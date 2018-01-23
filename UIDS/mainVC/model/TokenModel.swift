//
//  TokenModel.swift
//  UIDS
//
//  Created by one2much on 2018/1/23.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class TokenModel: BaseModel {

    var data: TokenData?
}

class TokenData : HandyJSON {
    
    var token: String?
    var name: String?
    
    required init() {}
}
