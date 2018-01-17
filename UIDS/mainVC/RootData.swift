//
//  RootData.swift
//  UIDS
//
//  Created by one2much on 2018/1/15.
//  Copyright © 2018年 one2much. All rights reserved.
//

import Foundation
import SwiftyJSON

extension RootVC {
    
    func initAppInfo(){
        
        //MARK: 数据刷新
        
        self.updateVC()
        
        //获取数据开启 页面绘制
        self.genderModelList()
        
    }
    
    func findConfigData(name: String,model_id: String) -> NSDictionary{
        return DownData.findConfigData(name: name, model_id: model_id, config_key: (self.pageData?.config_key)!)
    }
    
    private func updateVC(){
        
        let navibarJson = JSON.init(parseJSON: (self.pageData?.config_key)!)
        
        for item in navibarJson {//数据拆分
            let configName: String? = String(describing: item.0)
            if ((configName?.range(of: "module_NaviBarView_NaviBar_layout")) != nil){
                
                let navibarLayout = item.1.rawValue
                self.navibar_layout(dic: navibarLayout as! NSDictionary)
                print("sdsadd")
                
                
            }else if ((configName?.range(of: "module_NaviBarView_NaviBar_content")) != nil){
                let navibarContent = item.1.rawValue
                self.navibar_content(dic: navibarContent as! NSDictionary)
            }
        
        }
    
    }
    
    private func navibar_layout(dic: NSDictionary)  {
        
        let bgData = dic.object(forKey: "bg")
        
        let colorStr = (bgData! as! NSDictionary).object(forKey: "bgColor") as! String
        
        let bgColor = UIColor.init(hexString: colorStr, withAlpha: 1)
    
        Util.save_defult(key: B_USER_KEY_NAV_BG_COLOR, value: colorStr)
        
        self.naviBar().setNaviBarBackgroundColor(bgColor)
        
    }
    private func navibar_content(dic: NSDictionary) {
        
        let centerObj = dic["center"]
        self.naviBar().setTitle((centerObj as! NSDictionary).object(forKey: "title") as! String)
        self.naviBar().setTitleColor((centerObj as! NSDictionary).object(forKey: "color") as! String)
        
        let leftList = dic["leftList"]
        self.navibar_leftViews(list: leftList as! NSArray)
        let rightList = dic["rightList"]
        self.navibar_rightViews(list: rightList as! NSArray)
        
    }
    
    private func navibar_leftViews(list: NSArray){
        
        let leftlist = NSMutableArray()
        //整理
        for (index,item) in list.enumerated() {
            
            let pageData = PageInfo.deserialize(from: item as? NSDictionary)
            
            let left = NaviBarItem.init(imageItem: CGRect.init(x: 0, y: 0, width: 44, height: 22), target: self, action: #selector(RootVC.touchLeft))
            left?.tag = index
            left?.setIconImageUrl(pageData?.icon, for: eNaviBarItemStateNormal)
            left?.setIconImageUrl(pageData?.icon_sel, for: eNaviBarItemStateHighlighted)
            
            leftlist.add(left!)
        }
        
        self.naviBar().leftBarItems = leftlist as! [Any]
    }
    
    private func navibar_rightViews(list: NSArray){
        
        let rightlist = NSMutableArray()
        //整理
        for (index,item) in list.enumerated() {
            
            let pageData = PageInfo.deserialize(from: item as? NSDictionary)
            
            let right = NaviBarItem.init(imageItem: CGRect.init(x: 0, y: 0, width: 44, height: 22), target: self, action: #selector(RootVC.touchLeft))
            right?.tag = index
            right?.setIconImageUrl(pageData?.icon, for: eNaviBarItemStateNormal)
            right?.setIconImageUrl(pageData?.icon_sel, for: eNaviBarItemStateHighlighted)
            
            rightlist.add(right!)
        }
        
        self.naviBar().rightBarItems = rightlist as! [Any]
    }
    
    
    @objc func touchLeft() {
        
    }
}
