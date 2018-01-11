//
//  Slider.swift
//  UIDS
//
//  Created by one2much on 2018/1/11.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class Slider: UIView {

    var bgScroll: UIScrollView?
    //MARK: 初始化页面信息
    public func genderInit(meunList: NSArray,row: NSInteger,list: NSInteger) -> CGFloat{
        
        //驻扎住view
        bgScroll = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: self.width, height: 100))
        bgScroll?.isPagingEnabled = true
        self.addSubview(bgScroll!)
        
        //每个Item宽高
        let W = 80;
        let H = 100;
        //每行列数
        let rank = 4;
        //每列间距
        let rankMargin = (self.width - rank * W) / (rank - 1);
        //每行间距
        let rowMargin = 20;
        //Item索引 ->根据需求改变索引
        let index = 9;
        
        for var i=0;i<index;i++{
            let X = (i % rank) * (W + rankMargin)
            
        }
//
//        for (int i = 0 ; i< index; i++) {
//            //Item X轴
//            CGFloat X = (i % rank) * (W + rankMargin);
//            //Item Y轴
//            NSUInteger Y = (i / rank) * (H +rowMargin);
//            //Item top
//            CGFloat top = 50;
//            UIView *speedView = [[UIView alloc] init];
//            speedView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"taozi"]];
//            speedView.frame = CGRectMake(X, Y+top, W, H);
//            [self.view addSubview:speedView];
//        }
        
        return 100.0
    }

}
