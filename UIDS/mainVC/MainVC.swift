//
//  MainVC.swift
//  UIDS
//
//  Created by one2much on 2018/1/10.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import ESTabBarController_swift;

class MainVC: BaseNameVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initTabber();
        if UserUtil.isValid() {
            
        }
        
        if (OpenVC.share.pageList != nil) {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTabber(tabBarController: ESTabBarController){
        
        tabBarController.shouldHijackHandler = {
            tabbarController, viewController, index in
            if index == 2 {
                return true
            }
            return false
        }
        tabBarController.didHijackHandler = {
            [weak tabBarController] tabbarController, viewController, index in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
                let takePhotoAction = UIAlertAction(title: "Take a photo", style: .default, handler: nil)
                alertController.addAction(takePhotoAction)
                let selectFromAlbumAction = UIAlertAction(title: "Select from album", style: .default, handler: nil)
                alertController.addAction(selectFromAlbumAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                tabBarController?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    //TODO: 初始化tabber
    func  initTabber() {

        let tabBarController = ESTabBarController()
        
//        self.setupTabber(tabBarController: tabBarController);
        if let tabBar = tabBarController.tabBar as? ESTabBar {
            tabBar.itemCustomPositioning = .fillIncludeSeparator
        }

        //分析
        let appinfo = AppInfoData.shared.appModel
        let getConfig = DownData.findConfigData(name: "module_TabberView_Tabber_layout", model_id: nil, config_key: (appinfo?.config_key)!)
        
        let tabobj = TabberModel.deserialize(from: getConfig)
        
        
        let pageListinfo = PageListInfo.shared.pageListModel

        var bigNum = 10000
        if tabobj?.bigShow ?? false {
            if (pageListinfo?.count)!%2 != 0 {
                bigNum = (((pageListinfo?.count)! + 1)/2)
                bigNum -= 1
            }
        }
        
        let tmpTabbers = NSMutableArray()
        var count = 1
        for item in (pageListinfo?.enumerated())! {

            let tabber = RootVC()
            tabber?.isHomePage = true
            tabber?.pageData = item.element
            if (bigNum + 1) == count {
                tabber?.tabBarItem = DImgTabber.init(contentView: ExampleIrregularityContentView(), title: nil, image: tabber?.pageData?.icon, selectedImage: tabber?.pageData?.icon_sel, tag: count)
//
//                tabber?.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(), title: nil, image: UIImage(named: "photo_verybig"), selectedImage: UIImage(named: "photo_verybig"))
                
                tmpTabbers.add(tabber!)
            }else{
                tabber?.tabBarItem = DImgTabber.init(contentView: ExampleBouncesContentView(), title: tabber?.pageData?.name, image: tabber?.pageData?.icon, selectedImage: tabber?.pageData?.icon_sel, tag: count)
                tmpTabbers.add(tabber!)
            }
            
            count += 1
            
            
        }


        
        tabBarController.viewControllers = tmpTabbers as? [UIViewController]
        
        self.addChildViewController(tabBarController);
        self.view.addSubview(tabBarController.view);
        
        
//        if let tabBarItem = v2?.tabBarItem as? ESTabBarItem {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2 ) {
//                tabBarItem.badgeValue = "10"
//            }
//        }
    }

}
