//
//  DetatilVC.swift
//  UIDS
//
//  Created by one2much on 2018/1/23.
//  Copyright © 2018年 one2much. All rights reserved.
//
import UIKit

let kBottomViewHeight: CGFloat = 46.0


class DetatilVC: NaviBarVC, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, CLBottomCommentViewDelegate {
    
    
    // MARK: - Properties
    
    var newsModel: NewsEntity! {
        didSet {
            print("dssd")
        }
    }

    var index: Int!
    
    var bigImg: UIImageView!
    var hoverView: UIView!
    var closeCell: NewsDetailBottomCell!
    var temImgPara: [String: String]!
    
    
    var pageData: PageInfo?
    
    var bottomView: CLBottomCommentView?
    
    lazy private var news: Array<[String: String]>! = {
        guard let filePath = Bundle.main.path(forResource: "NewsURLs.plist", ofType: nil) else {
            return nil
        }
        return NSArray(contentsOfFile: filePath) as! Array<[String: String]>
    }()
    
    lazy var webView: UIWebView = {
        let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 700))
        return webView
    }()
    
    lazy private var viewModel: NewsDetailViewModel = {
        return NewsDetailViewModel()
    }()
    
    var detailInfo: DetailData?
    
    
    var backBtn: UIButton!
    var replyCountBtn: UIButton!
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNaviDefulat()
        self.naviBar().setTitle("😎")
        
        //table
        self.tableView = UITableView.init(frame: CGRect.init(x: 0, y: self.naviBar().bottom, width: kScreenW, height: self.view.height - self.naviBar().height), style: UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView!)
        
        webView.delegate = self
        hoverView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH))
        hoverView.backgroundColor = UIColor.black
        let downLoad = UIButton(frame: CGRect(x: kScreenW - 60, y: kScreenH - 60,
                                              width: 50, height: 50))
        downLoad.setImage(UIImage(named: "203"), for: .normal)
        self.hoverView.addSubview(downLoad)
        
        downLoad.rx.tap.do(onNext: { [weak self] in
            
            if let image = self?.bigImg.image {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
            
        }).subscribe().disposed(by: rx.disposeBag)
        
        
        self.getDetilinfo()
        
        automaticallyAdjustsScrollViewInsets = false
        
    
        self.bottomView = CLBottomCommentView.init(frame: CGRect.init(x: 0, y: (kScreenH - kBottomViewHeight), width: kScreenW, height: kBottomViewHeight))
        self.bottomView?.delegate = self;
        self.bottomView?.clTextView?.delegate = self;
        self.view.addSubview(self.bottomView!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.url!.absoluteString
        if url.range(of: "sx:") != nil {
            showPicture(withAbsoluteUrl: url)
            return false
        }
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.height = webView.scrollView.contentSize.height
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "contentStart"),
                                                     object: nil, userInfo: nil))
    }
    
    // MARK: - UIScrollViewDelegate and Drag to Close
    
    private func newDetailControllerClose() -> Bool {
        return tableView.contentOffset.y - (tableView.contentSize.height - kScreenH + 55) > (100 - 54)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if closeCell != nil {
            closeCell.isClosing = newDetailControllerClose()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if newDetailControllerClose() {
            let imgV = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH))
            imgV.image = getImage()
            let window = UIApplication.shared.keyWindow!
            window.addSubview(imgV)
            VCController.pop(with: VCAnimationBottom.defaultAnimation())
            imgV.alpha = 1.0
            UIView.animate(withDuration: 0.3, animations: {
                imgV.frame = CGRect(x: 0, y: kScreenH / 2, width: kScreenW, height: 0)
                imgV.alpha = 0.0
            }, completion: { finished in
                imgV.removeFromSuperview()
            })
        }
    }
    
    
    // MARK: - Private Methods
    
    private func requestForFeedbackList() {
        
    }
    
    func addKeywordButton() -> UIView {
        var maxRight: CGFloat = 20
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 60))
        for i in 0...4 {
            let button = UIButton(frame: CGRect(x: maxRight, y: 10, width: 0, height: 0))
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.setTitleColor(UIColor(red: 74, green: 133, blue: 198, alpha: 1.0),
                                 for: .normal)
            button.setTitle("bai", for: .highlighted)
            button.setBackgroundImage(UIImage(named: "choose_city_normal.png"), for: .normal)
            button.setBackgroundImage(UIImage(named: "choose_city_highlight.png"), for: .highlighted)
            button.sizeToFit()
            button.width += 20
            button.height = 35
            
            maxRight = button.left + button.width + 10
            view.addSubview(button)
        }
        return view
    }
    
    private func showPicture(withAbsoluteUrl url: String) {
        view.isUserInteractionEnabled = false
        let range = url.range(of: "github.com/dsxNiubility?")!
        let path = range.upperBound
        let tail = url.substring(from: path)
        let keyValues = tail.components(separatedBy: "&")
        var parameters = [String: String]()
        for str in keyValues {
            let keyValue = str.components(separatedBy: "=")
            if keyValue.count == 2 {
                parameters[keyValue[0]] = keyValue[1]
            } else if keyValues.count > 2 {
                if let range = str.range(of: "src=") {
                    let value = str.substring(from: range.upperBound)
                    parameters["src"] = value
                }
            }
        }
        temImgPara = parameters
        let cache = URLCache.shared
        if let srcPath = parameters["src"] {
            let request = URLRequest(url: URL(string: srcPath)!)
            
            let imgView = UIImageView()
            imgView.frame.origin = CGPoint(x: 8, y: 0)
            bigImg = imgView
            
            if let imgData = cache.cachedResponse(for: request)?.data,
                let image = UIImage(data: imgData) {
                
                var top: CGFloat = tableView.top - tableView.contentOffset.y
                var height: CGFloat = 0.0
                if let t = parameters["top"] {
                    top  += CGFloat((t as NSString).floatValue)
                }
                
                if let s = parameters["whscale"] {
                    height = (kScreenW - 15) / CGFloat((s as NSString).floatValue)
                }
                
                temImgPara["top"] = "\(top)"
                temImgPara["height"] = "\(height)"
                
                imgView.image = image
                imgView.frame = CGRect(x: 8, y: top, width: kScreenW - 15, height: height)
                
                hoverView.alpha = 0
                
            } else {
                imgView.sd_setImage(with: URL(string: srcPath), completed: { [weak self] (image, error, cacheType, url) in
                    self?.moveToCenter()
                })
            }
            moveToCenter()
            
            imgView.rx.tapGesture(numberOfTouchesRequired: 1, numberOfTapsRequired: 1, configuration: { [weak self] (c, b) in
                self?.moveToOrigin()
            })
        }
    }
    
    @objc private func moveToOrigin() {
        UIView.animate(withDuration: 0.5, animations: {
            self.hoverView.alpha = 0.0
            if let t = self.temImgPara["top"], let h = self.temImgPara["height"] {
                let y = CGFloat((t as NSString).floatValue)
                let h = CGFloat((h as NSString).floatValue)
                
                self.hoverView.alpha = 0
                self.bigImg.frame = CGRect(x: 8.0, y: y,
                                           width: kScreenW - 15, height: h)
            }
            
        }, completion: { finished in
            self.hoverView.removeFromSuperview()
            self.bigImg.removeFromSuperview()
            self.bigImg = nil
            
        })
    }
    
    private func moveToCenter() {
        
        let w: CGFloat = kScreenW
        let h: CGFloat = kScreenW / CGFloat((temImgPara["whscale"]! as NSString).floatValue)
        let x: CGFloat = 0
        let y: CGFloat = (kScreenH - h) / 2
        
        UIView.animate(withDuration: 0.5, animations: {
            self.hoverView.alpha = 1.0
            self.bigImg.frame = CGRect(x: x, y: y, width: w, height: h)
        }, completion: { finished in
            self.view.isUserInteractionEnabled = true
        })
    }
    
    private func getImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: kScreenW, height: kScreenH), false, 1.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}



