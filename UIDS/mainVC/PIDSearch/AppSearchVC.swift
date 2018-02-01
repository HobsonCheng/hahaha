//
//  AppSearchVC.swift
//  UIDS
//
//  Created by one2much on 2018/2/1.
//  Copyright © 2018年 one2much. All rights reserved.
//
//寻找单位app
import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import Then
import RxGesture
import ReusableKit
import RxDataSources


protocol AppSearchVCDelectege {
    
    //搜索结束
    func SearchpidEnd(pidObj: Any?)
    
}


class AppSearchVC: NaviBarVC {

    var delegate: AppSearchVCDelectege?
    
    
    var searchBar: UISearchBar!
    var resultsTableView: UITableView!
    var EmptyView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.genderUI()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
//gender ui
extension AppSearchVC {
    
    fileprivate func genderUI() {
        //search
        self.searchBar = UISearchBar().then{
            $0.frame = CGRect.init(x: 0, y: self.naviBar().bottom - 44, width: kScreenW, height: 40)
            $0.placeholder = "搜索"
        }
        self.naviBar().addSubview(self.searchBar)
        
        //table
        let tableView = UITableView(frame: .zero, style: .plain).then{
            $0.backgroundColor = .clear
            $0.separatorStyle = .none
            $0.tableFooterView = UIView()
        }
        self.view.addSubview(tableView)
        self.resultsTableView = tableView
        
        self.resultsTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.naviBar().bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

extension AppSearchVC{
    
   
}
