//
//  DetailWeb.swift
//  UIDS
//
//  Created by one2much on 2018/1/24.
//  Copyright © 2018年 one2much. All rights reserved.
//

import Foundation


// MARK: - webView相关
extension NewsDetailVC: UIWebViewDelegate {
    
    /**
     webView加载完成后更新webView高度并刷新tableView
     */
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        autolayoutWebView()
        if !webView.isLoading {
            
            if self.model?.attachment_value.count != 0 {
                
                let imgs = self.model?.attachment_value.components(separatedBy: ",")
                
                // 加载正文图片 - 从缓存中获取图片的本地绝对路径，发送给webView显示
                // 因为需要执行js代码，所以尽量在webView加载完成后调用
                getImageFromDownloaderOrDiskByImageUrlArray(imgs!)
            }
        }
    }
    
    /**
     过滤html，有需要过滤的直接写到这个方法
     
     - parameter string: 过滤前的html
     
     - returns: 过滤后的html
     */
    func filterHTML(_ string: String) -> String {
        var tempHtml = (string as NSString).replacingOccurrences(of: "<p>&nbsp;</p>", with: "")
        tempHtml = (tempHtml as NSString).replacingOccurrences(of: " style=\"text-indent: 2em;\"", with: "")
        return tempHtml
    }
    
    /**
     加载webView内容
     
     - parameter model: 新闻模型
     */
    func loadWebViewContent(_ model: DetailData) {
        
        // 如果不熟悉网页，可以换成GRMutache模板更配哦
        var html = ""
        html += "<div class=\"title\">\(model.title!)</div>"
        html += "<div class=\"time\">\(model.source!)&nbsp;&nbsp;&nbsp;&nbsp;\(model.add_time!)</div>"
        
        // 临时正文 - 这样做的目的是不修改模型
        var tempNewstext = model.content!
        
        // 有图片才去拼接图片
        
        var index = 0
        
        if self.model?.attachment_value.count != 0 {
            
            let imgs = self.model?.attachment_value.components(separatedBy: ",")
            
            // 拼接图片标签
            for insetPhoto in imgs! {
                // 图片占位符范围
                //                let range = (tempNewstext as NSString).range(of: "insetPhoto.ref")
                
                // 默认宽、高为0
                var width = kScreenW - 20
                
                // 如果图片超过了最大宽度，才等比压缩 这个最大宽度是根据css里的container容器宽度来自适应的
                if width >= kScreenW - 40 {
                    let rate = (kScreenW - 40) / width
                    width = width * rate
                }
                
                // 加载中的占位图
                let loading = Bundle.main.path(forResource: "www/images/loading.jpg", ofType: nil)!
                
                // 图片URL
                let imgUrl = insetPhoto
                print("imgUrl = \(imgUrl)")
                
                // img标签
                let imgTag = "<img onclick='didTappedImage(\(index), \"\(imgUrl)\");' src='\(loading)' id='\(imgUrl)' style=\"width:\(width)px\";/>"
                //                tempNewstext = (tempNewstext as NSString).replacingOccurrences(of: "insetPhoto.ref", with: imgTag, options: NSString.CompareOptions.caseInsensitive, range: range)
                tempNewstext.append(imgTag)
                
                index = index + 1
            }
        }
        
        tempNewstext = (tempNewstext as NSString).replacingOccurrences(of: " style=\"text-indent: 2em;\"", with: "")
        
        let fontSize = UserDefaults.standard.integer(forKey: CONTENT_FONT_SIZE_KEY)
        let fontName = UserDefaults.standard.string(forKey: CONTENT_FONT_TYPE_KEY)!
        
        html += "<div id=\"content\" style=\"font-size: \(fontSize)px; font-family: '\(fontName)';\">\(tempNewstext)</div>"
        
        // 从本地加载网页模板，替换新闻主页
        let templatePath = Bundle.main.path(forResource: "www/html/article.html", ofType: nil)!
        let template = (try! String(contentsOfFile: templatePath, encoding: String.Encoding.utf8)) as NSString
        html = template.replacingOccurrences(of: "<p>mainnews</p>", with: html, options: NSString.CompareOptions.caseInsensitive, range: template.range(of: "<p>mainnews</p>"))
        let baseURL = URL(fileURLWithPath: templatePath)
        webView.loadHTMLString(filterHTML(html), baseURL: baseURL)
        
        // 已经加载过就修改标记
        isLoaded = true
    }
    
    /**
     下载或从缓存中获取图片，发送给webView
     */
    func getImageFromDownloaderOrDiskByImageUrlArray(_ imageArray: [String]) {
        
        // 循环加载图片
        for insetPhoto in imageArray {
            
            // 图片url
            let imageString = insetPhoto
            
            //开始缓存数据
            SDWebImageManager.shared().diskImageExists(for: URL(string: imageString), completion: { [weak self] (isExit) in
                
                if isExit {//存在图片
                    let cacheImageKey = SDWebImageManager.shared().cacheKey(for: URL(string: imageString))
                    if cacheImageKey?.count != 0 {
                        let cacheImagePath = SDImageCache.shared().defaultCachePath(forKey: cacheImageKey)
                        // 发送图片占位标识和本地绝对路径给webView
                        self?.bridge?.send("replaceimage\(imageString)~\(cacheImagePath!)")
                        print("图片已有缓存，发送给js \(cacheImagePath!)")
                        
                        return
                    }
                }
                
                //去异步加载图片
                SDWebImageDownloader.shared().downloadImage(with: URL(string: imageString), options: SDWebImageDownloaderOptions.scaleDownLargeImages, progress: nil, completed: { (img, data, error, status) in
                    
                    SDImageCache.shared().store(img, imageData: data, forKey: imageString, toDisk: true, completion: {
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.15 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                            
                            //开始缓存数据
                            SDWebImageManager.shared().diskImageExists(for: URL(string: imageString), completion: { [weak self] (isExit) in
                                
                                if isExit {//存在图片
                                    let cacheImageKey = SDWebImageManager.shared().cacheKey(for: URL(string: imageString))
                                    if cacheImageKey?.count != 0 {
                                        let cacheImagePath = SDImageCache.shared().defaultCachePath(forKey: cacheImageKey)
                                        // 发送图片占位标识和本地绝对路径给webView
                                        self?.bridge?.send("replaceimage\(imageString)~\(cacheImagePath!)")
                                        print("图片已有缓存，发送给js \(cacheImagePath)")
                                        
                                        return
                                    }
                                }
                            })
                        }
                    })
                })
                
            })
        }
        
    }
    
}
