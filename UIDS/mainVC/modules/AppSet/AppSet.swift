//
//  AppSet.swift
//  UIDS
//
//  Created by one2much on 2018/1/24.
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

// MARK:- 复用
private enum Reusable {
    
    static let settingCell = ReusableCell<SettingCell>()
}

// MARK:- 常量
fileprivate struct MetricAppSet {
    
    static let cellHeight: CGFloat = 49.0
    static let sectionHeight: CGFloat = 10.0
}


class AppSet: NaviBarVC {

    var pageData: PageInfo?
    
    // viewModel
    fileprivate var viewModel = SettingViewModel()
    fileprivate var vmOutput: SettingViewModel.SettingOutput?
    
    // View
    fileprivate var tableView: UITableView!
    
    // DataSuorce
    var dataSource : RxTableViewSectionedReloadDataSource<SettingSection>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNaviDefulat()
        
        self.naviBar().setTitle("设置中心")
        
        self.initEnableMudule()
        self.initUI()
        self.bindUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


// MARK:- 初始化协议
extension AppSet {
    
    // MARK:- 协议组件
    fileprivate func initEnableMudule() {
        
        
    }
}

extension AppSet {
    
    // MARK:- 初始化视图
    fileprivate func initUI() {
        
        self.title = "设置"
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        self.tableView = tableView
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.naviBar().bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        // 设置代理
        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        
        // 注册cell
        tableView.register(Reusable.settingCell)
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
            let cell = tv.dequeue(Reusable.settingCell, for: indexPath)
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.model = item
            return cell
        })
        
        vmOutput = viewModel.transform(input: SettingViewModel.SettingInput(type: .setting))
        
        vmOutput?.sections.asDriver().drive(tableView.rx.items(dataSource: dataSource)).disposed(by: rx.disposeBag)
    }
}

// MARK:- UITableViewDelegate
extension AppSet: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // 充当 SectionHeader 数据模型
        if indexPath.row == 0 {
            return MetricAppSet.sectionHeight
        }
        return MetricAppSet.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    
        
        if indexPath.section == 5 {
            self.outApp()
        }
    }
}

// MARK:- 控制器跳转
extension AppSet {
    
    // MARK:- 登录
    func jump2Login() {
        
    
    }
    //MARK: - 退出
    func outApp() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
            let takePhotoAction = UIAlertAction(title: "退出当前账号？", style: .destructive, handler: nil)
            alertController.addAction(takePhotoAction)
            let selectFromAlbumAction = UIAlertAction(title: "确定", style: .default, handler: { [weak self] (touch) in
                 UserUtil.share.removerUser()
                self?.vmOutput = self?.viewModel.transform(input: SettingViewModel.SettingInput(type: .setting))
                self?.tableView.reloadData()
            })
            alertController.addAction(selectFromAlbumAction)
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
}
