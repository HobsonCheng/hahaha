//
//  AppSearchNavVC.swift
//  UIDS
//
//  Created by bai on 2018/2/1.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import Then
import RxGesture
import ReusableKit
import RxDataSources
import Differentiator
import SwiftyJSON
import ESPullToRefresh
import DZNEmptyDataSet



private enum HistoryKey {
    
    static let HistoryKey_Phone = "HistoryKey_Phone"
    
}

// MARK:- 复用
private enum Reusable {
    
    static let searchCell = ReusableCell<SearchVCell>(nibName: "SearchVCell")
}



protocol AppSearchVCDelectege {
    
    //搜索结束
    func SearchpidEnd(pidObj: Any?)
    
}

class AppSearchNavVC: NaviBarVC {

    var delegate: AppSearchVCDelectege?
    
    
    
    // DataSuorce
    var dataSource : RxTableViewSectionedReloadDataSource<SectionModel<String, Project>>!
    
    var page: Int?
    
    var searchKey: String?
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var tableview: UITableView!

    
    // viewModel
    fileprivate var viewModel: SearchResultViewModel!

    var historylist: [Project]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.page = 1
        
        let searchField: UITextField = self.searchbar.value(forKey: "searchField") as! UITextField
        
        viewModel = SearchResultViewModel(searchBar: searchField)
        viewModel.searchUseable.do(onNext: { [weak self] (key) in
            
            if key.isEmpty {
                
                self?.showHistoy()
                
                return
            }
            
            if self?.searchKey == key {
                return
            }
            self?.searchKey = key
            self?.getData(loadMode: false)
            
        }).drive(searchField.rx.value).disposed(by: rx.disposeBag);
        
        
        self.genderUI()
        
        self.refreshUI()
        
        //历史数据
        
        self.showHistoy()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
}


//MARK: - 刷新植入
extension AppSearchNavVC {
    
    func refreshUI() {
        
        //上拉  下拉
        var header: ESRefreshProtocol & ESRefreshAnimatorProtocol
        var footer: ESRefreshProtocol & ESRefreshAnimatorProtocol
        
        header = DS2RefreshHeader.init(frame: CGRect.zero)
        footer = DS2RefreshFooter.init(frame: CGRect.zero)
        
        self.tableview?.es.addPullToRefresh(animator: header) { [weak self] in
            self?.refreshEvent()
        }
        self.tableview?.es.addInfiniteScrolling(animator: footer) { [weak self] in
            self?.loadMore()
        }
    }
    
    func getData(loadMode: Bool) {
        
        let params = NSMutableDictionary()
        params.setValue(self.page, forKey: "page")
        params.setValue(self.searchKey, forKey: "key")
        params.setValue("20", forKey: "page_context")
        
        viewModel.getSearchEnd(loadMode: loadMode,params: params, callback: { [weak self] (noMove) in
            self?.tableview.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
            self?.tableview.es.stopPullToRefresh()
            self?.tableview.es.stopLoadingMore()
            
            if noMove {
                self?.tableview.es.noticeNoMoreData()
            }
        })
    }
    
    func refreshEvent() {
        
        if self.searchKey == nil || self.searchKey?.count == 0 {
            
            self.tableview.es.stopPullToRefresh()
            
            return
        }
        
        self.page = 1
        self.getData(loadMode: false)
        
    }
    private func loadMore() {
        
        if self.searchKey == nil || self.searchKey?.count == 0 {
            
            self.tableview.es.stopLoadingMore()
            
            return
        }
        
        self.page = 1
        self.getData(loadMode: true)
    }
    
}

//gender ui
extension AppSearchNavVC {
    
    fileprivate func genderUI() {
        
        
        self.noButton.layer.cornerRadius = 8
        self.noButton.layer.masksToBounds = true
        
        self.tableview.tableFooterView = UIView()
        
    

        let searchField: UITextField = self.searchbar.value(forKey: "searchField") as! UITextField
        searchField.layer.cornerRadius = 8
        searchField.layer.borderColor = UIColor(hexString: "#1e71eb", withAlpha: 1).cgColor
        searchField.layer.borderWidth = 1
        searchField.layer.masksToBounds = true
    
        
        for subview in self.searchbar.subviews {
            for grandSonView in subview.subviews{
                if grandSonView.isKind(of: NSClassFromString("UISearchBarBackground")!) {
                    grandSonView.alpha = 0.0
                    break
                }
            }//for cacheViews
        }//subviews
        
    
        self.searchbar.rx.searchButtonClicked.asObservable().do(onNext: { [weak self] in
            self?.view.endEditing(true)
        }).subscribe().disposed(by: rx.disposeBag)
        
        self.tableview.emptyDataSetSource = self
        self.tableview.emptyDataSetDelegate = self
        
        
        // 设置代理
        
        tableview.rx.setDelegate(self).disposed(by: rx.disposeBag)
        
        // 注册cell
        tableview.register(Reusable.searchCell)
    
        
        self.bindUI()
    }
    
    
    // MARK:- 绑定视图
    func bindUI() {
        
        self.dataSource = RxTableViewSectionedReloadDataSource(configureCell: { (ds, tv, indexPath, item) -> UITableViewCell in
            
            // 注册cell
            let cell = tv.dequeue(Reusable.searchCell,for: indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.searchKey = self.searchKey
            cell.objData = item
            return cell
        })
        
        viewModel.searchList.asObservable().bind(to: self.tableview.rx.items(dataSource: (self.dataSource)!)).disposed(by: rx.disposeBag)

    }
}

// MARK:- UITableViewDelegate
extension AppSearchNavVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 133
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        self.view.endEditing(true)
        
        let itemData = viewModel.searchList.value[indexPath.section].items[indexPath.row]
        
        self.saveItem(parj: itemData)
        
        let assemble = AssembleVC(nibName: "AssembleVC", bundle: nil)
        assemble.pObj = itemData
        VCController.push(assemble, with: VCAnimationClassic.defaultAnimation())
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

extension AppSearchNavVC: DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    
        var text = "没有搜索到你的公司😭"
        if self.searchKey == nil || self.searchKey?.count == 0 {
            text = "搜索一个公司试一下🙂"
        }
    
        let font = UIFont.systemFont(ofSize: 26)
        let textColor = UIColor.black
        
        let attributes = NSMutableDictionary()
        
        attributes.setObject(textColor, forKey: NSForegroundColorAttributeName as NSCopying)
        attributes.setObject(font, forKey: NSFontAttributeName as NSCopying)
        
        return NSAttributedString.init(string: text, attributes: attributes  as? [String : Any])
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let text = "点击⤵️按钮，进行创建属于您的单位App\n😏😏😏"
        
        let textColor = UIColor.black
        let attributes = NSMutableDictionary()
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraph.alignment = NSTextAlignment.center
        paragraph.lineSpacing = 2.0
        
        attributes.setObject(textColor, forKey: NSForegroundColorAttributeName as NSCopying)
        attributes.setObject(paragraph, forKey: NSParagraphStyleAttributeName as NSCopying)
        
        
        return NSMutableAttributedString.init(string: text, attributes: attributes as? [String : Any])
        
    }
    
//    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
//
//        return UIImage.init(named: "empty_placeholder.png")
//    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.clear
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        return nil
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 0
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return false
    }
    
}
//历史数据  读存
extension AppSearchNavVC {
    
    func saveItem(parj: Project) {
        
        ZZDiskCacheHelper.getObj(HistoryKey.HistoryKey_Phone) {[weak self] (obj) in
            
            if obj != nil {
                let tmpobj: String = obj as! String
                
                var getObj = ProjectList.deserialize(from: tmpobj) ?? ProjectList(data: [Project]())
                
                if getObj.data.count == 0 {
                    getObj.data.append(parj)
                    ZZDiskCacheHelper.saveObj(HistoryKey.HistoryKey_Phone, value: getObj.toJSONString())
                }else {
                    var count = 0
                    for item in getObj.data {
                        
                        if item.pid == parj.pid {
                            getObj.data.remove(at: count)
                            break
                        }
                        count = count + 1
                    }
                    getObj.data.insert(parj, at: 0)
                    
                    let section = [SectionModel(model: "", items: getObj.data!)]
                    
                    self?.viewModel.searchList.value = section
                    
                    ZZDiskCacheHelper.saveObj(HistoryKey.HistoryKey_Phone, value: getObj.toJSONString())
                }
            }else {
                var getObj = ProjectList(data: [Project]())
                
                if getObj.data.count == 0 {
                    getObj.data.append(parj)
                    
                    let section = [SectionModel(model: "", items: getObj.data!)]
                    
                    self?.viewModel.searchList.value = section
                    
                    ZZDiskCacheHelper.saveObj(HistoryKey.HistoryKey_Phone, value: getObj.toJSONString())
                }
            }
        }
    }
    func showHistoy() {
        
        ZZDiskCacheHelper.getObj(HistoryKey.HistoryKey_Phone) { [weak self] (obj) in
            
            if obj != nil {
                let tmpobj: String = obj as! String
                
                let getObj = ProjectList.deserialize(from: tmpobj) ?? ProjectList(data: [Project]())
                
                let section = [SectionModel(model: "", items: getObj.data!)]
                
                self?.viewModel.searchList.value = section
            }
        }
        
        
        
    }
}
