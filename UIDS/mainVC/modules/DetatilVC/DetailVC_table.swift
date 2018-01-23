//
//  DetailVC_table.swift
//  UIDS
//
//  Created by one2much on 2018/1/23.
//  Copyright © 2018年 one2much. All rights reserved.
//

import Foundation

extension DetatilVC {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return self.webView
        } else if section == 1 {
            let head = NewsDetailBottomCell.theSectionHeaderCell()
            head.sectionHeaderLabel.text = "热门跟贴"
            return head
        } else if section == 2 {
            let head = NewsDetailBottomCell.theSectionHeaderCell()
            head.sectionHeaderLabel.text = "相关新闻"
            return head
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return self.webView.height
        } else if section == 1 {
            return 40
        } else if section == 2 {
            return 40
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 2 {
            closeCell = NewsDetailBottomCell.theCloseCell()
            return closeCell
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 64
        }
        return 15
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 1 {
//            if indexPath.row == 1 {
//                performSegue(withIdentifier: "toReply", sender: nil)
//            }
//        } else if indexPath.section == 2 {
//            if indexPath.row > 0 {
//                let model = NewsEntity()
////                model.docid = viewModel.sameNews[indexPath.row].id
//
//                let sb = UIStoryboard(name: "News", bundle: nil)
////                let devc = sb.instantiateViewController(withIdentifier: "SXDetailPage") as! DetailPage
////                devc.newsModel = model
////                navigationController!.pushViewController(devc, animated: true)
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return NewsDetailBottomCell.theShareCell()
        } else if indexPath.section == 1 {
            if indexPath.row == 1 {
                let foot = NewsDetailBottomCell.theSectionBottomCell()
                return foot
            } else {
                let hotReply = NewsDetailBottomCell.theHotReplyCell(withTableView: tableView)
//                hotReply.replyModel = viewModel.replyModels[indexPath.row]
                return hotReply
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let cell = NewsDetailBottomCell.theKeywordCell()
                cell.contentView.addSubview(addKeywordButton())
                return cell
            } else {
                let other = NewsDetailBottomCell.theContactNewsCell()
//                other.sameNewsEntity = viewModel.sameNews[indexPath.row]
                return other
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 126
        } else if indexPath.section == 1 {
            if indexPath.row == 1 {
                return 50
            } else {
                return 110.5
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                return 60
            } else {
                return 81
            }
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 126
        } else if indexPath.section == 1 {
            if indexPath.row == 1 {
                return 50
            } else {
                return 110.5
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                return 60
            } else {
                return 81
            }
        }
        return CGFloat.leastNormalMagnitude
    }
}
