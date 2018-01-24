//
//  AppSet.swift
//  UIDS
//
//  Created by one2much on 2018/1/24.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class AppSet: NaviBarVC {

    var pageData: PageInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNaviDefulat()
        
        self.naviBar().setTitle(self.pageData?.name)
        // Do any additional setup after loading the view.
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
