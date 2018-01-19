//
//  RootVC.swift
//  UIDS
//
//  Created by one2much on 2018/1/10.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import Dodo

class RootVC: NaviBarVC{

    var pageData: PageInfo?
    var moduleList: NSArray?
    var mainView: MainScrollView?
    var mainTable: UITableView?
    var startY: CGFloat?
    var leftList: NSArray?
    var rightList: NSArray?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNaviDefulat()
        
        self.naviBar().setTitle(self.pageData?.name)
        
        if(self.pageData?.parent_id == 0){
            self.naviBar().setLeftBarItem(nil)
            self.goto()
            
        }else{
            
            
            self.view.dodo.success("hello bai")
            self.startLoadBlock(nil, withHint: "加载中...")
            
            let params = NSMutableDictionary()
            params.setValue(self.pageData?.page_key, forKey: "page_key")
            params.setValue("0", forKey: "client_type")
            params.setValue(self.pageData?.page_id, forKey: "page_id")
            
            ApiUtil.share.getPage(params: params, fininsh: { [weak self] (status, data, msg) in
                self?.pageData = PageInfoModel.deserialize(from: data)?.data
                
                self?.stopLoadBlock()
                self?.view.dodo.hide()
                
                self?.goto()
                
            })
            
        }
    
    }
    
    private func goto() {
        
        self.startY = 0;
        self.mainView = MainScrollView.init(frame: CGRect.init(x: 0, y: self.naviBar().bottom, width: self.view.width, height: self.view.height - self.naviBar().bottom - 50));
        self.view.addSubview(self.mainView!)
    
        self.initAppInfo()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //数据分析

    
    //MARK: 协议
    

}
