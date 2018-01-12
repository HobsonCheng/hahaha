//
//  RootGender.swift
//  UIDS
//
//  Created by one2much on 2018/1/10.
//  Copyright © 2018年 one2much. All rights reserved.
//

import Foundation

extension RootVC {//扩展
    
    //MARK: 生成组件信息
    func genderModelList(modelList: NSArray) {
        
        self.startY = 0;
        
        self.genderSwipImg(list: NSArray(), startY: &self.startY!)
        
        self.genderOneImg(obj: NSObject(), startY: &self.startY!)
        
        self.genderSlifer(obj: NSObject(), startY: &self.startY!)
        
        
        self.mainView?.contentSize = CGSize.init(width: 0, height: self.startY! + 50);
        
        self.mainView?.showEmpty = false
        self.mainView?.reloadEmptyDataSet()
    }
    
    func genderSwipImg(list: NSArray,startY: UnsafeMutablePointer<CGFloat>){
    
        
        // 网络图，本地图混合
        let imagesURLStrings = [
            "http://www.g-photography.net/file_picture/3/3587/4.jpg",
            "http://img2.zjolcdn.com/pic/0/13/66/56/13665652_914292.jpg",
            "http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg",
            "http://img3.redocn.com/tupian/20150806/weimeisheyingtupian_4779232.jpg",
            ];
        // 图片配文字
        let titles = ["bai1",
                      "bai2",
                      "bai3"
        ];
        
        
        // Demo--点击回调
        let bannerDemo = SwipImgAreaView.llCycleScrollViewWithFrame(CGRect.init(x: 0, y:startY.pointee, width: self.view.width, height: 200), imageURLPaths: imagesURLStrings, titles:titles, didSelectItemAtIndex: { index in
            print("当前点击图片的位置为:\(index)")
        })
        
        bannerDemo.lldidSelectItemAtIndex = { index in
            
        }
        bannerDemo.customPageControlStyle = .fill
        bannerDemo.customPageControlInActiveTintColor = UIColor.red
        bannerDemo.pageControlPosition = .left
        bannerDemo.pageControlLeadingOrTrialingContact = 28
        
        // 下边约束
        bannerDemo.pageControlBottom = 15
        self.mainView!.addSubview(bannerDemo)
        
        startY.pointee = bannerDemo.bottom
    }
    
    func genderOneImg(obj: NSObject,startY: UnsafeMutablePointer<CGFloat>){
        
        let oneImg = OneImg.init(frame: CGRect(x: 0,y: startY.pointee,width: self.view.width,height: 200))
        oneImg.setUrl(url: "http://static.123rf.com.cn/public/images/corp/photo/201701/indexpage_11.jpg")
        self.mainView!.addSubview(oneImg);
        
        startY.pointee = oneImg.bottom
    }
    
    func genderSlifer(obj: NSObject,startY: UnsafeMutablePointer<CGFloat>) {
        
        let sliderView = Slider.init(frame: CGRect.init(x: 0, y: startY.pointee, width: self.view.width, height: 100))
        
        sliderView.genderInit(menuList: [1,2,3,4,5,6,7,8,9,0,10,11,12,13,14,14,15,15,6,7,8,9], row: 2, rank: 4)
        
        self.mainView?.addSubview(sliderView)
        
        startY.pointee = sliderView.bottom
    }
}
