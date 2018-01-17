//
//  RootGender.swift
//  UIDS
//
//  Created by one2much on 2018/1/10.
//  Copyright © 2018年 one2much. All rights reserved.
//

import Foundation
import SwiftyJSON

extension RootVC {//扩展

    //MARK: 生成组件信息
    func genderModelList() {
        
        self.startY = 1;
        
        //分析模板信息
        let model_str = self.pageData?.model_id
        let models = JSON.init(parseJSON: (model_str)!)
        for item in models.enumerated() {
            let modelName = item.element.1
            let tmpList = String(describing: modelName).components(separatedBy: "_")
            switch tmpList[1] {
            case "OneImg" :
                self.genderOneImg(model_id: tmpList[0], startY: &self.startY!)
            case "Slider" :
                self.genderSlifer(model_id: tmpList[0], startY: &self.startY!)
            case "SwipImgArea" :
                self.genderSwipImg(list: NSArray(), startY: &self.startY!)
            case "ArticleList" :
                self.genderArticleList(model_id: tmpList[0], startY: &self.startY!)
            case "PersonalCenter" :
                print("PersonalCenter")
            default: break
                
            }
        }
    
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
        
        bannerDemo.tag = Int(startY.pointee)
        
        self.mainView!.addSubview(bannerDemo)
        
        startY.pointee = bannerDemo.bottom + 10
    }
    
    func genderOneImg(model_id: String,startY: UnsafeMutablePointer<CGFloat>){
        
        
        let obj = self.findConfigData(name: "OneImg_content",model_id: model_id)
        
        let oneModel: OneImgMode? = OneImgMode.deserialize(from: obj)
        
        let oneImg = OneImg.init(frame: CGRect(x: 0,y: startY.pointee,width: self.view.width,height: 200))
        if ((oneModel?.imgList) != nil) {
            oneImg.setUrl(url: oneModel!.imgList![0].icon! as NSString)
        }else {
            oneImg.setUrl(url: "http://omzvdb61q.bkt.clouddn.com/UIdashi_9484892")
        }
    
        oneImg.tag = Int(startY.pointee)
        
        self.mainView!.addSubview(oneImg);
        
        startY.pointee = oneImg.bottom + 10
    }
    
    func genderSlifer(model_id: String,startY: UnsafeMutablePointer<CGFloat>) {
        
        let objContent = self.findConfigData(name: "Slider_content",model_id: model_id)
        
        let sliderContent: SliderContentMode? = SliderContentMode.deserialize(from: objContent)
        
        let objLayout = self.findConfigData(name: "Slider_layout",model_id: model_id)
        
        let sliderLayout: SliderLayoutMode? = SliderLayoutMode.deserialize(from: objLayout)
        
        let sliderView = Slider.init(frame: CGRect.init(x: 0, y: startY.pointee, width: self.view.width, height: 100))
        
        if sliderLayout?.shapeObj != nil {
            sliderView.genderInit(contentData: sliderContent!, row: Int((sliderLayout?.shapeObj?.row)!)!, rank: Int((sliderLayout?.shapeObj?.line)!)!)
        }else {
            sliderView.genderInit(contentData: sliderContent!, row:2, rank:4)
        }
        
        sliderView.tag = Int(startY.pointee)
        
        self.mainView?.addSubview(sliderView)
        
        startY.pointee = sliderView.bottom + 10
    }
    func genderArticleList(model_id: String,startY: UnsafeMutablePointer<CGFloat>){
        
        let aritclalist = ArticleList.init(frame: CGRect.init(x: 0, y: startY.pointee, width: self.view.width, height: 0))
        
        weak var selfweak = self
        aritclalist.genderView {
            selfweak?.reloadMainScroll()
        }
        
        aritclalist.tag = Int(startY.pointee)
        
        self.mainView?.addSubview(aritclalist)
        
        startY.pointee = aritclalist.bottom + 10
    }
    
    
    private func reloadMainScroll(){
        
        self.startY = 1;
        
        for sonView in (self.mainView?.subviews)! {
            
            if sonView.tag > 0 {
                
                sonView.top = self.startY!
                self.startY = sonView.bottom  + 10
            }

        }
        
        self.mainView?.contentSize = CGSize.init(width: 0, height: self.startY! + 50);
    }
}
