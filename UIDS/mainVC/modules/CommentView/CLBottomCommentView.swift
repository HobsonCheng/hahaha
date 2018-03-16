//
//  CLBottomCommentView.swift
//  UIDS
//
//  Created by one2much on 2018/1/23.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class CLBottomCommentView: UIView,UITextFieldDelegate {

  
    
    @IBOutlet var contentView: CLBottomCommentView!
    @IBOutlet weak var editTextField: UITextField!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var markButton: UIButton!
    @IBOutlet weak var editView: UIView!
    
    var clTextView: CLTextView?
    var delegate: CLBottomCommentViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed("CLBottomCommentView", owner: self, options: nil)
        self.contentView.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: self.height)
        self.addSubview(self.contentView)
        
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
        self.editView.layer.cornerRadius = 15
        self.editView.clipsToBounds = true
        self.editView.layer.borderColor = UIColor.init(hex: 0xBCBAC1, alpha: 1).cgColor
        self.editView.layer.borderWidth = 0.5
        
        self.shareButton.layer.borderWidth = 0.5
        self.shareButton.layer.borderColor = UIColor.init(hex: 0xBCBAC1, alpha: 1).cgColor
        self.shareButton.layer.cornerRadius = self.shareButton.height / 2
        
        self.markButton.layer.borderWidth = 0.5
        self.markButton.layer.borderColor = UIColor.init(hex: 0xBCBAC1, alpha: 1).cgColor
        self.markButton.layer.cornerRadius = self.markButton.height / 2
        
        let lineView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: self.width, height: 0.5))
        lineView.backgroundColor = UIColor.init(hex: 0xBCBAC1, alpha: 1)
        self.contentView.addSubview(lineView)

        
        self.editTextField.delegate = self;
        
        
        self.clTextView = CLTextView(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH))
        self.clTextView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    //MARK: -Public Method
    func showTextView() {
        self.editTextField.becomeFirstResponder()
    }
    
    func clearComment() {
        self.editTextField.text = ""
        
    }

    //MARK: - Event Response
    @IBAction func markAction(_ sender: Any) {
        self.delegate?.bottomViewDidMark(sender as! UIButton)
    }
    @IBAction func shareAction(_ sender: Any) {
        
         self.delegate?.bottomViewDidShare()
    }
    
   
    //MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.addSubview(self.clTextView!)
        
        let textlen = textField.text?.count as! Int
        if textlen > 4 {
            let string = NSMutableString.init(string: textField.text!)
            self.clTextView?.commentTextView.text = string.substring(from: 4)
        }
        
        self.clTextView?.commentTextView.becomeFirstResponder()
        UIApplication.shared.keyWindow?.addSubview(self.clTextView!)
        return false
    }
    
    
    
}
