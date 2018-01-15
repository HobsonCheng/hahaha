//
//  DownData.swift
//  UIDS
//
//  Created by one2much on 2018/1/15.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

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
    
}
