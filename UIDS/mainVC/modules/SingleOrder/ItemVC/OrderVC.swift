//
//  OrderVC.swift
//  UIDS
//
//  Created by one2much on 2018/1/25.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import Then
import RxGesture
import ReusableKit
import RxDataSources
import Differentiator
import SwiftyJSON
import ESPullToRefresh


public enum ORDER_TYPE: Int {
    case grab = 1 //抢单
    case oning //正在进行
    case over //完成
}

// MARK:- 复用
private enum Reusable {
    
    static let grapCell = ReusableCell<GrapCell>(nibName: "GrapCell")
    static let noingCell = ReusableCell<OrderCell>(nibName: "OrderCell")
    static let overCell = ReusableCell<OrderTwoCell>(nibName: "OrderTwoCell")
}

// MARK:- 常量
fileprivate struct MetricAppSet {
    
    static let cellHeight: CGFloat = 49.0
    static let sectionHeight: CGFloat = 10.0
}


class OrderVC: BaseNameVC {

    var orderType: ORDER_TYPE? = ORDER_TYPE.grab
    
    // viewModel
    fileprivate var viewModel = OrderViewModel()
    
    // View
    fileprivate var tableView: UITableView!
    
    // DataSuorce
    var in_dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, OrderCData>>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUI()
        self.bindUI()
        
        self.refreshUI()
        
        if self.orderType == ORDER_TYPE.grab {
            
            self.initWS()
            
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}

//MARK: - 刷新植入
extension OrderVC {
    
    func refreshUI() {
        
        //上拉  下拉
        var header: ESRefreshProtocol & ESRefreshAnimatorProtocol
        var footer: ESRefreshProtocol & ESRefreshAnimatorProtocol
        
        header = DS2RefreshHeader.init(frame: CGRect.zero)
        footer = DS2RefreshFooter.init(frame: CGRect.zero)
        
        self.tableView?.es.addPullToRefresh(animator: header) { [weak self] in
            self?.refreshEvent()
        }
        self.tableView?.es.addInfiniteScrolling(animator: footer) { [weak self] in
            self?.loadMore()
        }
    }
    
    
    
    func getData() {
        
        if self.orderType == ORDER_TYPE.grab {

            
            viewModel.getGarp(params: NSMutableDictionary(), callback: { [weak self] in
                self?.tableView.es.stopPullToRefresh()
            })
            
        }else if self.orderType == ORDER_TYPE.oning {
            
            let params = NSMutableDictionary()
            params.setSafeObject("1", forKey: "status" as NSCopying)
            params.setSafeObject("1", forKey: "page" as NSCopying)
            params.setSafeObject("20", forKey: "page_context" as NSCopying)
            
            viewModel.getOrderList(params: params, callback: { [weak self] in
                self?.tableView.es.stopPullToRefresh()
            })
            

        }else if self.orderType == ORDER_TYPE.over {
            
            let params = NSMutableDictionary()
            params.setSafeObject("2", forKey: "status" as NSCopying)
            params.setSafeObject("1", forKey: "page" as NSCopying)
            params.setSafeObject("20", forKey: "page_context" as NSCopying)

            viewModel.getOrderList(params: params, callback: { [weak self] in
                self?.tableView.es.stopPullToRefresh()
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {[weak self] in
            self?.tableView.es.stopPullToRefresh()
            self?.tableView.es.stopLoadingMore()
        }
    }
    
    func refreshEvent() {
        
        self.getData()
    
    }
    private func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.tableView.es.noticeNoMoreData()
        }
    }
    
}


extension OrderVC {
    
    // MARK:- 初始化视图
    fileprivate func initUI() {
        
        self.view.width = kScreenW
        
        let tableView = BaseTableView(frame: .zero, style: .plain)
        tableView.backgroundColor = kThemeWhiteColor
        tableView.separatorStyle = .none
//        tableView.tableFooterView = UIView()
        tableView.config()
        view.addSubview(tableView)
        self.tableView = tableView
        
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        // 设置代理
        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        
        // 注册cell
        if self.orderType == ORDER_TYPE.grab {
            tableView.register(Reusable.grapCell)
        }else if self.orderType == ORDER_TYPE.oning {
            tableView.register(Reusable.noingCell)
        }else if self.orderType == ORDER_TYPE.over {
            tableView.register(Reusable.overCell)
        }

    }
    
    // MARK:- 绑定视图
    func bindUI() {
    
        self.in_dataSource = RxTableViewSectionedReloadDataSource(configureCell: { (ds, tv, indexPath, item) -> UITableViewCell in
            
            // 注册cell
            if self.orderType == ORDER_TYPE.grab {
                
            }else if self.orderType == ORDER_TYPE.oning {
                let cell = tv.dequeue(Reusable.noingCell,for: indexPath)
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.cellData = item
                
                cell.changeEvent.asObservable().do(onNext: { [weak self] obj in
                    
                    if obj.eventType != -1 {
                        
                        self?.tableView.es.startPullToRefresh()
                    }
                    
                }).subscribe().disposed(by: self.rx.disposeBag)
                
                return cell
            }else if self.orderType == ORDER_TYPE.over {
                let cell = tv.dequeue(Reusable.overCell, for: indexPath)
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.cellData = item
        
                return cell
            }
            
            let cell = tv.dequeue(Reusable.grapCell, for: indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.cellData = item
            return cell
        })
        
        viewModel.orderList.asObservable().bind(to: self.tableView.rx.items(dataSource: (self.in_dataSource)!)).disposed(by: rx.disposeBag)
        
        self.getData()
    }
}

// MARK:- UITableViewDelegate
extension OrderVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let itemData = viewModel.orderList.value[indexPath.section].items[indexPath.row]

        // 注册cell
        let getStr = JSON.init(parseJSON: (itemData.value)!).rawString()?.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "")
        let size = getStr?.getSize(font: UIFont.systemFont(ofSize: 15), viewWidth: kScreenW - 30.0)
        if self.orderType == ORDER_TYPE.grab {

        }else if self.orderType == ORDER_TYPE.oning {

            return 183 - 37 + (size?.height)!

        }
        else if self.orderType == ORDER_TYPE.over {
            return 67 + (size?.height)!
        }
        
        return 183 - 37 + (size?.height)!
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        
    }
}
//webstock
extension OrderVC: WSUtilDelegate{

    func initWS(){
        //WSUtil
        let ws = WSUtil.share()
        ws.delegate = self
        ws.connectSever()
    }
    
    
    func websocketDidConnect(sock: WSUtil) {
        
    }
    
    func websocketDidDisconnect(socket: WSUtil, error: NSError?) {
        
    }
    
    func websocketDidReceiveMessage(socket: WSUtil, text: String) {
        
    }
    
    func websocketDidReceiveData(socket: WSUtil, data: NSData) {
        
    }
    func callBackOrderStaus(order: NoticObj?, cancel: Bool) {
        
        var getobj: OrderCData?
        var count = 0
        if viewModel.orderList.value.count == 0 {
            return
        }
        for item in viewModel.orderList.value[0].items {
            if item.notify_id == order?.id {
                getobj = item
                break
            }
            count = count+1
        }
        
        var msg: String = ""
        let user = UserUtil.share.appUserInfo
        if cancel {

            if order?.uid == user?.uid{
                return
            }
            if let order = getobj?.classify_name{
                msg = "订单：\(order) 被抢了"
            }
            
            
            viewModel.orderList.value[0].items.remove(at: count)
            
        }else {
            if order?.uid == user?.uid{
                return
            }
            msg = "有新订单了，快去看看"
            
            let newOrderStr = order?.content
            
            if let newOrder = OrderCData.deserialize(from: newOrderStr){
                viewModel.orderList.value[0].items.insert(newOrder, at: 0)
            }
        }
        
        Util.msg(msg: msg, 1)
    }
}

