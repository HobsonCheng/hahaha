//
//  WSUtil.swift
//  UIDS
//
//  Created by one2much on 2018/1/25.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import Starscream

protocol WSUtilDelegate {
    
    /**websocket 连接成功*/
    func websocketDidConnect(sock: WSUtil)
    /**websocket 连接失败*/
    func websocketDidDisconnect(socket: WSUtil, error: NSError?)
    /**websocket 接受文字信息*/
    func websocketDidReceiveMessage(socket: WSUtil, text: String)
    /**websocket 接受二进制信息*/
    func  websocketDidReceiveData(socket: WSUtil, data: NSData)
    
}


class WSUtil: NSObject {

    var delegate: WSUtilDelegate?
    
    private var socket: WebSocket!
    //MARK: - 单利创建
    static let manger: WSUtil = {
        return WSUtil()
    }()
    
    class func share() -> WSUtil {
        return manger
    }
    
    let wsUrl = "ws://121.42.154.36:12131/socket"
    
    //创建链接
    func connectSever() {
        
        self.socket = WebSocket(url: URL(string: wsUrl)!)
        socket.delegate = self
        socket.connect()
    }
    
    //发送信息
    func sendProtoObj() {
        self.socket.write(string: "")
    }
    
    //断开链接
    func disconnect() {
        self.socket.disconnect()
    }
}

//socket 协议代理
extension WSUtil: WebSocketDelegate {
    
    //连接成功了
    func websocketDidConnect(socket: WebSocketClient) {
        print("成功链接")
        delegate?.websocketDidConnect(sock: self)
    }
    //连接失败了
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("断开链接")
        delegate?.websocketDidDisconnect(socket: self, error: error as? NSError)
    }
    
    //接受到消息了
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("我收到了消息(string)\(text)")
        delegate?.websocketDidReceiveMessage(socket: self, text: text)
    }
    //data数据
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("我收到了消息(data)\(data)")
        delegate?.websocketDidReceiveData(socket: self, data: data as NSData)
    }

}
