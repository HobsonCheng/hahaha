//
//  MainScrollView.swift
//  UIDS
//
//  Created by one2much on 2018/1/12.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class MainScrollView: UIScrollView,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {

    
    open var showEmpty: Bool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.showEmpty = true
        self.emptyDataSetDelegate = self
        self.emptyDataSetSource = self
        
        self.reloadEmptyDataSet()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    //MARK: 协议
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage.init(named: "test_15.png")
    }

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return self.showEmpty!
    }

}
