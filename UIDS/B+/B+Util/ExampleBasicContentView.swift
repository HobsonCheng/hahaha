//
//  ExampleBasicContentView.swift
//  UIDS
//
//  Created by one2much on 2018/1/10.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class ExampleBasicContentView: ESTabBarItemContentView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        textColor = UIColor.init(red: 113/255.0, green: 104/255.0, blue: 104/255.0, alpha: 1.0)
//        highlightTextColor = UIColor.init(hexString: "#4b95ee")
//       
//        imageView.tintColor = UIColor.clear
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
