//
//  NaviDefult.swift
//  UIDS
//
//  Created by one2much on 2018/1/17.
//  Copyright © 2018年 one2much. All rights reserved.
//

import Foundation

extension NaviBarVC {
    
    
    
    
    public func setNaviDefulat(){
        
//        self.view.dodo.topAnchor = self.naviBar().bottomAnchor
        
        let bgColor: String? = Util.get_defult(key: B_USER_KEY_NAV_BG_COLOR) as? String
        
        if bgColor != nil {
            
            let bgColor = UIColor.init(hexString: bgColor, withAlpha: 1)
        
            self.naviBar().setNaviBarBackgroundColor(bgColor)
        }
    }
    
}
