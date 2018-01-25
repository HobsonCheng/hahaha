//
//  NewsDetailVC.swift
//  UIDS
//
//  Created by one2much on 2018/1/24.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class NewsDetailVC: NaviBarVC {

    
    var pageData: PageInfo?
    
    var bridge: WebViewJavascriptBridge?
    
    // MARK: - 属性
    var contentOffsetY: CGFloat = 0.0
    
    /// 文章详情请求参数
    var articleParam: (classid: String, id: String)?
    
    /// 是否是分享文章
    var isShareArticle = true
    
    /// 详情页面模型
    var model: DetailData? {
        didSet {
            if !isLoaded {
                // 没有加载过，才去初始化webView - 保证只初始化一次
                loadWebViewContent(model!)
            }
            
            // 更新收藏状态
//            bottomBarView.collectionButton.isSelected = model!.havefava == "1"
            
            // 相关链接
//            if let links = model?.otherLinks {
//                otherLinks = links
//            }
            
        }
    }
    
    //评论区域
    var clTextView: CLTextView?
    
    // 临时广告图片
    let adImageView = UIImageView(frame: CGRect(x: 12, y: 0, width: kScreenW - 24, height: 160))
    
    /// 是否已经加载过webView
    var isLoaded = false
    
    /// 相关连接模型
    var otherLinks = [String]()// MARK: - 懒加载
    
    /// 评论模型
    var commentList = [ReplyData]()
    
    // cell标识符
    let detailContentIdentifier = "detailContentIdentifier"
    let detailStarAndShareIdentifier = "detailStarAndShareIdentifier"
    let detailOtherLinkIdentifier = "detailOtherLinkIdentifier"
    let detailOtherLinkNoneIdentifier = "detailOtherLinkNoneIdentifier"
    let detailCommentIdentifier = "detailCommentIdentifier"
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNaviDefulat()
        self.otherLinks = []
        
        // 设置初始正文字体大小
        if UserDefaults.standard.string(forKey: CONTENT_FONT_TYPE_KEY) == nil || UserDefaults.standard.integer(forKey: CONTENT_FONT_SIZE_KEY) == 0 {
            // 字体  16小   18中   20大   22超大  24巨大   26极大  共6个等级，可以用枚举列举使用
            UserDefaults.standard.set(18, forKey: CONTENT_FONT_SIZE_KEY)
            UserDefaults.standard.set("", forKey: CONTENT_FONT_TYPE_KEY)
            UserDefaults.standard.set(nil, forKey: "selectedArray")
            UserDefaults.standard.set(nil, forKey: "optionalArray")
        }
        
        
        adImageView.isUserInteractionEnabled = true
        adImageView.image = UIImage(named: "temp_ad.png")
        adImageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(saveAdImage(_:))))
        
        setupWebViewJavascriptBridge()
        prepareUI()
        updateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
    }
    
    /**
     长按保存广告图
     */
    func saveAdImage(_ longPress: UILongPressGestureRecognizer) {
        if longPress.state == .began {
            isShareArticle = false
        }
    }
    
    /**
     保存图片到相册
     */
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if let _ = error {
            Util.msg(msg: "保存失败", 3)
        } else {
            Util.msg(msg: "保存成功", 2)
        }
    }
    
    /**
     配置WebViewJavascriptBridge
     */
    func setupWebViewJavascriptBridge() {
        
        bridge = WebViewJavascriptBridge(for: webView, webViewDelegate: self, handler: { (data, responseCallback) in
            responseCallback!("Response for message from ObjC")
            
            guard let dict = data as! [String : AnyObject]! else {return}
            
            let index = Int(dict["index"] as! NSNumber)
            let x = CGFloat(dict["x"] as! NSNumber)
            let y = CGFloat(dict["y"] as! NSNumber) - self.tableView.contentOffset.y
            let width = CGFloat(dict["width"] as! NSNumber)
            let height = CGFloat(dict["height"] as! NSNumber)
            let url = dict["url"] as! String
            
            let bgView = UIView(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH))
            bgView.backgroundColor = UIColor(red:0.110,  green:0.102,  blue:0.110, alpha:1)
            self.view.addSubview(bgView)
            
            let tempImageView = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
            tempImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(contentsOfFile: Bundle.main.path(forResource: "www/images/loading.jpg", ofType: nil)!), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
           
            self.view.addSubview(tempImageView)
            
            // 显示出图片浏览器
            let newsPhotoBrowserVc = NewsPhotoBrowserVC()
//            newsPhotoBrowserVc?.transitioningDelegate = self
            newsPhotoBrowserVc?.modalPresentationStyle = .custom
            let imgs = self.model?.attachment_value.components(separatedBy: ",")
            newsPhotoBrowserVc?.photoParam = (imgs!, index)
            VCController.push(newsPhotoBrowserVc!, with: nil)

            UIView.animate(withDuration: 0.3, animations: {
                tempImageView.frame = CGRect(x: 0, y: (kScreenH - height * (kScreenW / width)) * 0.5, width: kScreenW, height: height * (kScreenW / width))
            }, completion: { (_) in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                    bgView.removeFromSuperview()
                    tempImageView.removeFromSuperview()
                }
            })
            
        })
    }
    
    /**
     准备UI
     */
    func prepareUI() {
        
        // 注册cell
        tableView.register(UINib(nibName: "JFStarAndShareCell", bundle: nil), forCellReuseIdentifier: detailStarAndShareIdentifier)
        tableView.register(UINib(nibName: "JFDetailOtherCell", bundle: nil), forCellReuseIdentifier: detailOtherLinkIdentifier)
        tableView.register(UINib(nibName: "JFDetailOtherNoneCell", bundle: nil), forCellReuseIdentifier: detailOtherLinkNoneIdentifier)
        tableView.register(UINib(nibName: "JFCommentCell", bundle: nil), forCellReuseIdentifier: detailCommentIdentifier)
        tableView.tableHeaderView = webView
        tableView.tableFooterView = closeDetailView
        
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)

        view.addSubview(bottomBarView)
        view.addSubview(activityView)
        
        bottomBarView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(45)
        }
        
        
        self.clTextView = CLTextView(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH))
        self.clTextView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    /**
     请求页面数据和评论数据
     */
    func updateData() {
        
        loadNewsDetail()
        loadCommentList()
    }
    
    /**
     加载正文数据
     
     - parameter classid: 当前子分类id
     - parameter id:      文章id
     */
    func loadNewsDetail() {
        
        activityView.startAnimating()
        
        let objData = self.pageData?.anyObj as! TopicData
        
        let params = NSMutableDictionary()
        params.setValue(objData.group_id, forKey: "group_id")
        params.setValue(objData.id, forKey: "invitation_id")
        params.setValue(objData.last_version, forKey: "invitation_version_id")
        
        self.startLoadEmpty(nil)
        
        ApiUtil.share.getInvitation(params: params) { [weak self] (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                self?.stopLoadEmpty()
                let model = DetailModel.deserialize(from: data!)?.data
                self?.model = model
                self?.tableView.reloadData()
                
            }else if B_ResponseStatus.failure == status {
                self?.stopLoadEmpty()
            }
            
        }

    }
    
    // MARK: - 懒加载
    /// 尾部关闭视图
    lazy var closeDetailView: JFCloseDetailView = {
        let closeDetailView = JFCloseDetailView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 26))
        closeDetailView.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        closeDetailView.setTitleColor(UIColor(white: 0.2, alpha: 1), for: UIControlState())
        closeDetailView.setTitleColor(UIColor(white: 0.2, alpha: 1), for: UIControlState.selected)
        closeDetailView.isSelected = false
        closeDetailView.setTitle("上拉关闭当前页", for: UIControlState())
        closeDetailView.setImage(UIImage(named: "newscontent_drag_arrow"), for: UIControlState())
        closeDetailView.setTitle("释放关闭当前页", for: UIControlState.selected)
        closeDetailView.setImage(UIImage(named: "newscontent_drag_return"), for: UIControlState.selected)
        return closeDetailView
    }()
    
    /// tableView - 整个容器
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: self.naviBar().bottom, width: kScreenW, height: kScreenH - self.naviBar().bottom), style: UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        return tableView
    }()
    
    /// webView - 显示正文的
    lazy var webView: UIWebView = {
        let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH))
        webView.dataDetectorTypes = UIDataDetectorTypes()
        webView.delegate = self
        webView.scrollView.isScrollEnabled = false
        return webView
    }()
    
    /// 活动指示器 - 页面正在加载时显示
    lazy var activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityView.center = self.view.center
        return activityView
    }()
    
    /// 底部工具条
    lazy var bottomBarView: JFNewsBottomBar = {
        let bottomBarView = Bundle.main.loadNibNamed("JFNewsBottomBar", owner: nil, options: nil)?.last as! JFNewsBottomBar
        bottomBarView.delegate = self
        return bottomBarView
    }()
    
    /// 尾部更多评论按钮
    lazy var footerView: UIView = {
        let moreCommentButton = UIButton(frame: CGRect(x: 20, y: 20, width: kScreenW - 40, height: 44))
        moreCommentButton.addTarget(self, action: #selector(didTappedmoreCommentButton(_:)), for: UIControlEvents.touchUpInside)
        moreCommentButton.setTitle("更多评论", for: UIControlState())
        
        moreCommentButton.backgroundColor = Util.getNavBgColor()
        moreCommentButton.layer.cornerRadius = 10
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 44))
        footerView.addSubview(moreCommentButton)
        return footerView
    }()

}

