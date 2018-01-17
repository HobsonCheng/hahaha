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
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNaviDefulat()
        
        if(self.pageData?.parent_id == 0){
            self.naviBar().setLeftBarItem(nil)
        }
        
        self.naviBar().setTitle("首页")
        
        self.view.dodo.success("hello bai")
        
        
        self.startY = 0;
        self.mainView = MainScrollView.init(frame: CGRect.init(x: 0, y: self.naviBar().bottom, width: self.view.width, height: self.view.height - self.naviBar().bottom - 50));
        self.view.addSubview(self.mainView!)
        
        
        self.startLoadBlock(nil, withHint: "加载中...")
        
        self.initAppInfo()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            
            self.stopLoadBlock()
            self.view.dodo.hide()
            
            let nextv = LoginView.init(name: "LoginView")
            VCController.push(nextv!, with: VCAnimationBottom.defaultAnimation());
        };
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //数据分析

    
    //MARK: 协议
    

}
