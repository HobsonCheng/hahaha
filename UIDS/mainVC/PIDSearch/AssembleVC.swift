//
//  AssembleVC.swift
//  UIDS
//
//  Created by one2much on 2018/2/2.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class AssembleVC: BaseNameVC {

    
    
    @IBOutlet weak var newtips: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var sonTips: UILabel!
    @IBOutlet weak var mainTips: UILabel!
    @IBOutlet weak var appIcon: UIImageView!
    var pObj: Project?
    var tiplist: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tiplist = ["目前您单位的APP在苹果iOS端使用的是通用版，在您单位APP的后台设置，即可升级为独立版。"
            ,"单位APP将会成为您工作上的得力助手，领导满意，同事便利。"
            ,"单位APP整合资源，将所有的办公应用汇总，触手可及。"
            ,"单位APP可以完全独立部署在单位自己的服务器，数据更安全。"]
        
        self.appIcon.sd_setImage(with: URL(string: (pObj?.icon)!), completed: nil)
        self.appIcon.layer.cornerRadius = 6
        self.appIcon.layer.masksToBounds = true
        
        
        var appname = pObj?.app_name.replacingOccurrences(of: "<em>", with: "")
        appname = appname!.replacingOccurrences(of: "</em>", with: "")
        self.mainTips.text = appname
        
        self.showTip()
        
        self.progressTip(num: 0.01, tip: "开启“\((appname)!)”的加载...")
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.getAppHostName()
        }
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func gobackAction(_ sender: Any) {
        VCController.pop(with: VCAnimationClassic.defaultAnimation())
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    
    //进度
    func progressTip(num: Float, tip: String) {
        self.progress.setProgress(num, animated: true)
    }
    
    func showTip() {
        
        let index = Int(arc4random()%3)+0
        
        let tmpTip = tiplist[index]
        
        self.newtips.text = tmpTip
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.showTip()
        }
        
    }
    
}

//启动downApp 流程
extension AssembleVC {
    
    //获取app 域名
    
    func getAppHostName() {
       
        BRequestHandler.shared.getAppHostNEW(app_id: (pObj?.pid)!) { [weak self] (hostname) in
            //得到hostname
            BRequestHandler.shared.appHostName = hostname
        
            self?.getAppInfo()
        }
    }

    func getAppInfo() {
        
        self.progressTip(num: 0.1, tip: "第一步完成")
        
        let params = NSMutableDictionary()
        params.setValue(pObj?.pid, forKey: "app_id")
        params.setValue(pObj?.group_id, forKey: "group_id")
        
        ApiUtil.share.getApp(params: params) { [weak self] (status, data, msg) in
            
            //迁移写入指定文件
            if data != nil {
                
                let dataObj = data?.data(using: String.Encoding.utf8)
                let tmpData: NSMutableData? = NSMutableData()
                tmpData?.append((dataObj)!)
                tmpData?.write(toFile: DownData.resoursePathAppInfo(), atomically: true)
                
                AppInfoData.shared.initData()
                
                self?.getPageList()
            }
        }
    }
    func getPageList() {
        
        
        self.progressTip(num: 0.3, tip: "第二步完成")
        
        let params = NSMutableDictionary()
        params.setValue(pObj?.pid, forKey: "app_id")
        params.setValue(pObj?.group_id, forKey: "group_id")
        
        ApiUtil.share.getPageList(params: params) { [weak self] (status, data, msg) in
            
            //迁移写入指定文件
            if data != nil {
                
                let dataObj = data?.data(using: String.Encoding.utf8)
                let tmpData: NSMutableData? = NSMutableData()
                tmpData?.append((dataObj)!)
                tmpData?.write(toFile: DownData.resoursePathPageListInfo(), atomically: true)
                
                PageListInfo.shared.initData()
                
                self?.desktopIcon(isover: false)
            }
            
        }
        
    }
    
    
    func desktopIcon(isover: Bool) {
        
        self.downUCSetJson()
        
        return
    }
    
    
    func downUCSetJson() {
        
        self.progressTip(num: 0.4, tip: "第三步完成")
        
        let params = NSMutableDictionary()
        params.setValue(pObj?.pid, forKey: "pid")
        
        ApiUtil.share.allRestriction(params: params) { [weak self] (status, data, msg) in
            
            //迁移写入指定文件
            if data != nil {
                
                let dataObj = data?.data(using: String.Encoding.utf8)
                let tmpData: NSMutableData? = NSMutableData()
                tmpData?.append((dataObj)!)
                tmpData?.write(toFile: DownData.resoursePathUCSetInfo(), atomically: true)
                AllRestrictionHandler.share.init_ucSetConfig()
                self?.downicons()
            }
            
        }
    }
    
    
    func downicons() {
        
        let iconname = "pid1"
        
        UIApplication.shared.setAlternateIconName(iconname) { (err:Error?) in
            print("set icon error：\(String(describing: err))")
        }
        
        self.progressTip(num: 0.6, tip: "第四步完成")
        
        //分析
        let appinfo = AppInfoData.shared.appModel
        let getConfig = DownData.findConfigData(name: "module_TabberView_Tabber_layout", model_id: nil, config_key: (appinfo?.config_key)!)
        
        let tabobj = TabberModel.deserialize(from: getConfig)
        
        
        let pageListinfo = PageListInfo.shared.pageListModel
        
        var bigNum = 10000
        if tabobj?.bigShow ?? false {
            if (pageListinfo?.count)!%2 != 0 {
                bigNum = (((pageListinfo?.count)! + 1)/2)
                bigNum -= 1
            }
        }
        
        var count = 1
        for item in (pageListinfo?.enumerated())! {
            
            let image = item.element.icon
            let imageSel = item.element.icon_sel
            
            if (bigNum + 1) == count {
                
    
                let tmpimage = imageSel?.replacingOccurrences(of: "?imageMogr2/thumbnail/50x50!", with: "").replacingOccurrences(of: "?imageMogr2/thumbnail/60x60!", with: "")
                
                let getImgName: String!
                
                getImgName = String.init(format: "%@?imageMogr2/thumbnail/140x140!", tmpimage!)
                
                
                let iconname = String.init(format: "tabBar_icon_%zd@2x", count)
                
                DownData.movingTabberIcon(big: false, downUrl: getImgName, iconName: iconname)
                
            }else{
                
                let tmpimage = image?.replacingOccurrences(of: "?imageMogr2/thumbnail/50x50!", with: "").replacingOccurrences(of: "?imageMogr2/thumbnail/60x60!", with: "")
                
                let getImgName: String!
                
                getImgName = String.init(format: "%@?imageMogr2/thumbnail/46x46!", tmpimage!)
                
                
                let iconname = String.init(format: "tabBar_icon_%zd@2x", count)
                
                DownData.movingTabberIcon(big: false, downUrl: getImgName, iconName: iconname)
                
                
                
                
                let tmpimageSel = imageSel?.replacingOccurrences(of: "?imageMogr2/thumbnail/50x50!", with: "").replacingOccurrences(of: "?imageMogr2/thumbnail/60x60!", with: "")
                
                let getImgNameSel: String!
                getImgNameSel = String.init(format: "%@?imageMogr2/thumbnail/46x46!", tmpimageSel!)
                
                let iconnameSel = String.init(format: "tabBar_icon_%zd_sel@2x", count)
                
                DownData.movingTabberIcon(big: false, downUrl: getImgNameSel, iconName: iconnameSel)
                
            }
            
            count += 1
            
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
    
            self?.progressTip(num: 0.8, tip: "第四步完成")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                self?.progressTip(num: 0.999, tip: "进入App")
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    
                    let mainvc = MainVC()
                    VCController.popThenPush(mainvc!, with: VCAnimationClassic.defaultAnimation())
                }
                
            }
        }
    }
}

