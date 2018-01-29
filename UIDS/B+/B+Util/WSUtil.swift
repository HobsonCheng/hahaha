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
    func sendProtoObj(data: Data) {
        self.socket.write(data: data)
    }
    
    //断开链接
    func disconnect() {
        self.socket.disconnect()
    }
}

//open api
extension WSUtil {
    
    
    open func getLoginBuff() -> Data{
        var cLogin = ProtosBody_Login()
        let userinfo = UserUtil.share.appUserInfo
        cLogin.pid = Int32.init(truncatingBitPattern: (userinfo?.pid)!)
        cLogin.uid = Int32.init(truncatingBitPattern: (userinfo?.uid)!)
        cLogin.token = (userinfo?.Authorization)!
        
        return try!cLogin.serializedData(partial: true)
        
    }
    
    open func sendWSMsg(functype: ProtosBody_notice_funtion?,model: Any?) {
        
        var binary = Data()
        switch functype?.rawValue {
        case ProtosBody_notice_funtion.cregister.rawValue?:
            binary = self.getLoginBuff()
            break
        case ProtosBody_notice_funtion.sregister.rawValue?:
            
            break
        case ProtosBody_notice_funtion.snotice.rawValue?:
            
            break
        case ProtosBody_notice_funtion.cnotice.rawValue?:
            
            break
        case ProtosBody_notice_funtion.scancel.rawValue?:
            
            break
        case ProtosBody_notice_funtion.ccancel.rawValue?:
            
            break
        default:
            break
        }
    
        let headData = [0x1,0x2,0x3,0x4]
        let glData = [0x1]
        var funtionData = (self.intToBytes(value: (functype?.rawValue)!))
        var funtionLengthData = (self.intToBytes(value: (binary.count)))
        
        let sendData = headData+glData+funtionData+funtionLengthData+binary
        
        self.sendProtoObj(data: sendData)
    }
    
    func intToBytes(value: Int) -> [UInt8] {
        
        var bytes = [UInt8]()
        bytes.append((UInt8((value>>24) & 0xFF)))
        bytes.append(UInt8((value>>16) & 0xFF))
        bytes.append(UInt8((value>>8) & 0xFF))
        bytes.append(UInt8((value) & 0xFF))
        
        return bytes
    }
    func BytesToInt(bytes: [UInt8]) -> Int {
        
        var value: Int
        var offset = 0
        value = (((bytes[offset] & 0xFF)<<24)|((bytes[offset+1] & 0xFF)<<16)|((bytes[offset+2] & 0xFF)<<8)|(bytes[offset+3] & 0xFF))
        return value
    }
}

//socket 协议代理
extension WSUtil: WebSocketDelegate {
    
    //连接成功了
    func websocketDidConnect(socket: WebSocketClient) {
        print("成功链接")
        self.sendWSMsg(functype: ProtosBody_notice_funtion.cregister, model: nil)
        delegate?.websocketDidConnect(sock: self)
    }
    //连接失败了
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("断开链接")
//        delegate?.websocketDidDisconnect(socket: self, error: error! as NSError)
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
