//
//  MainTabBarItem.swift
//  UIDS
//
//  Created by one2much on 2018/2/11.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit


class MainTabBarItem: UIControl {
    var itemDic:TABBER_INFO
    let imgView: UIImageView
    let titleLabel: UILabel
    
    //属性观察器
    var currentSelectState = false {
        didSet{
            if currentSelectState {
                //被选中
                let iconnameSel = String.init(format: "tabBar_icon_%zd_sel", self.itemDic.index)
                let path = DownData.resoursePath_Icon()
                let path_Name_sel = String.init(format: "%@/%@.png", path,iconnameSel)
                let norimge_sel = UIImage.init(bundlePath: path_Name_sel)
                

                imgView.image = norimge_sel
                
                let getnavColor = Util.getNavBgColor()
                titleLabel.textColor = getnavColor
            }else{
                //没被选中
                let iconname = String.init(format: "tabBar_icon_%zd", self.itemDic.index)
                let path = DownData.resoursePath_Icon()
                let path_Name = String.init(format: "%@/%@.png", path,iconname)
                let norimge = UIImage.init(bundlePath: path_Name)
                
                imgView.image = norimge
                titleLabel.textColor = UIColor.lightGray
            }
        }
    }
    
    init(frame:CGRect, itemDic:TABBER_INFO, itemIndex:Int) {
        self.itemDic = itemDic
        
        //布局使用的参数
        let defaulutLabelH:CGFloat = 20.0 //文字的高度
        var imgTop:CGFloat = 3
        var imgWidth:CGFloat = 25
        //中间的按钮的布局参数做特殊处理
        if itemDic.isbigshow {
            imgTop = -20
            imgWidth = 50
        }
        let imgLeft:CGFloat = (frame.size.width - imgWidth)/2
        let imgHeight:CGFloat  = frame.size.height - defaulutLabelH - imgTop
        //图片
        imgView = UIImageView(frame: CGRect(x: imgLeft, y: imgTop, width:imgWidth, height:imgHeight))
        
        //没被选中
        let iconname = String.init(format: "tabBar_icon_%zd", self.itemDic.index)
        let path = DownData.resoursePath_Icon()
        let path_Name = String.init(format: "%@/%@.png", path,iconname)
        let norimge = UIImage.init(bundlePath: path_Name)
        
        imgView.image = norimge
        imgView.contentMode = UIViewContentMode.scaleAspectFit
        //title
        titleLabel = UILabel(frame:CGRect(x: 0, y: frame.height - defaulutLabelH, width: frame.size.width, height: defaulutLabelH))
        titleLabel.text = itemDic.pageinfo.name
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont.systemFont(ofSize: 11)
        titleLabel.textColor = UIColor.lightGray
        
        super.init(frame: frame)
        self.addSubview(imgView)
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
