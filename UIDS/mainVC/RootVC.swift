//
//  RootVC.swift
//  UIDS
//
//  Created by one2much on 2018/1/10.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import Dodo

class RootVC: NaviBarVC {

    var moduleList: NSArray?
    var mainView: UIScrollView?
    var startY: CGFloat?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.naviBar().setTitle("首页")
        
        self.view.dodo.success("hello bai")
        
        self.startY = 0;
        self.mainView = UIScrollView.init(frame: self.view.bounds);
        self.view.addSubview(self.mainView!);
    
        
        self.moduleList = NSArray()
        self.genderModelList(modelList: self.moduleList!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.view.dodo.hide();
//            let nextv = NextVC();
//            VCController.push(nextv!, with: VCAnimationClassic.defaultAnimation());
        };
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
