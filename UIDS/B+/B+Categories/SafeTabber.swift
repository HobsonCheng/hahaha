//
//  SafeTabber.swift
//  UIDS
//
//  Created by one2much on 2018/1/11.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import ESTabBarController_swift
// MARK: tabber

extension UITabBar {

    open override func setNeedsLayout() {
        
        if self.isKind(of: ESTabBar.classForCoder()) {
            self.height = 49
        }
        super.setNeedsLayout()
    }
}
