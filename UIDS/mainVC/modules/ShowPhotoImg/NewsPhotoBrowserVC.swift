//
//  NewsPhotoBrowserVC.swift
//  UIDS
//
//  Created by one2much on 2018/1/24.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class NewsPhotoBrowserVC: BaseNameVC {

    // MARK: - 属性
    /// 文章详情请求参数
    var photoParam : (allphoto: [String], index: Int)? {
        didSet {
            // 文章配图模型数组
            photoModels = photoParam!.allphoto
            
            self.scrollViewDidEndDecelerating(self.collectionView)
            self.collectionView.reloadData()
            
            // 滚动到指定的index
            collectionView.scrollToItem(at: IndexPath(row: photoParam!.index, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
            
            bottomTitleLabel.text = "\(photoParam!.index + 1)/\(photoModels.count) \("白鸽到此一游")"
            currentIndex = photoParam!.index
        }
    }
    
    // 文章配图模型数组
    fileprivate var photoModels = [String]()
    
    /// 当前图片脚标
    var currentIndex = 0
    
    // 导航栏/背景颜色
    fileprivate let bgColor = UIColor(red:0.110,  green:0.102,  blue:0.110, alpha:0.9)
    
    fileprivate let photoIdentifier = "photoDetail"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    /**
     滚动停止后调用，更新底部工具条文字
     */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let page = Int(scrollView.contentOffset.x / kScreenW)
        bottomTitleLabel.text = "\(page + 1)/\(photoModels.count) \("白鸽到此粮油是的撒多撒")"
    }
    
    /**
     保存图片到相册
     */
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if let _ = error {
            Util.msg(msg: "保存失败", 3)
        } else {
            Util.msg(msg: "保存ok", 2)
        }
    }
    
    /**
     点击了保存按钮
     */
    @objc fileprivate func didTappedSaveButton(_ button: UIButton) {
        
//        let imageURL = photoModels[currentIndex].url!
        
        
    }
    
    /**
     准备UI
     */
    @objc fileprivate func prepareUI() {
        
        view.backgroundColor = UIColor(red:0.110,  green:0.102,  blue:0.110, alpha:1)
        automaticallyAdjustsScrollViewInsets = false
        
        view.addSubview(collectionView)
        view.addSubview(bottomToolView)
        bottomToolView.addSubview(bottomTitleLabel)
        bottomToolView.addSubview(bottomSaveButton)
        
        bottomToolView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(60)
        }
        
        bottomTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.width.equalTo(kScreenW - 50)
        }
        
        bottomSaveButton.snp.makeConstraints { (make) in
            make.top.equalTo(7.5)
            make.right.equalTo(-10)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        
        // 更新底部工具条高度
        view.layoutIfNeeded()
        bottomToolView.snp.updateConstraints { (make) in
            make.height.equalTo(bottomTitleLabel.height + 20)
        }
        
    }
    
    // MARK: - 懒加载
    /// 内容视图
    fileprivate lazy var collectionView: UICollectionView = {
        let myLayout = UICollectionViewFlowLayout()
        myLayout.itemSize = CGSize(width: kScreenW + 10, height: kScreenH)
        myLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        myLayout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kScreenW + 10, height: kScreenH), collectionViewLayout: myLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor(red:0.110,  green:0.102,  blue:0.110, alpha:1)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(JFPhotoDetailCell.self, forCellWithReuseIdentifier: self.photoIdentifier)
        return collectionView
    }()
    
    /// 底部工具条
    fileprivate lazy var bottomToolView: UIView = {
        let bottomToolView = UIView()
        bottomToolView.backgroundColor = self.bgColor
        return bottomToolView
    }()
    
    /// 底部工具栏显示页码
    fileprivate lazy var bottomTitleLabel: UILabel = {
        let bottomTitleLabel = UILabel()
        bottomTitleLabel.numberOfLines = 0
        bottomTitleLabel.textColor = UIColor(red:0.945,  green:0.945,  blue:0.945, alpha:1)
        bottomTitleLabel.font = UIFont.systemFont(ofSize: 15)
        return bottomTitleLabel
    }()
    
    fileprivate lazy var bottomSaveButton: UIButton = {
        let bottomSaveButton = UIButton()
        bottomSaveButton.setImage(UIImage(named: "bottom_bar_save_normal"), for: UIControlState())
        bottomSaveButton.addTarget(self, action: #selector(didTappedSaveButton(_:)), for: UIControlEvents.touchUpInside)
        return bottomSaveButton
    }()

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension NewsPhotoBrowserVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoIdentifier, for: indexPath) as! JFPhotoDetailCell
        cell.delegate = self
        cell.urlString = photoModels[indexPath.item]
        return cell
    }
}

// MARK: - JFPhotoDetailCellDelegate
extension NewsPhotoBrowserVC: JFPhotoDetailCellDelegate {
    
    /**
     单击事件退出
     */
    func didOneTappedPhotoDetailView(_ scrollView: UIScrollView) -> Void {
        dismiss(animated: true) {}
        
        VCController.pop(with: VCAnimationBottom.defaultAnimation())
        
    }
    
    /**
     双击事件放大
     */
    func didDoubleTappedPhotoDetailView(_ scrollView: UIScrollView, touchPoint: CGPoint) -> Void {
        if scrollView.zoomScale <= 1.0 {
            let scaleX = touchPoint.x + scrollView.contentOffset.x
            let scaleY = touchPoint.y + scrollView.contentOffset.y
            scrollView.zoom(to: CGRect(x: scaleX, y: scaleY, width: 10, height: 10), animated: true)
        } else {
            scrollView.setZoomScale(1.0, animated: true)
        }
    }
    
    /**
     长按保存图片
     */
    func didLongPressPhotoDetailView(_ scrollView: UIScrollView, currentImage: UIImage?) {
    }
}

