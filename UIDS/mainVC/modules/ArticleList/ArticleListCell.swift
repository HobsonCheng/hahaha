//
//  ArticleListCell.swift
//  UIDS
//
//  Created by one2much on 2018/1/15.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import NSObject_Rx

class ArticleListCell: UITableViewCell {

    
    var cellObj: TopicData?
    var cellButton: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addNewButton()
    }
    
    private func touchcell(){
        
        let getPage = OpenVC.share.getPageKey(pageType: PAGE_TYPE_news, actionType: "content")
        getPage?.anyObj = self.cellObj
        
        OpenVC.share.goToPage(pageType: (getPage?.page_type)!, pageInfo: getPage)
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
