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

    
    var cellObj: TopicData?{
        didSet{
            //更新点赞按钮状态
            self.zan.isSelected = cellObj?.praised == 1
        }
    }
    var cellButton: UIButton?
    
    @IBOutlet weak var imgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var showImgView: UIView!
    
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
        self.imgViewHeight.constant = 0.0
        self.icon.layer.cornerRadius = 20
        self.icon.layer.masksToBounds = true
        
        self.forward.setFAIcon(icon: FAType.FAMailForward, iconSize: 14, forState: UIControlState.normal)
        self.comment.setFAIcon(icon: FAType.FAComment, iconSize: 14, forState: UIControlState.normal)
        self.zan.setFAIcon(icon: FAType.FAThumbsOUp, iconSize: 14, forState: UIControlState.normal)
        self.zan.setFAIcon(icon: FAType.FAThumbsUp, forState: UIControlState.selected)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func showData() {
        if self.cellObj != nil {
            
            self.icon.sd_setImage(with: URL.init(string: self.cellObj?.user_info.head_portrait ?? "https://;;"), for: UIControlState.normal, completed: nil)
            self.username.text = self.cellObj?.user_info.zh_name
            self.addtime.text = self.cellObj?.add_time
            self.title.text = String.init(format: "来自：%@", (self.cellObj?.source)!)
            self.content.text = self.cellObj?.title
            
            if self.cellObj?.attachment_value.count != 0 {
                self.genderImgs()
            }
            
            self.addNewButton()
        }
    }
    
    private func genderImgs (){
        
        let imgs = self.cellObj?.attachment_value.components(separatedBy: ",")
        
        let rank = 3
        //每列间距
        let rankMargin = 5
        //每个Item宽高
        let W = (Int(kScreenW - 30) - (rank+1)*rankMargin)/rank
        let H = W
        //每行间距
        let rowMargin = 5
        
        var allHeight = 50.0
        
        var index = 0
        
        for item in imgs! {
        
            let startX = ((index)%rank) * (W + rankMargin)
            let startY = (index/rank) * (H + rowMargin)
            let top = 5
            
            let speedView = UIImageView.init()
            speedView.contentMode = UIViewContentMode.scaleToFill
            speedView.sd_setImage(with: URL.init(string: item))
            speedView.frame = CGRect.init(x: startX, y: startY+top, width: W, height: H)
            speedView.backgroundColor = UIColor.clear
            self.showImgView?.addSubview(speedView)
            
            let touchBt = UIButton().then{
                $0.frame = CGRect.init(x: speedView.left, y: speedView.top, width: speedView.width, height: speedView.height + 10)
                $0.backgroundColor = UIColor.clear
                $0.addTarget(self, action: #selector(Slider.touchItem(bt:)), for: .touchUpInside)
                $0.tag = index
            }
            self.showImgView?.addSubview(touchBt)
         
            index = index + 1
            
            allHeight = Double(speedView.bottom)
        }
     
        
        self.imgViewHeight.constant = CGFloat(allHeight)
        
        
    }
    
    func touchItem(bt: UIButton) {
        
    }
    
    private func touchcell(){
        
        let getPage = OpenVC.share.getPageKey(pageType: PAGE_TYPE_news, actionType: "content")
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
        })
        
        self.addSubview(cellButton!)
        
        
        cellButton?.snp.makeConstraints({ (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.forward.snp.top)
        })
    }
    
    
    //MARK: - action
    
    @IBAction func forwardAction(_ sender: Any) {
        let shareView = Bundle.main.loadNibNamed("ShareView", owner: nil, options: nil)?.last as! ShareView
        shareView.show()
    }
    
    @IBAction func commentAction(_ sender: Any) {
        touchcell()
    }
    
    @IBAction func zanAction(_ sender: UIButton) {
        //切换按钮状态
        sender.isSelected = sender.isSelected == true ? false : true
        //发送请求记录按钮状态
        let params = NSMutableDictionary()
        params.setValue(cellObj?.group_pid, forKey: "group_pid")
        params.setValue(cellObj?.id, forKey: "group_invitation_id")
        params.setValue(sender.isSelected, forKey: "praise")
        ApiUtil.share.cms_zan(params: params) { (status, data, msg) in
            if B_ResponseStatus.success == status{
                
            }else{
                Util.msg(msg: msg!, 3)
            }
        }
     
    }
}
