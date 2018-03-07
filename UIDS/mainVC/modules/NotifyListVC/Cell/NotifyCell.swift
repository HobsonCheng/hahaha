//
//  MessageCell.swift
//  UIDS
//
//  Created by Hobson on 2018/3/3.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class NotifyCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var cellData: NotifyData?{
        didSet{
            let sender_name = cellData?.sender_name
            let action_name = cellData?.action_name
            self.timeLabel.text = cellData?.add_time
            self.nameLabel.text = sender_name
            if let name = action_name{
                switch name{
                case "点赞":
                    self.messageLabel.text = (cellData?.sender_name)! + "给您的"+(cellData?.target_name)!+"点赞"
                case "发帖":
                    self.messageLabel.text = (cellData?.sender_name)! + "发表了新帖"
                case "评论帖子":
                    self.messageLabel.text = (cellData?.sender_name)! + "评论了您的" + (cellData?.target_name)!
                case "新预约":
                    self.messageLabel.text = (cellData?.sender_name)! + "有新的" + (cellData?.action_object_name)!
                case "完成订单":
                    self.messageLabel.text = (cellData?.sender_name)! + "完成了" + (cellData?.action_object_name)!
                case "被抢":
                    self.messageLabel.text = (cellData?.sender_name)! + "抢走了" + (cellData?.target_name)! + "的" + (cellData?.action_object_name)!
                default:
                    self.messageLabel.text = (cellData?.sender_name)! + "有新的消息"
                }
            }

            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
