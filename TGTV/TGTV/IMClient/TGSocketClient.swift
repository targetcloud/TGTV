//
//  TGSocketClient.swift
//  TGClient
//
//  Created by targetcloud on 2017/3/27.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

enum MsgType : Int {
    case join = 0
    case leave = 1
    case text = 2
    case gift = 3
    case heartBeat = 8
}

protocol TGSocketClientDelegate : class {//传递的事件比较多或各种情况分别处理时一般用代理设计模式
    func socket(_ socket : TGSocketClient,joinRoom userInfo :UserInfo)
    func socket(_ socket : TGSocketClient,leaveRoom userInfo :UserInfo)
    func socket(_ socket : TGSocketClient,sendChatMsg chatMsg :ChatMessage)
    func socket(_ socket : TGSocketClient,sendGift giftMsg :GiftMessage)
}

class TGSocketClient {
    weak var delegate : TGSocketClientDelegate?
    
    fileprivate var tcpClient : TCPClient
    fileprivate var isConnected : Bool = false
    fileprivate var heartBeatTimer: Timer?
    
    fileprivate lazy var user : UserInfo.Builder = {
        let user = UserInfo.Builder()
        user.level = Int32(arc4random_uniform(24))
        user.name = "targetcloud\(arc4random_uniform(10))"
        user.iconUrl = "icon\(arc4random_uniform(4))"
        return user
    }()
    
    init(address:String , prot : Int){
        tcpClient = TCPClient(addr: address, port: prot)
    }
    
    deinit {
        heartBeatTimer?.invalidate()
        heartBeatTimer = nil
    }
}

extension TGSocketClient{
    func connectServer(_ timeout : Int) -> Bool {
        isConnected = tcpClient.connect(timeout: timeout).0
        if isConnected {
            startReadMsg()
            heartBeatTimer = Timer(fire: Date(), interval: 10, repeats: true, block: { (timer:Timer) in
                self.sendHeartBeats()
            })
            RunLoop.main.add(heartBeatTimer!, forMode: .commonModes)
        }
        return isConnected
    }
    
    fileprivate func sendHeartBeats(){
        let heartMsg = "this is a heartBeat message "
        sendMsg(MsgType.heartBeat.rawValue, msgData: heartMsg.data(using: .utf8)!)
    }
    
    func startReadMsg() {//一直读消息，读到后由代理处理
        DispatchQueue.global().async {//TCPClient.read是阻塞式的，应该放在全局中去执行
            while self.isConnected {
                if let lengthMsg = self.tcpClient.read(4) {
                    let lData = Data(bytes: lengthMsg, count: 4)
                    var length : Int = 0
                    (lData as NSData).getBytes(&length, length: 4)
                    
                    guard let typeMsg = self.tcpClient.read(2) else {
                        continue
                    }
                    var type : Int = 0
                    let tdata = Data(bytes: typeMsg, count: 2)
                    (tdata as NSData).getBytes(&type, length: 2)
                    
        
                    guard let msg = self.tcpClient.read(length) else {
                        continue
                    }
                    let msgData = Data(bytes: msg, count: length)
                    
                    DispatchQueue.main.async {//UI处理放main处理（由delegate中转）
                        self.handleMsg(type, msgData: msgData)
                    }
                }else{
                    print("有情况,可能服务器当了")
                    break//continue
                }
            }
        }
    }
    
    fileprivate func handleMsg(_ type : Int, msgData : Data) {//读到后由代理处理
        switch type {
        case MsgType.join.rawValue:
            let user = try! UserInfo.parseFrom(data: msgData)//反序列化成对象
            print(user.name, user.level, user.iconUrl)
            delegate?.socket(self, joinRoom: user)//返回给VC（控制器）显示等
        case MsgType.leave.rawValue:
            let user = try! UserInfo.parseFrom(data: msgData)
            print(user.name, user.level, user.iconUrl)
            delegate?.socket(self, leaveRoom: user)
        case MsgType.text.rawValue:
            let chatMsg = try! ChatMessage.parseFrom(data: msgData)
            print(chatMsg.user.name, chatMsg.user.level, chatMsg.user.iconUrl,chatMsg.text)
            delegate?.socket(self, sendChatMsg: chatMsg)
        case MsgType.gift.rawValue:
            let giftMsg = try! GiftMessage.parseFrom(data: msgData)
            print(giftMsg.user.name, giftMsg.user.level, giftMsg.user.iconUrl,giftMsg.giftUrl, giftMsg.giftname, giftMsg.giftcount)
            delegate?.socket(self, sendGift: giftMsg)
        case MsgType.heartBeat.rawValue:
            print("心跳包")
        default:
            print("其他类型消息")
        }
    }
}

extension TGSocketClient{//序列化Data发送
    func sendJoinMsg() {
        /*
        let data = (try! user.build()).data()
        */
        guard let user =  try? user.build() else {
            return
        }
        let data = user.data()
        sendMsg(MsgType.join.rawValue, msgData: data)
    }
    
    func sendLeaveMsg() {
        let data = (try! user.build()).data()
        sendMsg(MsgType.leave.rawValue, msgData: data)
    }
    
    func sendTextMsg(_ text : String) {
        let chatMsg = ChatMessage.Builder()
        chatMsg.text = text
        chatMsg.user = try! user.build()
        
        let chatData = (try! chatMsg.build()).data()
        sendMsg(MsgType.text.rawValue, msgData: chatData)
    }
    
    func sendGiftMsg(_ giftname : String, _ giftURL : String, _ giftcount : Int) {
        let giftMsg = GiftMessage.Builder()
        giftMsg.giftname = giftname
        giftMsg.giftUrl = giftURL
        giftMsg.giftcount = Int32(giftcount)
        giftMsg.user = try! user.build()
        
        let giftData = (try! giftMsg.build()).data()
        sendMsg(MsgType.gift.rawValue, msgData: giftData)
    }
    
    fileprivate func sendMsg(_ type : Int , msgData :Data)  {//发送的消息处理后由tcpClient : TCPClient 正式发送
        var length = msgData.count
        let lengthData = Data(bytes: &length, count: 4)
        
        var type = type
        let typeData = Data(bytes: &type, count: 2)
        
        tcpClient.send(data: lengthData + typeData + msgData)
    }
}
