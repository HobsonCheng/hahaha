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
        super.init()
        self.contentView = contentView
        
        let tmpimage = image?.replacingOccurrences(of: "?imageMogr2/thumbnail/50x50!", with: "").replacingOccurrences(of: "?imageMogr2/thumbnail/60x60!", with: "")
        
        let getImgName: String!
        
        if title != nil {
            getImgName = String.init(format: "%@?imageMogr2/thumbnail/46x46!", tmpimage!)
        }else{
            getImgName = String.init(format: "%@?imageMogr2/thumbnail/140x140!", tmpimage!)
        }
        
        
        let iconname = String.init(format: "tabBar_icon_%zd@2x", tag)
        
        DownData.movingTabberIcon(big: false, downUrl: getImgName, iconName: iconname)
        
        
        let tmpimageSel = selectedImage?.replacingOccurrences(of: "?imageMogr2/thumbnail/50x50!", with: "").replacingOccurrences(of: "?imageMogr2/thumbnail/60x60!", with: "")
        
        let getImgNameSel: String!
        if title != nil {
            getImgNameSel = String.init(format: "%@?imageMogr2/thumbnail/46x46!", tmpimageSel!)
        }else{
            getImgNameSel = String.init(format: "%@?imageMogr2/thumbnail/140x140!", tmpimageSel!)
        }
        
        
        let iconnameSel = String.init(format: "tabBar_icon_%zd_sel@2x", tag)
        
        DownData.movingTabberIcon(big: false, downUrl: getImgNameSel, iconName: iconnameSel)
        
        
        self.title = title
        
        self.tag = tag
    
        let path = DownData.resoursePath_Icon()
        let path_Name = String.init(format: "%@/%@.png", path,iconname)
        let norimge = UIImage.init(bundlePath: path_Name)
        // 设置图标
        if norimge != nil {
            self.image = norimge!
        }else{
            self.image = UIImage.init(named: "home")
        }
        
        let path_Name_sel = String.init(format: "%@/%@.png", path,iconnameSel)
        let norimge_sel = UIImage.init(bundlePath: path_Name_sel)
     
        // 设置图标
        if norimge_sel != nil {
            self.selectedImage = norimge_sel!
            if title == nil {
                self.image = norimge_sel!
            }
        }else{
            self.selectedImage = UIImage.init(named: "home_1")
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
