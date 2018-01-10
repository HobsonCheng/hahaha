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
        let v1 = RootVC()
        let v2 = RootVC()
        let v3 = RootVC()
        let v4 = RootVC()
        let v5 = RootVC()
        v1?.tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        v2?.tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: "Find", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3?.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(), title: nil, image: UIImage(named: "photo_verybig"), selectedImage: UIImage(named: "photo_verybig"))
        v4?.tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: "Favor", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        v5?.tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: "Me", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        tabBarController.viewControllers = [v1!, v2!, v3!, v4!, v5!]
        
        self.addChildViewController(tabBarController);
        self.view.addSubview(tabBarController.view);
        
        
        if let tabBarItem = v2?.tabBarItem as? ESTabBarItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2 ) {
                tabBarItem.badgeValue = "10"
            }
        }
    }

}
