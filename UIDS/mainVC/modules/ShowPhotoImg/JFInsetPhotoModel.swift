//
//  JFInsetPhotoModel.swift
//  UIDS
//
//  Created by one2much on 2018/1/24.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class JFInsetPhotoModel: NSObject {

    // 图片占位字符
    var ref: String?
    
    // 图片描述
    var caption: String?
    
    // 图片url
    var url: String?
    
    // 宽度
    var widthPixel: CGFloat = 0
    
    // 高度
    var heightPixel: CGFloat = 0
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}
