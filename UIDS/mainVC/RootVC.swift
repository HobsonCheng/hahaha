//
//  RootVC.swift
//  UIDS
//
//  Created by one2much on 2018/1/10.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
//import Dodo

typealias ESCallBack = () -> ()
typealias VCRefreshCallBack = () -> ()

class RootVC: NaviBarVC{

    var pageData: PageInfo?
    var moduleList: NSArray?
    var mainView: MainScrollView?
    var mainTable: UITableView?
    var startY: CGFloat?
    var leftList: NSArray?
    var rightList: NSArray?
    var isHomePage: Bool! = false
    
    
    public var refreshCallback: VCRefreshCallBack?
    public var esCallBack: ESCallBack?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNaviDefulat()
        
        self.naviBar().setTitle(self.pageData?.name)
        
        if(self.pageData?.parent_id == 0){
            self.naviBar().setLeftBarItem(nil)
            self.goto()
            
        }else{
            
            self.startLoadBlock(nil, withHint: "加载中...")
            self.requestPageInfo()
    
        }
    }
    
    public func requestPageInfo(){
        
        let params = NSMutableDictionary()
        params.setValue(self.pageData?.page_key, forKey: "page_key")
        params.setValue("0", forKey: "client_type")
        params.setValue(self.pageData?.page_id, forKey: "page_id")
        
        ApiUtil.share.getPage(params: params, fininsh: { [weak self] (status, data, msg) in
            let tmpObj = self?.pageData?.anyObj
            self?.pageData = PageInfoModel.deserialize(from: data)?.data
            self?.pageData?.anyObj = tmpObj
            
            
            self?.naviBar().setTitle(self?.pageData?.name)
            
            self?.stopLoadBlock()
    
            self?.goto()
            
        })
    }
    
    private func goto() {
        
        self.startY = 0;
        
        self.mainView = MainScrollView.init(frame: CGRect.init(x: 0, y: self.naviBar().bottom, width: self.view.width, height: self.view.height - self.naviBar().bottom - 50))
        if !self.isHomePage! {
            self.mainView?.height = self.view.height - self.naviBar().bottom
        }
        self.view.addSubview(self.mainView!)
    
        self.initAppInfo()
    
        self.genderRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //数据分析

    
    //MARK: 协议
    

}
