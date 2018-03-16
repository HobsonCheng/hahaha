//
//  DetailTable.swift
//  UIDS
//
//  Created by one2much on 2018/1/24.
//  Copyright © 2018年 one2much. All rights reserved.
//

import Foundation

// MARK: - tableView相关
extension NewsDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // 这样做是为了防止还没有数据的时候滑动崩溃哦
        return model == nil ? 0 : 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // 分享
            return 1
        case 1: // 广告
            return 1
        case 2: // 相关阅读
            return otherLinks.count
        case 3: // 评论、最多显示10条
            return commentList.count >= 10 ? 10 : commentList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // 分享
            let cell = self.tableView.dequeueReusableCell(withIdentifier: self.detailStarAndShareIdentifier) as! JFStarAndShareCell
            //            cell.delegate = self as! JFStarAndShareCellDelegate
            cell.befromLabel.text = "文章来源: \(model!.source!)"
            cell.selectionStyle = .none
            return cell
        case 1: // 广告
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            cell.contentView.addSubview(adImageView)
            return cell
        case 2: // 相关阅读
            
            let model = otherLinks[indexPath.row]
            
            if model == nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: detailOtherLinkNoneIdentifier) as! JFDetailOtherNoneCell
                //                cell.model = model
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: detailOtherLinkIdentifier) as! JFDetailOtherCell
                //                cell.model = model
                return cell
            }
            
        case 3: // 评论
            let cell = tableView.dequeueReusableCell(withIdentifier: detailCommentIdentifier) as! JFCommentCell
            cell.delegate = self
            cell.commentModel = commentList[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    // 组头
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // 相关阅读和最新评论才需要创建组头
        if section == 2 || section == 3 {
            
            // 竖线
            let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: 30))
            
            leftView.backgroundColor = Util.getNavBgColor()
            
            // 灰色背景
            let bgView = UIView(frame: CGRect(x: 3, y: 0, width: kScreenW - 3, height: 30))
            bgView.backgroundColor = UIColor(red:0.914,  green:0.890,  blue:0.847, alpha:0.3)
            
            // 组头名称
            let titleLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 100, height: 30))
            
            // 组头容器 （因为组头默认是和cell一样宽，高度也是委托方法里返回，所以里面的子控件才需要布局）
            let headerView = UIView()
            headerView.addSubview(leftView)
            headerView.addSubview(bgView)
            headerView.addSubview(titleLabel)
            
            if section == 2 {
                titleLabel.text = "相关阅读"
                return otherLinks.count == 0 ? nil : headerView
            } else {
                titleLabel.text = "最新评论"
                return commentList.count == 0 ? nil : headerView
            }
            
        } else {
            return nil
        }
    }
    
    // 组尾
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 3 {
            // 如果有评论信息就添加更多评论按钮 超过10条才显示更多评论
            return commentList.count >= 10 ? footerView : nil // 如果有评论才显示更多评论按钮
        } else {
            return nil
        }
    }
    
    // cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: // 分享
            return 57
        case 1: // 广告
            return 0
        case 2: // 相关阅读
            let rowHeight = 100
//            let model = otherLinks[indexPath.row]
//            if model != nil {
//                //                let cell = tableView.dequeueReusableCell(withIdentifier: detailOtherLinkNoneIdentifier) as! JFDetailOtherNoneCell
//                //                // 缓存评论cell高度
//                //                otherLinks[indexPath.row].rowHeight = cell.getRowHeight(model)
//                //                rowHeight = otherLinks[indexPath.row].rowHeight
//                return CGFloat(rowHeight)
//            } else {
                return 100
//            }
        case 3: // 评论
            var rowHeight = commentList[indexPath.row].rowHeight
            if rowHeight < 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: detailCommentIdentifier) as! JFCommentCell
                commentList[indexPath.row].rowHeight = cell.getCellHeight(commentList[indexPath.row])
                // 缓存评论cell高度
                rowHeight = commentList[indexPath.row].rowHeight
                return rowHeight
            }
            return rowHeight
        default:
            return 0
        }
    }
    
    // 组头高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.1
        case 1:
            return 10
        case 2:
            return otherLinks.count == 0 ? 0.1 : 30
        case 3:
            return commentList.count == 0 ? 0.1 : 35
        default:
            return 0.1
        }
    }
    
    // 组尾高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.1
        case 1:
            return 20
        case 2:
            return otherLinks.count == 0 ? 0.1 : 15
        case 3:
            return commentList.count >= 10 ? 100 : (commentList.count > 0 ? 20 : 0.1)
        default:
            return 0.1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 2 {
            
        }
    }
}
