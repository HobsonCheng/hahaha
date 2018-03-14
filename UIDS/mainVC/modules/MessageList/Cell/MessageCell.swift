//
//  MessageCell.swift
//  UIDS
//
//  Created by Hobson on 2018/3/2.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var sendName: UILabel!
    @IBOutlet weak var sendTime: UILabel!
    @IBOutlet weak var message: UILabel!
    
    var msgModel: MessageModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //显示数据
    func show() {
//        self.sendName.text = msgModel?.name
//        self.sendTime.text = msgModel?.time
//        self.message.text = msgModel?.message
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
