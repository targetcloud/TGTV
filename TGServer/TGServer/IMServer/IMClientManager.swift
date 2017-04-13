//
//  IMClientManager.swift
//  TGServer
//
//  Created by targetcloud on 2017/3/27.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import Cocoa

protocol IMClientManagerDelegate : class {//MARK:- 代理 1 <定义协议>
    func removeClient(_ client : IMClientManager)
    func forwardMsg(_ client : IMClientManager, msgData : Data, isLeave : Bool)
}

class IMClientManager: NSObject {
    weak var delegate : IMClientManagerDelegate?//MARK:- 代理 2 <定义属性>
    
    //MARK:- 1 也可以使用闭包解决方案来实现服务器消息转发
    var forwardMsgCallback : ((_ client : IMClientManager,_ data : Data,_ isLeave : Bool)->())?//var forwardMsgCallback : ((IMClientManager,Data,Bool)->())?
    var removeClientCallback : ((_ client : IMClientManager) -> ())?
    
    var tcpClient : TCPClient
    fileprivate var isClientRunning : Bool = false
    fileprivate var beatCounter : Int = 0
    fileprivate var queue : DispatchQueue?
    fileprivate var timer : Timer?
    
    init(tcpClient : TCPClient) {
        self.tcpClient = tcpClient
    }
}

extension IMClientManager {
    func startReadMsg() {
        isClientRunning = true
        queue = DispatchQueue.global()
        queue?.async {
            //timer放在最后面或者包在DispatchQueue.global().async{此处}
            self.timer = Timer(fireAt: Date(), interval: 1, target: self, selector: #selector(self.heartBeat), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timer!, forMode: RunLoopMode.commonModes)
            //timer.fire()
            RunLoop.current.run()
        }
        
          while self.isClientRunning {
            // 1.长度
            if let lengthBytes = self.tcpClient.read(4) {
                let lengthData = Data(bytes: lengthBytes, count: 4)
                var length : Int = 0
                (lengthData as NSData).getBytes(&length, length: 4)
                //print(length)
                
                // 2.类型
                guard let typeBytes = self.tcpClient.read(2) else {
                    continue
                }
                var type : Int = 0
                let typedata = Data(bytes: typeBytes, count: 2)
                (typedata as NSData).getBytes(&type, length: 2)
                //print(type)
                
                // 3.消息
                guard let dataBytes = self.tcpClient.read(length) else {
                    continue
                }
                let msgData = Data(bytes: dataBytes, count: length)
                
                /*
                let resultStr = String(bytes: dataBytes, encoding: .utf8)
                print(" --- 长度 \(length) 类型 \(type) 内容 \(resultStr ?? "") --- ")
                */
                
                //各种Data转proto，反序列化
                switch type {
                    case 0:
                        let userInfo = try! UserInfo.parseFrom(data : msgData)
                        print(length,type,userInfo.name, userInfo.level, userInfo.iconUrl)
                    case 1:
                        let user = try! UserInfo.parseFrom(data: msgData)
                        print(length,type,user.name, user.level, user.iconUrl)
                    case 2:
                        let chatMsg = try! ChatMessage.parseFrom(data: msgData)
                        print(length,type,chatMsg.user.name, chatMsg.user.level, chatMsg.user.iconUrl,chatMsg.text)
                    case 3:
                        let giftMsg = try! GiftMessage.parseFrom(data: msgData)
                        print(length,type,giftMsg.user.name, giftMsg.user.level, giftMsg.user.iconUrl,giftMsg.giftUrl, giftMsg.giftname, giftMsg.giftcount)
                    case 8:
                        print(" --- 心跳包 长度\(length), 类型 \(type) \(Thread.current)--- ")
                        queue?.async {
                            self.beatCounter = 0//有心跳包，计数器清0
                        }
                        //关键代码
                        continue//加这一句心跳包不需要转发给客户端
                    default:
                        print("其他")
                }
                
                // 4.消息转发出去
                self.delegate?.forwardMsg(self, msgData: lengthData + typedata + msgData, isLeave: type == 1)//MARK:- 代理 3 <使用代理>
                
                //MARK:- 2 闭包方案
                self.forwardMsgCallback?(self,lengthData + typedata + msgData,type == 1)
            } else {//当关闭客户端时会调用这里，不是离开房间，是断线
                self.isClientRunning = false
                //不离开房间，直接断线，那么也要移除此客户端
                self.removeClientCallback?(self)
                self.delegate?.removeClient(self)
                queue?.async {
                    self.timer?.invalidate()
                    self.timer = nil
                    self.queue = nil
                }
                print(" --- 客户端主动断开了连接 --- ")
            }
          }
    }
    
    func sendMsg(_ data : Data) {
        _ = tcpClient.send(data: data)
    }
}

extension IMClientManager {
    @objc fileprivate func heartBeat(){
        print(" --- server heartBeat \(beatCounter) \(Thread.current)--- ")
        beatCounter += 1
        if beatCounter>11{
            removeClientCallback?(self)
            self.delegate?.removeClient(self)
            
            //停止定时器
            timer?.invalidate()
            timer = nil
            queue = nil
        }
    }
}



