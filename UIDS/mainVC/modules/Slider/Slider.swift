//
//  Slider.swift
//  UIDS
//
//  Created by one2much on 2018/1/11.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class SliderContentMode: ConfigModel {
    
    class centerData: HandyJSON {
        
        var selectType: Int?
        var color: String?
        var title: String?
        
        required init() {}
    }
    
    var fontSize: Int?
    var center: centerData?
    var List: [PageInfo]?
    
}
class SliderLayoutMode: ConfigModel {
    
    class shapeObjData: HandyJSON {
        
        var row: String?
        var line: String?
        
        required init() {}
    }
    
    var shape: Bool?
    var nets: Bool?
    var netsColor: String?
    var border_radius: Int?
    var shapeObj: shapeObjData?
}

class Slider: UIView,UIScrollViewDelegate {

    var bgScroll: UIScrollView?
    var pageControl: UIPageControl?
    //MARK: 初始化页面信息
    public func genderInit(contentData: SliderContentMode,row: NSInteger,rank: NSInteger){
        
        //驻扎住view
        bgScroll = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: self.width, height: 100))
        bgScroll?.delegate = self
        bgScroll?.showsVerticalScrollIndicator = false
        bgScroll?.showsHorizontalScrollIndicator = false
        bgScroll?.isPagingEnabled = true
        self.addSubview(bgScroll!)
        
        pageControl = UIPageControl()
        pageControl?.frame = CGRect.init(x: 0, y: (bgScroll?.bottom)!, width: self.width, height: 20)
        pageControl?.currentPage = 0
        pageControl?.pageIndicatorTintColor = UIColor.yellow
        pageControl?.currentPageIndicatorTintColor = UIColor.red
        self.addSubview(pageControl!)
        //分组数据
        let onePageNum = row * rank - 1
        let tmpList = NSMutableArray()
        var sonList = NSMutableArray()
        for (index,item) in (contentData.List?.enumerated())! {//数组分组

            sonList.add(item)

            if index >= (onePageNum * (tmpList.count + 1)){
                tmpList.add(sonList)
                sonList = NSMutableArray()
                sonList.add(item)
            }else if((index + 1) == contentData.List?.count){
                tmpList.add(sonList)
                sonList = NSMutableArray()
            }
        }


        //每列间距
        let rankMargin = 5
        //每个Item宽高
        let W = (Int(self.width) - (rank+1)*rankMargin)/rank;
        let H = W;
        //每行间距
        let rowMargin = 10;

        var allHeight = 100

        var isGetHeight = false

        for (index,item) in tmpList.enumerated() {

            for (count,sonitem) in (item as! NSArray).enumerated() {
                
                let tmpSonItem = (sonitem as! PageInfo)
                
                let startX = (Int(self.width)*index) + ((count)%rank) * (W + rankMargin) + 5
                let startY = (count/rank) * (H + rowMargin + 20)
                let top = 10


                let speedView = UIImageView.init()
                speedView.kf.setImage(with: URL.init(string: tmpSonItem.icon!))
                speedView.frame = CGRect.init(x: startX + 10, y: startY+top + 10, width: W  - 20, height: H - 20)
                speedView.backgroundColor = UIColor.clear
                bgScroll?.addSubview(speedView)

                let titleLabel = UILabel.init()
                titleLabel.text = String(describing: tmpSonItem.name!)
                titleLabel.frame = CGRect.init(x: startX, y: Int(speedView.bottom + 10), width: W, height: 20)
                titleLabel.font = UIFont.systemFont(ofSize: 14)
                titleLabel.textColor = UIColor.black
                titleLabel.textAlignment = NSTextAlignment.center
                bgScroll?.addSubview(titleLabel)

                if !isGetHeight {
                    allHeight = Int(titleLabel.bottom)
                }
            }

            if !isGetHeight {
                isGetHeight = true
            }

        }

        bgScroll?.height = CGFloat(allHeight)
        bgScroll?.contentSize = CGSize.init(width: Int(self.width)*tmpList.count, height: 0)
        if tmpList.count == 1 {
            pageControl?.isHidden = true
            pageControl?.numberOfPages = tmpList.count;
            pageControl?.top = (bgScroll?.bottom)!
            self.height = (bgScroll?.bottom)! + CGFloat(10)
        }else {
            pageControl?.numberOfPages = tmpList.count;
            pageControl?.top = (bgScroll?.bottom)!
            self.height = (pageControl?.bottom)! + CGFloat(10)
        }
    
    }
    
    
    
    //MARK: 回调
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = (self.bgScroll?.contentOffset.x)!/self.width
        
        pageControl?.currentPage = Int(page)
    }
}
