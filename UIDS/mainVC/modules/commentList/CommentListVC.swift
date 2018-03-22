//
//  CommentListVC.swift
//  UIDS
//
//  Created by one2much on 2018/1/24.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import ESPullToRefresh

class CommentListVC: NaviBarVC {
    
    var pageData: PageInfo?
    
    // 页码
    var pageIndex = 1
    var commentList = [ReplyData]()
    
    /// tableView - 整个容器
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: self.naviBar().bottom, width: kScreenW, height: kScreenH - self.naviBar().bottom), style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNaviDefulat()
        
        self.view.addSubview(self.tableView)
        
        tableView.register(UINib(nibName: "JFCommentCell", bundle: nil), forCellReuseIdentifier: "commentCell")
        
        // 配置上下拉刷新控件
        
        //上拉  下拉
        var header: ESRefreshProtocol & ESRefreshAnimatorProtocol
        var footer: ESRefreshProtocol & ESRefreshAnimatorProtocol
        
        header = DS2RefreshHeader.init(frame: CGRect.zero)
        footer = DS2RefreshFooter.init(frame: CGRect.zero)
        
        self.tableView.es.addPullToRefresh(animator: header) { [weak self] in
            self?.updateNewData()
        }
        self.tableView.es.addInfiniteScrolling(animator: footer) { [weak self] in
            self?.loadMoreData()
        }
        
        
        let bottomView = CLBottomCommentView.init(frame: CGRect.init(x: 0, y: kScreenH - 46.0, width: kScreenW, height: 46.0))
        bottomView.delegate = self
        bottomView.clTextView?.delegate = self
        self.view.addSubview(bottomView)
        
        self.tableView.es.startPullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    /**
     下拉加载最新数据
     */
    @objc fileprivate func updateNewData() {
        loadCommentList(pageIndex: 1, method: 0)
    }
    
    /**
     上拉加载更多数据
     */
    @objc fileprivate func loadMoreData() {
        pageIndex += 1
        loadCommentList(pageIndex: pageIndex, method: 1)
    }
    
    /**
     根据id、页码加载评论数据
     - parameter pageIndex:  当前页码
     - parameter method:     加载方式 0下拉加载最新 1上拉加载更多
     */
    func loadCommentList(pageIndex: Int, method: Int) {
        
        let objData = self.pageData?.anyObj as! TopicData
        
        let params = NSMutableDictionary()
        params.setValue(pageIndex, forKey: "page")
        params.setValue("100", forKey: "page_context")
        params.setValue(objData.id, forKey: "group_invitation_id")
        params.setValue(objData.group_pid, forKey: "group_pid")
        
        ApiUtil.share.getRepliesByInvitation(params: params) {[weak self] (status, data, msg) in
            let list = ReplyListModel.deserialize(from: data)?.data
            
            self?.tableView.es.stopLoadingMore()
            self?.tableView.es.stopPullToRefresh()
            
            if data?.count == 0 {
                self?.tableView.es.noticeNoMoreData()
                return
            }
            
            if pageIndex == 1 {
                self?.commentList = list!
            }else {
                self?.commentList += list!
            }
            
            self?.tableView.reloadData()
        }
    }
}

// MARK: - tableView
extension CommentListVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! JFCommentCell
        cell.delegate = self
        cell.commentModel = commentList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 回复指定评论，下一版实现
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight = commentList[indexPath.row].rowHeight
        if rowHeight < 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! JFCommentCell
            commentList[indexPath.row].rowHeight = cell.getCellHeight(commentList[indexPath.row])
            rowHeight = commentList[indexPath.row].rowHeight
        }
        return rowHeight
    }
    
}

// MARK: - JFCommentCellDelegate
extension CommentListVC: JFCommentCellDelegate {
    
    func didTappedStarButton(_ button: UIButton, commentModel: ReplyData) {
        
    
    }
}

extension CommentListVC: CLBottomCommentViewDelegate {
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
            params.setValue(objData.id, forKey: "invitation_id")
            params.setValue(objData.group_id, forKey: "cms_group_id")
            
            ApiUtil.share.addReply(params: params) {[weak self] (status, data, msg) in
                
                let obj = ReplyModel.deserialize(from: data)?.data
                self?.commentList.insert(obj!, at: 0)
                self?.tableView.reloadData()
            }
        }
    }
    
    
    
}


