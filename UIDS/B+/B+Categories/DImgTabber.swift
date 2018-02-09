//
//  DImgTabber.swift
//  UIDS
//
//  Created by one2much on 2018/1/16.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class DImgTabber: ESTabBarItem {

    public init(contentView: ESTabBarItemContentView, title: String?, image: String?, selectedImage: String?, tag: Int = 0) {
        

        let iconname = String.init(format: "tabBar_icon_%zd", tag)
        let iconnameSel = String.init(format: "tabBar_icon_%zd_sel", tag)
    
        let path = DownData.resoursePath_Icon()
        let path_Name = String.init(format: "%@/%@.png", path,iconname)
        let norimge = UIImage.init(bundlePath: path_Name)
        
        
        let path_Name_sel = String.init(format: "%@/%@.png", path,iconnameSel)
        let norimge_sel = UIImage.init(bundlePath: path_Name_sel)
     
    
        
        super.init(contentView, title: title, image: norimge, selectedImage: norimge_sel, tag: tag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
