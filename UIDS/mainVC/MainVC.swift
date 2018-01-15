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
        
        self.setupTabber(tabBarController: tabBarController);
        if let tabBar = tabBarController.tabBar as? ESTabBar {
            tabBar.itemCustomPositioning = .fillIncludeSeparator
        }

//        let appInfo = AppInfoData.shared.appModel
        let pageListinfo = PageListInfo.shared.pageListModel

        let tmpTabbers = NSMutableArray()

        for item in (pageListinfo?.enumerated())! {

            let tabber = RootVC()
            tabber?.pageData = item.element
            tabber?.tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: item.element.name, image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
            tmpTabbers.add(tabber!)
        }

////        v3?.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(), title: nil, image: UIImage(named: "photo_verybig"), selectedImage: UIImage(named: "photo_verybig"))

        
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
