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


public enum ORDER_TYPE: Int {
    case grab = 1 //抢单
    case oning //正在进行
    case over //完成
}

// MARK:- 复用
private enum Reusable {
    
    static let grapCell = ReusableCell<GrapCell>()
    static let noingCell = ReusableCell<GrapCell>()
    static let overCell = ReusableCell<GrapCell>()
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
    var dataSource : RxTableViewSectionedReloadDataSource<[SectionModelType<OrderCellModel>]>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initUI()
        self.bindUI()
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}


extension OrderVC {
    
    // MARK:- 初始化视图
    fileprivate func initUI() {
        
        self.title = "设置"
        
        let tableView = BaseTableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.config()
        view.addSubview(tableView)
        self.tableView = tableView
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
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
    
        dataSource = RxTableViewSectionedReloadDataSource(configureCell: { (ds, tv, indexPath, item) -> UITableViewCell in
            if indexPath.row == 0 {
                // 充当 SectionHeader 占位
                let placeCell = UITableViewCell()
                placeCell.backgroundColor = kThemeGainsboroColor
                return placeCell
            }
            
            // 注册cell
            if self.orderType == ORDER_TYPE.grab {
                
            }else if self.orderType == ORDER_TYPE.oning {
                let cell = tv.dequeue(Reusable.noingCell, for: indexPath)
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                
                return cell
            }else if self.orderType == ORDER_TYPE.over {
                let cell = tv.dequeue(Reusable.overCell, for: indexPath)
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                
                return cell
            }
            
            let cell = tv.dequeue(Reusable.grapCell, for: indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell
        })
        
        
        viewModel.getGarp(params: NSMutableDictionary()) { [weak self] (obsever) in
            obsever.bind(to: self?.tableView.rx.items(dataSource: self?.dataSource)).disposed(by: rx.disposeBag)
        }
    
    }
}

// MARK:- UITableViewDelegate
extension OrderVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // 充当 SectionHeader 数据模型
        if indexPath.row == 0 {
            return MetricAppSet.sectionHeight
        }
        return MetricAppSet.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        
    }
}

