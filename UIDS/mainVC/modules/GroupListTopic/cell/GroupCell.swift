//
//  GroupCell.swift
//  UIDS
//
//  Created by bai on 2018/1/20.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

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
    
    private func touchcell(){
        
        let getPage = OpenVC.share.getPageKey(pageType: PAGE_TYPE_news, actionType: "TopicList")
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
}
