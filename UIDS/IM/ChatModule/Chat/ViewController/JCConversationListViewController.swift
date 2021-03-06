//
//  JCConversationListViewController.swift
//  JChat
//
//  Created by deng on 2017/2/16.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit
import JMessage
import YHPopupView
import Reachability

class JCConversationListViewController: NaviBarVC {
    
    var datas: [JMSGConversation] = []
    var systemDatas: [IMGroupData] = []
    
    
    override func goBack(_ sender: Any!) {
        self.dismiss(animated: true) {
            
        }
    }
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        self.naviBar().setTitle("会话列表")
        self.navigationController?.navigationBar.isHidden = true
        request_groups()
        _init()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isConnecting {
            titleTips.text = "连接中"
            titleTipsView.isHidden = false
        } else {
            titleTipsView.isHidden = true
        }
        _getConversations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        titleTipsView.isHidden = true
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        JMessage.remove(self, with: nil)
    }
    
    fileprivate var isConnecting = false
    
    private lazy var addButton = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
    fileprivate lazy var tableview: UITableView = {
        var tableview = UITableView(frame: CGRect(x: 0, y: self.naviBar().bottom, width: self.view.width, height: self.view.height-self.naviBar().bottom))
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = UIColor(netHex: 0xe8edf3)
        tableview.register(JCConversationCell.self, forCellReuseIdentifier: "JCConversationCell")
        tableview.separatorStyle = .none
        return tableview
    }()
    fileprivate lazy var errorTips: JCNetworkTipsCell = JCNetworkTipsCell()
    fileprivate var showNetworkTips = false
    fileprivate lazy var emptyView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: self.naviBar().bottom, width: self.view.width, height: self.view.height - self.naviBar().bottom))
        view.isHidden = true
        view.backgroundColor = .white
        let tips = UILabel()
        tips.text = "暂无会话"
        tips.textColor = UIColor(netHex: 0x999999)
        tips.sizeToFit()
        tips.center = CGPoint(x: view.centerX, y: view.height / 2 - 60)
        view.addSubview(tips)
        return view
    }()
    
    fileprivate lazy var titleTips: UILabel = {
        var tips = UILabel(frame: CGRect(x: 23, y: 0, width: 67, height: 44))
        tips.font = UIFont.systemFont(ofSize: 18)
        tips.textColor = UIColor.white
        tips.textAlignment = .left
        tips.backgroundColor = UIColor(netHex: 0x5AD4D3)
        return tips
    }()

    fileprivate lazy var titleTipsView: UIView = {
        var view = UIView(frame: CGRect(x: self.view.width / 2 - 45, y: 20, width: 90, height: 44))
        view.backgroundColor =  UIColor(netHex: 0x5AD4D3)
        let activityView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 12, width: 20, height: 20))
        view.addSubview(activityView)
        activityView.startAnimating()
        view.addSubview(self.titleTips)
        view.isHidden = true
        return view
    }()
    
    //Mark: - private func
    private func _init() {
        view.backgroundColor = UIColor(netHex: 0xe8edf3)
        if #available(iOS 10.0, *) {
            navigationController?.tabBarItem.badgeColor = UIColor(netHex: 0xEB424C)
        }

        let appDelegate = UIApplication.shared.delegate
        let window = appDelegate?.window!
        window?.addSubview(titleTipsView)
        
        _setupNavigation()
        JMessage.add(self, with: nil)
        view.addSubview(tableview)
        view.addSubview(emptyView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: NSNotification.Name(rawValue: "kNetworkReachabilityChangedNotification"), object: nil)

        _getConversations()
        NotificationCenter.default.addObserver(self, selector: #selector(_getConversations), name: NSNotification.Name(rawValue: kUpdateConversation), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(connectClose), name: NSNotification.Name.jmsgNetworkDidClose, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(connectSucceed), name: NSNotification.Name.jmsgNetworkDidLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(connecting), name: NSNotification.Name.jmsgNetworkIsConnecting, object: nil)
    }
    
    @objc func reachabilityChanged(note: NSNotification) {
        if let curReach = note.object as? Reachability {
            let status = curReach.currentReachabilityStatus()
            switch status {
            case NetworkStatus.NotReachable:
                notReachable()
            default :
                reachable()
            }
        }
    }
    
    private func _setupNavigation() {
        addButton.addTarget(self, action: #selector(_clickNavRightButton(_:)), for: .touchUpInside)
        addButton.setImage(UIImage.loadImage("com_icon_add"), for: .normal)
        let item = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem =  item
    }
    
    func _updateBadge() {
        let count = datas.unreadCount
        if count > 99 {
            navigationController?.tabBarItem.badgeValue = "99+"
        } else {
            navigationController?.tabBarItem.badgeValue = count == 0 ? nil : "\(count)"
        }
    }
    
    @objc func _getConversations() {
        JMSGConversation.allConversations { (result, error) in
            guard let conversatios = result else {
                return
            }
            self.datas = conversatios as! [JMSGConversation]
            self.datas = self.sortConverstaions(self.datas)
            self.tableview.reloadData()
            if self.datas.count == 0 {
                self.emptyView.isHidden = true
            } else {
                self.emptyView.isHidden = true
            }
            self._updateBadge()
        }
    }

    fileprivate func sortConverstaions(_ convs: [JMSGConversation]) -> [JMSGConversation] {
        var stickyConvs: [JMSGConversation] = []
        var allConvs: [JMSGConversation] = []
        for index in 0..<convs.count {
            let conv = convs[index]
            if conv.ex.isSticky {
                stickyConvs.append(conv)
            } else {
                allConvs.append(conv)
            }
        }

        stickyConvs = stickyConvs.sorted(by: { (c1, c2) -> Bool in
            c1.ex.stickyTime > c2.ex.stickyTime
        })

        allConvs.insert(contentsOf: stickyConvs, at: 0)
        return allConvs
    }
    
    //MARK: - click func
    @objc func _clickNavRightButton(_ sender: UIButton) {
        _setupPopView()
    }
    
    private func _setupPopView() {
        presentPopupView(selectView)
    }
    
    fileprivate lazy var selectView: YHPopupView = {
        let popupView = MorePopupView(frame: CGRect(x: self.view.width - 150, y: 65, width: 145, height: 554 / 3))
        popupView.delegate = self
        return popupView
    }()
}

extension JCConversationListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.systemDatas.count > 0 {
            return 2
        }else {
            return 1
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.systemDatas.count > 0  && section == 0{
            return systemDatas.count
        }else {
            return showNetworkTips ? datas.count + 1 : datas.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.systemDatas.count > 0  && indexPath.section == 0{
            return tableView.dequeueReusableCell(withIdentifier: "JCConversationCell", for: indexPath)
        }else {
            if showNetworkTips && indexPath.row == 0 {
                errorTips.selectionStyle = .none
                return errorTips
            }
            return tableView.dequeueReusableCell(withIdentifier: "JCConversationCell", for: indexPath)

        }
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? JCConversationCell else {
            return
        }
        
        if self.systemDatas.count > 0  && indexPath.section == 0{
            cell.bindGroupConversation(self.systemDatas[indexPath.row])
        }else {
           cell.bindConversation(datas[showNetworkTips ? indexPath.row - 1 : indexPath.row])
        }
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.systemDatas.count > 0  && indexPath.section == 0{
            return 65
        }
        if showNetworkTips && indexPath.row == 0 {
            return 40
        }
        return 65
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.systemDatas.count > 0 {
            return 40
        }
        return 0
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.systemDatas.count > 0 && section == 0{
            return "系统群"
        }
        return "通讯列表"
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.systemDatas.count > 0  && indexPath.section == 0{
            
            MBProgressHUD_JChat.show(text: "申请加入中...", view: nil)
            
            let item = self.systemDatas[indexPath.row]
            
            let params = NSMutableDictionary()
            params.setValue(item.gid, forKey: "gid")
            params.setValue(item.appkey, forKey: "appkey")
            
            ApiUtil.share.applyGroup(params: params, finish: { (status, data, msg) in
                MBProgressHUD_JChat.hide(forView: nil, animated: true)
                if B_ResponseStatus.success == status {
                    
                }else {
                    MBProgressHUD_JChat.show(text: msg!, view: nil, 1)
                }
            })
            
        }else {
            if showNetworkTips && indexPath.row == 0 {
                return
            }
            let conversation = datas[showNetworkTips ? indexPath.row - 1 : indexPath.row]
            conversation.clearUnreadCount()
            guard let cell = tableView.cellForRow(at: indexPath) as? JCConversationCell else {
                return
            }
            cell.bindConversation(conversation)
            let vc = JCChatViewController(conversation: conversation)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.systemDatas.count > 0  && indexPath.section == 0{
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let action1 = UITableViewRowAction(style: .destructive, title: "删除") { (action, indexPath) in
            self._delete(indexPath)
        }
        let conversation = datas[showNetworkTips ? indexPath.row - 1 : indexPath.row]
        let action2 = UITableViewRowAction(style: .normal, title: "置顶") { (action, indexPath) in
            conversation.ex.isSticky = !conversation.ex.isSticky
            self._getConversations()
        }
        if conversation.ex.isSticky {
            action2.title = "取消置顶"
        } else {
            action2.title = "置顶"
        }
        return [action1, action2]
    }

    private func _delete(_ indexPath: IndexPath) {
        let conversation = datas[indexPath.row]
        let tager = conversation.target
        JCDraft.update(text: nil, conversation: conversation)
        if conversation.ex.isGroup {
            guard let group = tager as? JMSGGroup else {
                return
            }
            JMSGConversation.deleteGroupConversation(withGroupId: group.gid)
        } else {
            guard let user = tager as? JMSGUser else {
                return
            }
            JMSGConversation.deleteSingleConversation(withUsername: user.username, appKey: user.appKey!)
        }
        datas.remove(at: indexPath.row)
        if datas.count == 0 {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
        }
        tableview.reloadData()
    }
    
}

extension JCConversationListViewController: MorePopupViewDelegate {
    func popupView(view: MorePopupView, addGroup addButton: UIButton) {
        dismissPopupView()
        let vc = JCUpdateMemberViewController()
        vc.isAddMember = false
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func popupView(view: MorePopupView, addFriend addButton: UIButton) {
        dismissPopupView()
       
    }
    
    func popupView(view: MorePopupView, addSingle addButton: UIButton) {
        dismissPopupView()
        
    }
    
    func popupView(view: MorePopupView, scanQRCode addButton: UIButton) {
        dismissPopupView()
        let vc = ScanQRCodeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension JCConversationListViewController: JMessageDelegate {
    
    func onReceive(_ message: JMSGMessage!, error: Error!) {
        _getConversations()
    }
    
    func onConversationChanged(_ conversation: JMSGConversation!) {
        _getConversations()
    }
    
    func onGroupInfoChanged(_ group: JMSGGroup!) {
        _getConversations()
    }
    
    func onSyncRoamingMessageConversation(_ conversation: JMSGConversation!) {
        _getConversations()
    }
    
    func onSyncOfflineMessageConversation(_ conversation: JMSGConversation!, offlineMessages: [JMSGMessage]!) {
        _getConversations()
    }
    
    func onReceive(_ retractEvent: JMSGMessageRetractEvent!) {
        _getConversations()
    }
    
}

extension JCConversationListViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        tableview.isHidden = true
        emptyView.isHidden = true
        UIView.animate(withDuration: 0.35, animations: { 
            self.emptyView.frame = CGRect(x: 0, y: 64, width: self.view.width, height: self.view.height - 64)
        }) { (_) in
            self.navigationController?.tabBarController?.tabBar.isHidden = true
        }
    }
    func willDismissSearchController(_ searchController: UISearchController) {
        UIView.animate(withDuration: 0.35) {
            self.emptyView.frame = CGRect(x: 0, y: 64 + 36, width: self.view.width, height: self.view.height - 64 - 36)
        }
        tableview.isHidden = false
        if datas.count == 0 {
            emptyView.isHidden = false
        }
       
    }
}

// MARK: - network tips
extension JCConversationListViewController {
    
    func reachable() {
        if !showNetworkTips {
            return
        }
        showNetworkTips = false
        tableview.reloadData()
    }
    
    func notReachable() {
        if showNetworkTips {
            return
        }
        showNetworkTips = true
        if datas.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            tableview.beginUpdates()
            tableview.insertRows(at: [indexPath], with: .automatic)
            tableview.endUpdates()
        } else {
            tableview.reloadData()
        }
    }
    
    @objc func connectClose() {
        isConnecting = false
        titleTipsView.isHidden = true
    }
    
    @objc func connectSucceed() {
        isConnecting = false
        titleTipsView.isHidden = true
    }
    
    @objc func connecting() {
        _connectingSate()
    }
    
    func _connectingSate() {
        let window = UIApplication.shared.delegate?.window
        if window != nil {
            isConnecting = true
            titleTips.text = "连接中"
            titleTipsView.isHidden = false
        }
    }
}

extension JCConversationListViewController {
    
    fileprivate func request_groups(){
        
        MBProgressHUD_JChat.show(text: "获取系统群列表...", view: nil)
        
        ApiUtil.share.getGroups(params: NSMutableDictionary()) { [weak self] (status, data, msg) in
            
            MBProgressHUD_JChat.hide(forView: nil, animated: true)
            
            if B_ResponseStatus.success == status {
                let chatlist = IMGroupListModel.deserialize(from: data)?.data.groups
                self?.systemDatas = chatlist!
                self?.tableview.reloadData()
            }else {
                MBProgressHUD_JChat.show(text: msg!, view: nil, 1)
            }
        }
        
    }
    
}
