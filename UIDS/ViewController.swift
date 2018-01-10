//
//  ViewController.swift
//  UIDS
//
//  Created by one2much on 2018/1/5.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.white;
        
        let sgU = Util.shared;
        sgU.checkAndRateWithController(vc:self);
        
        //main rootView
        let mainvc = MainVC();
        VCController.push(mainvc!, with:nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

