//
//  JFNewsBottomBar.swift
//  UIDS
//
//  Created by bai on 16/4/1.
//  Copyright © 2016年 bai. All rights reserved.
//

import UIKit

protocol JFNewsBottomBarDelegate {
    func didTappedEditButton(_ button: UIButton)
    func didTappedCollectButton(_ button: UIButton)
    func didTappedShareButton(_ button: UIButton)
    func didTappedCommentButton(_ button: UIButton)
}

class JFNewsBottomBar : UIView {
    
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var collectionButton: UIButton!
    
    var delegate: JFNewsBottomBarDelegate?
    
    @IBAction func didTappedEditButton(_ button: UIButton) {
        delegate?.didTappedEditButton(button)
    }
    
    @IBAction func didTappedCommentButton(_ button: UIButton) {
        delegate?.didTappedCommentButton(button)
    }
    
    @IBAction func didTappedCollectButton(_ button: UIButton) {
        delegate?.didTappedCollectButton(button)
    }
    
    @IBAction func didTappedShareButton(_ button: UIButton) {
        delegate?.didTappedShareButton(button)
    }
    
}
