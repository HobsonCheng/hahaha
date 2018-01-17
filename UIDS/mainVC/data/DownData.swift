//
//  DownData.swift
//  UIDS
//
//  Created by one2much on 2018/1/15.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import SwiftyJSON

class DownData: NSObject {
    
    static func resoursePathAppInfo()-> String{
        let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory,FileManager.SearchPathDomainMask.userDomainMask,true)
        let FileName = String.init(format: "%@/%@", documentPaths[0],"UIAppInfo.json")
        
        return FileName
    }
    static func resoursePathPageListInfo()-> String{
        let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory,FileManager.SearchPathDomainMask.userDomainMask,true)
        let FileName = String.init(format: "%@/%@", documentPaths[0],"UIPageList.json")
        
        return FileName
    }
    static func resoursePath_Icon() -> String {
        
        let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory,FileManager.SearchPathDomainMask.userDomainMask,true)
        let FileName = String.init(format: "%@", documentPaths[0])
        
        return FileName
    }
    
    //数据位置
    static func find_resourse_AppInfo()-> Bool{
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: self.resoursePathAppInfo()){
            return true
        }
    
        return false
    }
    static func find_resourse_PageListInfo()-> Bool{
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: self.resoursePathPageListInfo()){
            return true
        }
        
        return false
    }
    
    static func movingTabberIcon(big: Bool,downUrl: String,iconName: String?){
        

        SDWebImageDownloader.shared().downloadImage(with: URL.init(string: downUrl), options: SDWebImageDownloaderOptions.lowPriority, progress: nil) { (getimg, data, erro, states) in
            
            let path = DownData.resoursePath_Icon()
            
            if data != nil {//存储
            
                let path_Name = String.init(format: "%@/%@.png", path,iconName!)
                let tmpData: NSMutableData? = NSMutableData()
                tmpData?.append((data)!)
                tmpData?.write(toFile: path_Name, atomically: true)
            }
            
        }
        
    }
    
    static func findConfigData(name: String,model_id: String?,config_key: String) -> NSDictionary{
        let configData = JSON.init(parseJSON: config_key)
        
        for item in configData {//数据拆分
            let configName: String? = String(describing: item.0)
            if ((configName?.range(of: name)) != nil){
                if model_id != nil {
                    if ((configName?.range(of: model_id!)) != nil){
                        return item.1.rawValue as! NSDictionary
                    }
                }else{
                    return item.1.rawValue as! NSDictionary
                }
            }
        }
        
        return NSDictionary()
    }
    
}
