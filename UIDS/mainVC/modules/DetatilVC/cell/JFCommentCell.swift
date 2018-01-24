//
//  JFCommentCell.swift
//  UIDS
//
//  Created by bai on 16/5/18.
//  Copyright © 2016年 bai. All rights reserved.
//

import UIKit

protocol JFCommentCellDelegate {
    func didTappedStarButton(_ button: UIButton, commentModel: ReplyData)
}

class JFCommentCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    var delegate: JFCommentCellDelegate?
    
    var commentModel: ReplyData? {
        didSet {
            guard commentModel != nil else { return }
            avatarImageView.sd_setImage(with: URL.init(string: "commentModel.userpic!"), placeholderImage: UIImage(named: "default－portrait.png"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed:nil)
            usernameLabel.text = commentModel?.user_info.nick_name
            timeLabel.text = commentModel?.add_time
            contentLabel.text = commentModel?.content
            starButton.setTitle("\(10)", for: UIControlState())
        }
    }
    
    func getCellHeight(_ commentModel: ReplyData) -> CGFloat {
        self.commentModel = commentModel
        layoutIfNeeded()
        return contentLabel.frame.maxY + 10
    }
    
    /**
     点击了赞
     */
    @IBAction func didTappedStarButton(_ sender: UIButton) {
        delegate?.didTappedStarButton(sender, commentModel: commentModel!)
    }
    
}
