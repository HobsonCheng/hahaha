//
//  ViewController.swift
//  UIDS
//
//  Created by one2much on 2018/1/5.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit


class ViewController: UIViewController,SwiftIntroViewDelegate{
    
    
    var introView: SwiftIntroView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let sgU = Util.shared
        //        sgU.checkAndRateWithController(vc:self)
        
        //main rootView
        self.startLaunPage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func startLaunPage(){
        
        let userDefaults = UserDefaults.standard
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        //根据版本号来判断是否需要显示引导页，一般来说每更新一个版本引导页都会有相应的修改
        let show = userDefaults.bool(forKey: "version_"+version)
        
        if !show  {
            userDefaults.set(true, forKey: "version_"+version)
            userDefaults.synchronize()
        }else{
            
            if Util.get_defult(key: KEY_ISNEED_GOTOAPP) != nil && (Util.get_defult(key: KEY_ISNEED_GOTOAPP)) as! String == "1" {//主动进入pid
                
                let searchapp = AppSearchNavVC()
                VCController.push(searchapp!, with:nil)
                
                let mainvc = MainVC()
                VCController.push(mainvc!, with: nil)
            }else {
                
                let searchapp = AppSearchNavVC()
                VCController.push(searchapp!, with:nil)
            }
            
            return
        }
        
        introView = SwiftIntroView(frame: self.view.frame)
        introView.delegate = self
        introView.backgroundColor = kNaviBarBackGroundColor
        self.view.addSubview(introView)
        
    }
    
    // SwiftIntroViewDelegate 方法
    func doneButtonClick() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let searchapp = AppSearchNavVC()
            VCController.push(searchapp!, with:nil)
        }
        UIView.animate(withDuration: 1, animations: {() -> Void in
            self.introView.alpha = 0
            
        }) { (finished) -> Void in
            self.introView.removeFromSuperview()
        }
    }
    
    
}

