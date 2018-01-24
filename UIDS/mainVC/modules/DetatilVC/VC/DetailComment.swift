//
//  DetailComment.swift
//  UIDS
//
//  Created by one2much on 2018/1/24.
//  Copyright © 2018年 one2much. All rights reserved.
//

import Foundation

// MARK: - 评论相关
extension NewsDetailVC: JFCommentCellDelegate {
    
    /**
     加载评论信息 - 只加载最新的10条
     */
    func loadCommentList() {
        
        let objData = self.pageData?.anyObj as! TopicData
        
        let params = NSMutableDictionary()
        params.setValue("1", forKey: "page")
        params.setValue("100", forKey: "page_context")
        params.setValue(objData.id, forKey: "invitation_id")
        params.setValue(objData.group_id, forKey: "group_id")
        
        ApiUtil.share.getReplyList(params: params) {[weak self] (status, data, msg) in
            let list = ReplyListModel.deserialize(from: data)?.data
            self?.commentList = list!
            self?.tableView.reloadData()
            
        }
    }
    
    /**
     点击了评论cell上的赞按钮
     */
    func didTappedStarButton(_ button: UIButton, commentModel: ReplyData) {
        
        Util.msg(msg: "点赞", 1)
        // 刷新单行
        //        let indexPath = IndexPath(row: self.commentList.index(of: commentModel)!, section: 3)
        //        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    }
    
    /**
     点击更多评论按钮
     */
    func didTappedmoreCommentButton(_ button: UIButton) -> Void {
        
        let commentVc = CommentListVC(name: "commentVc")
        commentVc?.pageData = self.pageData
        VCController.push(commentVc!, with: VCAnimationClassic.defaultAnimation())
        
    }
}
