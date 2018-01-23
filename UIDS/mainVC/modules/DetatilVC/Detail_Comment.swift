//
//  Detail_Comment.swift
//  UIDS
//
//  Created by one2much on 2018/1/23.
//  Copyright © 2018年 one2much. All rights reserved.
//

import Foundation

extension DetatilVC {
    
    func bottomViewDidShare() {
        
        Util.msg(msg: "正在分享...", 1)
    }
    
    func bottomViewDidMark(_ markButton: UIButton) {
        Util.msg(msg: "正在收藏中...", 1)
    }
    
    func cl_textViewDidChange(_ textView: CLTextView) {
        Util.msg(msg: "草稿", 1)
    }
   
    func cl_textViewDidEndEditing(_ textView: CLTextView) {
        Util.msg(msg: "正在发送评论中...", 1)
    }

}
