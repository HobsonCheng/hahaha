//
//  TopicCell.swift
//  UIDS
//
//  Created by bai on 2018/1/21.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

class TopicCell: UITableViewCell {

    
    var cellObj: TopicData?
    var cellButton: UIButton?
    
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var zan: UIButton!
    @IBOutlet weak var comment: UIButton!
    @IBOutlet weak var forward: UIButton!
    @IBOutlet weak var icon: UIButton!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var addtime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.white
        
        self.icon.layer.cornerRadius = 20
        self.icon.layer.masksToBounds = true
        
        self.forward.setFAIcon(icon: FAType.FAMailForward, iconSize: 14, forState: UIControlState.normal)
        self.comment.setFAIcon(icon: FAType.FAComment, iconSize: 14, forState: UIControlState.normal)
        self.zan.setFAIcon(icon: FAType.FAThumbsOUp, iconSize: 14, forState: UIControlState.normal)
        
        self.addNewButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func showData() {
        if self.cellObj != nil {
            
            self.username.text = self.cellObj?.user_info.nick_name
            self.addtime.text = self.cellObj?.add_time
            self.title.text = String.init(format: "来自：%@", (self.cellObj?.source)!)
            self.content.text = self.cellObj?.title
            
        }
    }
    
    private func touchcell(){
        
        let getPage = OpenVC.share.getPageKey(pageType: PAGE_TYPE_TopicList, actionType: PAGE_TYPE_news)
        getPage?.anyObj = self.cellObj
        if (getPage != nil) {
            OpenVC.share.goToPage(pageType: (getPage?.page_type)!, pageInfo: getPage)
        }
    }
    
    private func addNewButton() {
        
        cellButton = UIButton().then({
            $0.backgroundColor = UIColor.clear
            $0.rx.tap.do(onNext: { [weak self] _ in
                self?.touchcell()
            }).subscribe().disposed(by: rx.disposeBag)
            $0.frame = CGRect.init(x: 0, y: 0, width: self.width, height: self.height)
        })
        
        self.addSubview(cellButton!)
    }
    
    
    //MARK: - action
    
    @IBAction func forwardAction(_ sender: Any) {
    }
    
    @IBAction func commentAction(_ sender: Any) {
        
        
    }
    @IBAction func zanAction(_ sender: Any) {
        
        
    }
    
}
