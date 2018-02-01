//
//  AppSearchNavVC.swift
//  UIDS
//
//  Created by bai on 2018/2/1.
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
import IQKeyboardManagerSwift


protocol AppSearchVCDelectege {
    
    //搜索结束
    func SearchpidEnd(pidObj: Any?)
    
}

class AppSearchNavVC: BaseNameVC {

    var delegate: AppSearchVCDelectege?
    
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.sharedManager().enable = true
        self.genderUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//gender ui
extension AppSearchNavVC {
    
    fileprivate func genderUI() {
        self.noButton.layer.cornerRadius = 8
        self.noButton.layer.masksToBounds = true
        
        self.tableview.tableFooterView = UIView()
        
    
    
        
        let searchField: UITextField = self.searchbar.value(forKey: "searchField") as! UITextField
        searchField.backgroundColor = UIColor.clear
        searchField.layer.cornerRadius = 8
        searchField.layer.borderColor = UIColor(hexString: "#1e71eb", withAlpha: 1).cgColor
        searchField.layer.borderWidth = 1
        searchField.layer.masksToBounds = true
    }
}

extension AppSearchNavVC{
    
    
}
