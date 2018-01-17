//
//  LoginView.swift
//  UIDS
//
//  Created by one2much on 2018/1/17.
//  Copyright © 2018年 one2much. All rights reserved.
//

//登录模块信息  1.0 原生版本
import UIKit
import Then
import TYPagerController

//MARK: -常亮
fileprivate struct Metric {
    
    static let leftTitle = "账号密码登录"
    static let rightTitle = "快捷免密登录"
    
    static let pagerBarFontSize = UIFont.systemFont(ofSize: 15.0)
    static let pagerBarHeight: CGFloat = 49.0
    
}


class LoginView: NaviBarVC {

    var pageVC = TYTabPagerController().then {
        
        $0.pagerController.scrollView?.backgroundColor = kThemeGainsboroColor
        
        // 设置滚动条 属性
        $0.tabBarHeight = Metric.pagerBarHeight
        $0.tabBar.backgroundColor = kThemeWhiteColor
        $0.tabBar.layout.cellWidth = kScreenW * 0.5
        $0.tabBar.layout.progressWidth = Metric.leftTitle.getSize(font: Metric.pagerBarFontSize).width + MetricGlobal.margin * 2
        $0.tabBar.layout.progressColor = kThemeTomatoColor
        $0.tabBar.layout.selectedTextColor = kThemeTomatoColor!
        $0.tabBar.layout.progressHeight = 3.0
        $0.tabBar.layout.cellSpacing = 0
        $0.tabBar.layout.cellEdging = 0
        $0.tabBar.layout.normalTextFont = Metric.pagerBarFontSize
        $0.tabBar.layout.selectedTextFont = Metric.pagerBarFontSize
    }
    
    let titles: [String] = [Metric.leftTitle, Metric.rightTitle]
    var vcs: [BaseNameVC] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNaviDefulat()
        
        self.naviBar().setTitle("登录😑")
        
        self.initEnableMudule()
        self.initPageController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func goBack(_ sender: Any!) {
        
        VCController.pop(with: VCAnimationBottom.defaultAnimation())
        
    }
    
}
