//
//  DetailChange.swift
//  UIDS
//
//  Created by one2much on 2018/1/24.
//  Copyright © 2018年 one2much. All rights reserved.
//

import Foundation

// MARK: - 修改字体相关
extension NewsDetailVC: JFSetFontViewDelegate {
    
    /**
     自动布局webView
     */
    func autolayoutWebView() {
        
        let result = self.webView.stringByEvaluatingJavaScript(from: "getHtmlHeight();")
        
        if let height = result {
            self.webView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: CGFloat((height as NSString).floatValue) + 20)
            self.tableView.tableHeaderView = self.webView
            self.activityView.stopAnimating()
        }
    }
    
    /**
     修改了正文字体大小，需要重新显示 添加图片缓存后，目前还有问题
     */
    func didChangeFontSize(_ fontSize: Int) {
        
        self.webView.stringByEvaluatingJavaScript(from: "setFontSize(\"\(fontSize)\");")
        autolayoutWebView()
    }
    
    /**
     修改了正文字体
     
     - parameter fontNumber: 字体编号
     - parameter fontPath:   字体路径
     - parameter fontName:   字体名称
     */
    func didChangedFontName(_ fontName: String) {
        
        self.webView.stringByEvaluatingJavaScript(from: "setFontName(\"\(fontName)\");")
        autolayoutWebView()
    }
    
    /**
     修改了夜间/白日模式
     
     - parameter on: true则是夜间模式
     */
    func didChangedNightMode(_ on: Bool) {
        
        // 切换代码
        
    }
}
