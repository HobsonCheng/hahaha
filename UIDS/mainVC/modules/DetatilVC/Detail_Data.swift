//
//  Detail_Data.swift
//  UIDS
//
//  Created by one2much on 2018/1/23.
//  Copyright © 2018年 one2much. All rights reserved.
//

import Foundation

extension DetatilVC {
    
    
    func getDetilinfo() {
        
        let objData = self.pageData?.anyObj as! TopicData
        
        let params = NSMutableDictionary()
        params.setValue(objData.group_id, forKey: "group_id")
        params.setValue(objData.id, forKey: "invitation_id")
        params.setValue(objData.last_version, forKey: "invitation_version_id")
        
        self.startLoadEmpty(nil)
        
        ApiUtil.share.getInvitation(params: params) { [weak self] (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                self?.stopLoadEmpty()
                self?.detailInfo = DetailModel.deserialize(from: data!)?.data
                self?.showInWebView()
            }else if B_ResponseStatus.failure == status {
                self?.stopLoadEmpty()
            }
            
        }
        
    }
    
    // MARK: - webView + html
    var htmlString: String {
        
        let cssURL = Bundle.main.url(forResource: "SXDetails.css", withExtension: nil)!.absoluteString
        var html = ""
        html.append("<html>")
        html.append("<head>")
        html.append(String(format: "<link rel=\"stylesheet\" href=\"%@\">", cssURL))
        html.append("</head>")
        
        html.append("<body style=\"background=#f6f6f6\">")
        html.append(bodyhtmlString)
        html.append("</body>")
        
        html.append("</html>")
        return html
    }
    
    private var bodyhtmlString: String {
        var body = ""
        
        body.append(String(format: "<div class=\"title\">%@</div>", (self.detailInfo?.title)!))
        body.append(String(format: "<div class=\"time\">%@</div>", (self.detailInfo?.add_time)!))
        body.append((self.detailInfo?.content)!)
        
        if self.detailInfo?.attachment_value.count != 0 {
            
            let imgs = self.detailInfo?.attachment_value.components(separatedBy: ",")
            
            for img in imgs! {
                var imgHtml = ""
                imgHtml.append("<div class=\"img-parent\">")
                let maxWidth = UIScreen.main.bounds.width - 20
                var width: CGFloat = maxWidth
                
                width = maxWidth
                
                let onload = "this.onclick = function() {" +
                    "  window.location.href = 'sx://github.com/dsxNiubility?src=' +this.src+'&top=' + this.getBoundingClientRect().top + '&whscale=' + this.clientWidth/this.clientHeight ;" +
                "};"
                
                imgHtml.append(String(format: "<img onload=\"%@\" src=\"%@\" style=\"width:%fpx;\">",
                                      onload, img, width))
                imgHtml.append("</div>")
                
                body.append(imgHtml)
            }
        }
    
        return body
    }
    
    private func showInWebView() {
    
        webView.loadHTMLString(self.htmlString, baseURL: nil)
    }
}
