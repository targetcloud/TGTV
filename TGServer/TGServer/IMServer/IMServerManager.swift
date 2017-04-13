//
//  IMServerManager.swift
//  TGServer
//
//  Created by targetcloud on 2017/3/27.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import Cocoa

class IMServerManager: NSObject {
    fileprivate var tcpServer : TCPServer?
    /*
    fileprivate lazy var serverSocket : TCPServer = TCPServer(addr:"0.0.0.0",port: 9898)
    */
    fileprivate var isServerRunning : Bool = false
    fileprivate lazy var clientMgrs : [IMClientManager] = [IMClientManager]()//所有连接上服务器的客户端
}

/*
extension IMServerManager {
    func startRunning_() {
        isServerRunning = true
        serverSocket.listen()
        DispatchQueue.global().async {
            while self.isServerRunning{
                let tcpClient = self.serverSocket.accept()
                
                let lengthBytes = (tcpClient?.read(4))!
                let data = Data(bytes: lengthBytes, count: 4)
                var length : Int = 0
                (data as NSData).getBytes(&length, length: 4)
                
                //print(length)
                
                let dataBytes = (tcpClient?.read(length))!
                let resultStr = String(bytes: dataBytes, encoding: .utf8)
                
                print("长度 \(length) 内容 \(resultStr ?? "")")
                
            }
        }
    }
}
 */

extension IMServerManager {
    func startRunning(_ address : String, _ port : Int) {
        tcpServer = TCPServer(addr: address, port: port)
        tcpServer?.listen()
        isServerRunning = true
        DispatchQueue.global().async {
            while self.isServerRunning {
                if let client = self.tcpServer?.accept() {
                    DispatchQueue.global().async {
                        self.handleClient(client)
                    }
                }
            }
        }
    }
    
    func stopRunning() {
        isServerRunning = false
    }
    
    func handleClient(_ client : TCPClient) {
        let clientMgr = IMClientManager(tcpClient: client)
        clientMgrs.append(clientMgr)
        //clientMgr.delegate = self//MARK:- 代理使用 1 <成为代理>
        //IMServerManager(self)->clientMgrs->client->forwardMsgCallback->IMServerManager(self.clientMgrs)
        clientMgr.forwardMsgCallback = {[weak self] (client , msgData, isLeave ) in
            if isLeave {
                if let index = self?.clientMgrs.index(of: client){
                    client.tcpClient.close()
                    self?.clientMgrs.remove(at: index)//点客户端的离开房间会调用此句，离开消息不会回传给此客户端
                }
            }
            
            for c in (self?.clientMgrs ?? []) {
                c.sendMsg(msgData)
            }
        }
        
        clientMgr.removeClientCallback = {[weak self] (client) in
            print(" 客户端连接数由 \(self?.clientMgrs.count ?? 0) -> ")
            if let index = self?.clientMgrs.index(of: client){
                client.tcpClient.close()
                self?.clientMgrs.remove(at: index)//断开后客户端要做的处理
                print(" \(self?.clientMgrs.count ?? 0) ")
            }
        }
        
        clientMgr.startReadMsg()
    }
    
}


extension IMServerManager : IMClientManagerDelegate {//MARK:- 代理使用 2 <遵守>
    //MARK:- 代理使用 3 <实现代理方法>
    func removeClient(_ client: IMClientManager) {
        guard let index = clientMgrs.index(of: client) else { return }
        client.tcpClient.close()
        clientMgrs.remove(at: index)
    }
    
    func forwardMsg(_ client: IMClientManager, msgData: Data, isLeave: Bool) {
        if isLeave {
            /*
            if let index = clientMgrs.index(of: client) {
                client.tcpClient.close()
                clientMgrs.remove(at: index)
            }
            */
            removeClient(client)
        }
        
        for client in clientMgrs {
            client.sendMsg(msgData)
        }
    }
}
