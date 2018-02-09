//
//  RootGender.swift
//  UIDS
//
//  Created by one2much on 2018/1/10.
//  Copyright © 2018年 one2much. All rights reserved.
//

import Foundation
import SwiftyJSON
import ESPullToRefresh

extension RootVC {//扩展

    //MARK: 生成组件信息45
    func genderModelList() {
        
        self.startY = 1;
        
        //分析模板信息
        var model_str = self.pageData?.model_id
        if model_str?.count == 0 {//如果模板数据为空 查询是否含有默认模板数据
            //这个逻辑应该不需要存在
            if self.pageData?.page_type == PAGE_TYPE_TopicList {
                model_str = "[\"module_TopicList_nodel\"]"
            }
        }
        
        let models = JSON.init(parseJSON: (model_str)!)
        
        print("当前页面models:\(model_str!)")
        
        for item in models.enumerated() {
            let modelName = item.element.1
            let tmpList = String(describing: modelName).components(separatedBy: "_")
            switch tmpList[1] {
            case "OneImg" :
                self.genderOneImg(model_id: tmpList[0], startY: &self.startY!)
                break
            case "Slider" :
                self.genderSlifer(model_id: tmpList[0], startY: &self.startY!)
                break
            case "SwipImgArea" :
                self.genderSwipImg(code: String(describing: modelName),model_id: tmpList[0], startY: &self.startY!)
                break
            case "ArticleList" :
                self.genderArticleList(code: String(describing: modelName),model_id: tmpList[0], startY: &self.startY!)
                break
            case "PersonalCenter" :
                self.genderPersonalCenter(model_id: tmpList[0], startY: &self.startY!)
                break
            case "MakeToCustomer" :
                self.genderMakeToCustomer(model_id: tmpList[0], startY: &self.startY!)
                break
            case "GroupListTopic" :
                self.genderGroupListTopic(model_id: tmpList[0], startY: &self.startY!)
                break
            case "TopicList" :
                self.genderTopicList(model_id: tmpList[0], startY: &self.startY!)
                break
            case "SingleOrder":
                self.genderSingleOrder(model_id: tmpList[0], startY: &self.startY!)
                break
            default: break
                
            }
        }
        
        
        if (self.startY! + 50) > (self.mainView?.height)! {
            self.mainView?.contentSize = CGSize.init(width: 0, height: self.startY! + 50);
        }else {
            self.mainView?.contentSize = CGSize.init(width: 0, height: (self.mainView?.height)! + 50);
        }
    
        self.mainView?.reloadEmptyDataSet()
        
        self.mainView?.es.stopPullToRefresh()
        
        self.reloadMainScroll()
        
        
    }

    func genderSwipImg(code: String,model_id: String,startY: UnsafeMutablePointer<CGFloat>){
    
        // 网络图，本地图混合
        let imagesURLStrings = [String]();
        // 图片配文字
        let titles = [String]();
        
        // Demo--点击回调
        let bannerDemo = SwipImgAreaView.llCycleScrollViewWithFrame(CGRect.init(x: 0, y:startY.pointee, width: self.view.width, height: 200), imageURLPaths: imagesURLStrings, titles:titles, didSelectItemAtIndex: nil)
        
        bannerDemo.lldidSelectItemAtIndex = { index in
            let item = bannerDemo.sliderlist![index]
            
            let otherweb = OtherWebVC.init(name: "webview")
            otherweb?.urlString = item.open_url ?? "http://m.baidu.com"
            VCController.push(otherweb!, with: VCAnimationClassic.defaultAnimation())

            
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
        
        
        let params = NSMutableDictionary()
        params.setValue(code, forKey: "code")
        params.setValue(self.pageData?.page_key, forKey: "page")
        
        ApiUtil.share.getSlideByModel(params: params) { (status, data, msg) in
            
            let list = SliderModel.deserialize(from: data)?.data.pics ?? [Pic]()
            
            for item in list {
                bannerDemo.imagePaths.append(item.pic)
                bannerDemo.titles.append(item.descriptionField ?? "")
            }
    
            if bannerDemo.reloadViewData() {
                
            }
            
            bannerDemo.sliderlist = list
            
        }
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
    func genderArticleList(code: String,model_id: String,startY: UnsafeMutablePointer<CGFloat>){
        
        let aritclalist = ArticleList.init(frame: CGRect.init(x: 0, y: startY.pointee, width: self.view.width, height: 0))
        
        aritclalist.pageData = self.pageData
        aritclalist.model_code = code
        aritclalist.genderView { [weak self] in
            self?.reloadMainScroll()
        }
        
        aritclalist.tag = Int(startY.pointee)
        
        self.mainView?.addSubview(aritclalist)
        
        startY.pointee = aritclalist.bottom + 10
    }
    
    func genderPersonalCenter(model_id: String,startY: UnsafeMutablePointer<CGFloat>) {
        
        let personalCenter = PersonalCenter.init(frame: CGRect.init(x: 0, y: startY.pointee, width: self.view.width, height: 0))
        personalCenter.tag = Int(startY.pointee)
        
        personalCenter.reloadCell = {[weak self] in
            self?.reloadMainScroll()
        }
        
        self.mainView?.addSubview(personalCenter)
        
        startY.pointee = personalCenter.bottom + 10
    }
    
    func genderMakeToCustomer(model_id: String,startY: UnsafeMutablePointer<CGFloat>) {
        
        let obj = self.findConfigData(name: "maketocustomer_content",model_id: model_id)
        let formobj = FromModel.deserialize(from: obj)
        
        let maketoCustomer = MakeToCustomer.init(frame: CGRect.init(x: 0, y: startY.pointee, width: self.view.width, height: 0))
        maketoCustomer.genderInit(FormObj: formobj!)
        
        maketoCustomer.tag = Int(startY.pointee)
        
        self.mainView?.addSubview(maketoCustomer)
        
        startY.pointee = maketoCustomer.bottom + 10
    }
    
    func genderGroupListTopic(model_id: String,startY: UnsafeMutablePointer<CGFloat>) {
        
        //遇到话题列表的组件  自动添加右上角 按钮
        self.gender_extension_Right_navbar(type: NAV_BAR_TYPE.NAV_BAR_TYPE_ADD_GROUP)
        
        let groupListTopic = GroupListTopic.init(frame: CGRect.init(x: 0, y: startY.pointee, width: self.view.width, height: 0))
        self.refreshCallback = groupListTopic.refreshCB
        groupListTopic.refreshES = self.esCallBack
        
        groupListTopic.genderList { [weak self] in
            self?.reloadMainScroll()
        }
        
        groupListTopic.tag = Int(startY.pointee)
        
        self.mainView?.addSubview(groupListTopic)
        
        startY.pointee = groupListTopic.bottom + 10
    }
    
    func genderTopicList(model_id: String,startY: UnsafeMutablePointer<CGFloat>)  {
        
        //遇到话题列表的组件  自动添加右上角 按钮
        self.gender_extension_Right_navbar(type: NAV_BAR_TYPE.NAV_BAR_TYPE_ADD_TOPOC)
        
        let topicList = TopicList.init(frame: CGRect.init(x: 0, y: startY.pointee, width: self.view.width, height: 0))
        
        topicList.groupItem = self.pageData?.anyObj as? GroupData
        
        self.refreshCallback = topicList.refreshCB
        topicList.refreshES = self.esCallBack
        
        topicList.genderList { [weak self] in
            self?.reloadMainScroll()
        }
        
        topicList.tag = Int(startY.pointee)
        
        self.mainView?.addSubview(topicList)
        
        startY.pointee = topicList.bottom + 10
        
    }
    
    
    func genderSingleOrder(model_id: String,startY: UnsafeMutablePointer<CGFloat>) {
    

        let singleOrder = SingleOrder.init(frame: CGRect.init(x: 0, y: startY.pointee, width: kScreenW, height: (self.mainView?.height)!))
        singleOrder.pageData = self.pageData
        singleOrder.genderView()
        singleOrder.tag = Int(startY.pointee)
        
        self.mainView?.addSubview(singleOrder)
        
        startY.pointee = singleOrder.bottom + 10
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            //存在次组件  可以删除 上拉细腻
            self?.mainView?.es.removeRefreshFooter()
        }
        
    }
    
    
    private func reloadMainScroll(){
        
        
        self.mainView?.showEmpty = true
        
        self.startY = 0;
        
        for sonView in (self.mainView?.subviews)! {
            
            if sonView.tag > 0 {
                
                sonView.top = self.startY!
                self.startY = sonView.bottom  + 10
                
                if self.startY! > CGFloat(30.0) {
                    self.mainView?.showEmpty = false
                }
            }
            
        }
        
        
        if (self.startY! + 50) > (self.mainView?.height)! {
            self.mainView?.contentSize = CGSize.init(width: 0, height: self.startY! + 50);
        }else {
            self.mainView?.contentSize = CGSize.init(width: 0, height: (self.mainView?.height)! + 50);
        }
        
        
        self.mainView?.reloadEmptyDataSet()
    
    }
}

//MARK: - 增加刷新机制
extension RootVC {
    
    func genderRefresh() {
        
        //上拉  下拉
        var header: ESRefreshProtocol & ESRefreshAnimatorProtocol
        var footer: ESRefreshProtocol & ESRefreshAnimatorProtocol
        
        header = DS2RefreshHeader.init(frame: CGRect.zero)
        footer = DS2RefreshFooter.init(frame: CGRect.zero)
        
        self.mainView?.es.addPullToRefresh(animator: header) { [weak self] in
            self?.refresh()
        }
        self.mainView?.es.addInfiniteScrolling(animator: footer) { [weak self] in
            self?.loadMore()
        }
    }
    
    private func refresh() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            var find = false
            for sonView in (self?.mainView?.subviews)! {
                
                if sonView.tag > 0 {
                    if find {
                        
                    }else {
                        find = (sonView as! BaseModuleView).reloadViewData()
                    }
                }
                
            }
            
            if !find {
                self?.mainView?.es.stopPullToRefresh()
            }
        }
        
    }
    private func loadMore() {
        
        if self.refreshCallback != nil {
            self.refreshCallback!()
        }else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
                self?.mainView?.es.noticeNoMoreData()
            }
        }
    }
}
