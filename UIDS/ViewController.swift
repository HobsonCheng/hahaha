//
//  ViewController.swift
//  UIDS
//
//  Created by one2much on 2018/1/5.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit


class ViewController: UIViewController,EAIntroDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.white
        
        let sgU = Util.shared
        sgU.checkAndRateWithController(vc:self)
        
        //main rootView
        
        
        let searchapp = AppSearchNavVC(nibName: "AppSearchNavVC", bundle: nil);
        VCController.push(searchapp, with:nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func startLaunPage(){
        
        let userDefaults = UserDefaults.standard;
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String;
        //根据版本号来判断是否需要显示引导页，一般来说每更新一个版本引导页都会有相应的修改
        let show = userDefaults.bool(forKey: "version_"+version)
        
        if !show  {
            userDefaults.set(true, forKey: "version_"+version)
            userDefaults.synchronize()
        }else{
            return
        }
        
        
        //启动轮播图
        
        let launchList = [["title":"hello，bai 1","desc":"1","imgName":"title1","bg":"guiImage1"],
                          ["title":"hello，bai 2","desc":"2","imgName":"title2","bg":"guiImage2"],
                          ["title":"hello，bai 3","desc":"3","imgName":"title3","bg":"guiImage3"],
                          ["title":"hello，bai 4","desc":"4","imgName":"title4","bg":"guiImage4"]
        ]
        
        
        let tmpList = NSMutableArray()
        
        for item in launchList {
            let page = EAIntroPage()
            page.title = item["title"]
            page.desc = item["desc"]
            page.titleIconView = UIImageView.init(image: UIImage.init(named: item["imgName"]!))
            page.bgImage = UIImage.init(named: item["bg"]!)
            tmpList.add(page)
        }

        let intro = EAIntroView.init(frame: self.view.bounds, andPages:tmpList as! [EAIntroPage])
        intro?.skipButtonY = 80
        intro?.pageControlY = 42
        intro?.skipButtonAlignment = EAViewAlignment.center
        intro?.delegate = self
        
        let mywindow = UIApplication.shared.delegate?.window
        
    
        intro?.show(in: mywindow!, animateDuration: 0.3)
    }
    
    
    //MARK: EAIntroView deleaget
    func introDidFinish(_ introView: EAIntroView!, wasSkipped: Bool) {
    
        
    }
}

