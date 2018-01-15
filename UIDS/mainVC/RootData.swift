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
        let configData = JSON.init(parseJSON: (self.pageData?.config_key)!)
        
        for item in configData {//数据拆分
            let configName: String? = String(describing: item.0)
            if ((configName?.range(of: name)) != nil){
                if !model_id.isEmpty {
                    if ((configName?.range(of: model_id)) != nil){
                        return item.1.rawValue as! NSDictionary
                    }
                }else{
                    return item.1.rawValue as! NSDictionary
                }
            }
        }
        
        return NSDictionary()
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
        
        let bgColor = UIColor.init(hexString: (bgData! as! NSDictionary).object(forKey: "bgColor") as! String, withAlpha: 1)
    
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
        
    }
    
    private func navibar_rightViews(list: NSArray){
        
    }
    
}
