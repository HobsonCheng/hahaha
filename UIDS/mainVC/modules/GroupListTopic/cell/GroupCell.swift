//
//  GroupCell.swift
//  UIDS
//
//  Created by bai on 2018/1/20.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import Font_Awesome_Swift


class GroupCell: UITableViewCell {

    
    @IBOutlet weak var topicNum: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var groupName: UILabel!
    
    @IBOutlet weak var creatTime: UILabel!
    var cellObj: GroupData?
    var cellButton: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.white
        
        self.addNewButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showData() {
        if self.cellObj != nil {
            
            self.icon.setFAIconWithName(icon: FAType.FAGroup, textColor: UIColor.black)
            self.icon.setFAIconWithName(icon: FAType.FAGroup, textColor: UIColor.black, orientation: UIImageOrientation.up, backgroundColor: UIColor.white, size: CGSize.init(width: self.icon.width, height: self.icon.height))
            self.icon.layer.cornerRadius = 4
            self.icon.layer.masksToBounds = true
            self.icon.layer.borderColor = UIColor.lightGray.cgColor
            self.icon.layer.borderWidth = 0.5
            self.groupName.text = self.cellObj?.name
            self.creatTime.text = String.init(format: "创建时间：%@", (self.cellObj?.add_time)!)
            self.topicNum.text = String.init(format: "帖子%zd", (self.cellObj?.invitation_num ?? 0)!)
            
        }
    }
    
    private func touchcell(){
        
        let getPage = OpenVC.share.getPageKey(pageType: PAGE_TYPE_TopicList, actionType: PAGE_TYPE_TopicList)
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
            $0.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: self.height)
        })
        
        self.addSubview(cellButton!)
    }
}
