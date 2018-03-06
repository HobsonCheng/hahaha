
//
//  NotifyListVC.swift
//  UIDS
//
//  Created by Hobson on 2018/3/3.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import SwiftyJSON
class NotifyListVC: NaviBarVC,UITableViewDelegate,UITableViewDataSource {
    //传递给cell的数据源
    var notifyData:[NotifyData]?
    
    lazy var table: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: self.naviBar().bottom, width: kScreenW, height: kScreenH - self.naviBar().bottom), style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.rowHeight = 80
        return tableView
    }()
    
    // 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        genderUI()
        getData()
        //注册cell
        self.table.register(UINib.init(nibName: "NotifyCell", bundle: nil), forCellReuseIdentifier: "Notify")
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    //Mark:- 获取数据
    func getData(){
        let params = NSMutableDictionary()
        params.setValue(1, forKey: "page")
        params.setValue(20, forKey: "page_context")
        ApiUtil.share.getNotification(params: params) { [weak self](status, data, msg) in
            self?.notifyData = NotifyModel.deserialize(from: data)?.data
            self?.table.reloadData()
        }
    }
    // Mark:- 获取未读数量
    func getUnreadNumber()->Int{
        var unread = 0
        ApiUtil.share.getUnreadNotficationTotal { (status, data, msg) in
            let obj = UnreadModel.deserialize(from: data)
            unread = (obj?.data)!
        }
        return unread
    }
    // MARK:-
    func genderUI(){
        //设置导航栏
        self.setNaviDefulat()
        if getUnreadNumber() <= 0{
            self.naviBar().setTitle("消息列表")
        }else{
            self.naviBar().setTitle("消息列表(\(getUnreadNumber()))")
        }
        
        self.view.addSubview(self.table)
    }
    
    
}

// MARK:- tableview delegate
extension NotifyListVC{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.notifyData?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "Notify") as! NotifyCell
        cell.cellData = notifyData?[indexPath.row]
        return cell
    }
}
