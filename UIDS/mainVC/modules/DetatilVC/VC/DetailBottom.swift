//
//  DetailBottom.swift
//  UIDS
//
//  Created by one2much on 2018/1/24.
//  Copyright © 2018年 one2much. All rights reserved.
//

import Foundation


// MARK: - 底部浮动工具条相关
extension NewsDetailVC: JFNewsBottomBarDelegate, CLBottomCommentViewDelegate {
    
    func bottomViewDidShare() {
        
    }
    
    func bottomViewDidMark(_ markButton: UIButton) {
        
    }
    
    func cl_textViewDidChange(_ textView: CLTextView) {
        
    }
    
    func cl_textViewDidEndEditing(_ textView: CLTextView) {
        
        if textView.commentTextView.text.count != 0 {
            let objData = self.pageData?.anyObj as! TopicData
            
            let params = NSMutableDictionary()
            params.setValue(textView.commentTextView.text, forKey: "content")
            params.setValue(objData.id, forKey: "group_invitation_id")
            params.setValue(objData.group_pid, forKey: "group_pid")
            
            ApiUtil.share.addReply(params: params) {[weak self] (status, data, msg) in
                
                let obj = ReplyModel.deserialize(from: data)?.data
                self?.commentList.insert(obj!, at: 0)
                self?.tableView.reloadData()
            }
        }
    }
    
    
    func didTappedCollectButton(_ button: UIButton) {
        
    }
    
    func didTappedShareButton(_ button: UIButton) {
        var actionArr = [AlertActionInfo]()
        let params = NSMutableDictionary()
        params.setValue(self.model?.id, forKey: "group_invation_id")
        params.setValue(self.model?.group_pid, forKey: "group_pid")
        let tortInfo = AlertActionInfo.init(title: "侵权举报", style: UIAlertActionStyle.destructive) { (action) in
            params.setValue("侵权举报", forKey: "reason")
            ApiUtil.share.tipOffInvitation(params: params, fininsh: { (status, data, msg) in
                if status == B_ResponseStatus.success{
                    Util.msg(msg: "举报成功", 2)
                }
            })
        }
        let damageInfo = AlertActionInfo.init(title: "有害信息举报", style: UIAlertActionStyle.destructive) { (action) in
            params.setValue("有害信息举报", forKey: "reason")
            ApiUtil.share.tipOffInvitation(params: params, fininsh: { (status, data, msg) in
                if status == B_ResponseStatus.success{
                    Util.msg(msg: "举报成功", 2)
                }
            })
        }
        let cancleInfo = AlertActionInfo.init(title: "取消", style: UIAlertActionStyle.cancel, actionClosure: nil)
        actionArr.append(tortInfo)
        actionArr.append(damageInfo)
        actionArr.append(cancleInfo)
        EasyAlert.showAlertVC(title: "举报", message: "请选择举报的类型", style: .alert, actionInfos: actionArr)
    }
    
    func didTappedPraiseButton(_ button: UIButton) {
        let isSelected = button.isSelected == true ? false : true
        //发送请求记录按钮状态
        let params = NSMutableDictionary()
        params.setValue(model?.group_pid, forKey: "group_pid")
        params.setValue(model?.id, forKey: "group_invitation_id")
        params.setValue(isSelected, forKey: "praise")
        ApiUtil.share.cms_zan(params: params) { (status, data, msg) in
            if B_ResponseStatus.success == status{
                //请求成功，切换按钮状态，刷新前一页面列表
                DispatchQueue.main.async(execute: {
                    button.isSelected = isSelected
                    self.refreshPreList()
                })
            }else{
                Util.msg(msg: msg!, 3)
            }
        }
    }
    
    func didTappedCommentButton(_ button: UIButton) {
        let setFontSizeView = Bundle.main.loadNibNamed("JFSetFontView", owner: nil, options: nil)?.last as! JFSetFontView
        setFontSizeView.delegate = self
        setFontSizeView.show()
    }
    
    func didTappedSendButtonWithMessage(_ message: String) {
        
    }
    
    
    // 开始拖拽视图
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        contentOffsetY = scrollView.contentOffset.y
    }
    
    // 松手后触发
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if (scrollView.contentOffset.y + self.tableView.height) > scrollView.contentSize.height {
            if (scrollView.contentOffset.y + self.tableView.height) - scrollView.contentSize.height >= 50 {
                
                UIGraphicsBeginImageContext(CGSize.init(width: kScreenW, height: kScreenH))
                UIApplication.shared.keyWindow?.layer.render(in: UIGraphicsGetCurrentContext()!)
                let tempImageView = UIImageView(image: UIGraphicsGetImageFromCurrentImageContext())
                UIApplication.shared.keyWindow?.addSubview(tempImageView)
                
                VCController.pop(with: nil)
                UIView.animate(withDuration: 0.3, animations: {
                    tempImageView.alpha = 0
                    tempImageView.frame = CGRect(x: 0, y: kScreenH * 0.5, width: kScreenW, height: 0)
                }, completion: { (_) in
                    tempImageView.removeFromSuperview()
                })
                
            }
        }
    }
    
    /**
     手指滑动屏幕开始滚动
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView.isDragging) {
            if scrollView.contentOffset.y - contentOffsetY > 5.0 {
                // 向上拖拽 隐藏
                UIView.animate(withDuration: 0.25, animations: {
                    self.bottomBarView.transform = CGAffineTransform(translationX: 0, y: 44)
                })
            } else if contentOffsetY - scrollView.contentOffset.y > 5.0 {
                UIView.animate(withDuration: 0.25, animations: {
                    self.bottomBarView.transform = CGAffineTransform.identity
                })
            }
            
        }
        
        if (scrollView.contentOffset.y + self.tableView.height) > scrollView.contentSize.height {
            if (scrollView.contentOffset.y + self.tableView.height) - scrollView.contentSize.height >= 50 {
                closeDetailView.isSelected = true
            } else {
                closeDetailView.isSelected = false
            }
        }
    }
    
    /**
     滚动减速结束
     */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // 滚动到底部后 显示
        if case let space = scrollView.contentOffset.y + kScreenH - scrollView.contentSize.height, space > -5 && space < 5 {
            UIView.animate(withDuration: 0.25, animations: {
                self.bottomBarView.transform = CGAffineTransform.identity
            })
        }
    }
    
    /**
     底部编辑按钮点击
     */
    func didTappedEditButton(_ button: UIButton) {
        self.clTextView?.delegate = self
        self.clTextView?.show()
    }
    
}
