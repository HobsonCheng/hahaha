//
//  CLTextView.swift
//  UIDS
//
//  Created by one2much on 2018/1/23.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

let kCommentTextViewHeight = 168.0
let kMininumKeyboardHeight = 216.0

class CLTextView: UIView, UITextViewDelegate {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var containerViewConstraintHeight: NSLayoutConstraint!
    var delegate: CLBottomCommentViewDelegate?
    var backgroundView: UIVisualEffectView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed("CLTextView", owner: self, options: nil)
        self.contentView.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH)
        self.addSubview(self.contentView)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        
        self.commentTextView.layer.borderColor = UIColor.init(hex: 0xBCBAC1, alpha: 1).cgColor;
        self.commentTextView.layer.borderWidth = 0.5;
        self.commentTextView.delegate = self;
        
        self.sendButton.setTitleColor(UIColor.init(hex: 0x838383, alpha: 1), for: UIControlState.normal)
        self.sendButton.setTitleColor(UIColor.init(hex: 0x333333, alpha: 1), for: UIControlState.highlighted)
        
        
        let tapGr = UITapGestureRecognizer.init(target: self, action: #selector(CLTextView.tapAction(sender:)))
        let swipeGr = UISwipeGestureRecognizer.init(target: self, action: #selector(CLTextView.swipeAction(sender:)))
        swipeGr.direction = UISwipeGestureRecognizerDirection.down

        self.gestureRecognizers = [tapGr, swipeGr];
        
        self.insertSubview(self.backgroundView!, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CLTextView.keyboardWasShown(aNotification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    
        self.backgroundView = UIVisualEffectView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH))
        self.backgroundView?.backgroundColor = UIColor.black
        self.backgroundView?.alpha = 0.5
        self.backgroundView?.effect = UIBlurEffect.init(style: UIBlurEffectStyle.dark)
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.commentTextView.resignFirstResponder()
        self.dismissCommentTextView()
    }
    
    @IBAction func sendAction(_ sender: Any) {
        self.delegate?.cl_textViewDidEndEditing(self)
        self.commentTextView.resignFirstResponder()
        self.dismissCommentTextView()
    }
    
    func tapAction(sender: UITapGestureRecognizer) {
        self.commentTextView.resignFirstResponder()
        self.dismissCommentTextView()
    }
    func swipeAction(sender: UISwipeGestureRecognizer) {
        if sender.direction == UISwipeGestureRecognizerDirection.down {
            self.commentTextView.resignFirstResponder()
            self.dismissCommentTextView()
        }
    }
    func keyboardWasShown(aNotification: Notification)  {
        
        let info = aNotification.userInfo
//        let kbsize = info[UIKeyboardFrameEndUserInfoKey]
//
//        if (kbSize.height > kMininumKeyboardHeight) {
//            self.containerViewConstraintHeight.constant = kCommentTextViewHeight + 20 + kbSize.height;
//        } else {
//            self.containerViewConstraintHeight.constant = kCommentTextViewHeight + 20 + kMininumKeyboardHeight;
//        }
    }
    
    
    func dismissCommentTextView()  {
        self.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //MARK: - UITextViewDelegate
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
}
