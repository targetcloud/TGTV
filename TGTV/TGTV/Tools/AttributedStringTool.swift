//
//  AttributedStringTool.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/5.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit
import Kingfisher

class AttributedStringTool {
    class func generateJoinOrLeaveRoom(_ userName : String, _ isJoinRoom: Bool) -> NSAttributedString {
        let roomString = "\(userName) " + (isJoinRoom ? "进入房间 " : "离开房间 ")
        let mAttrStr = NSMutableAttributedString(string: roomString)
        mAttrStr.addAttributes([NSForegroundColorAttributeName: UIColor.orange], range: NSRange(location: 0, length: userName.characters.count))
        let attachment = NSTextAttachment()
        let font = UIFont.systemFont(ofSize: 15)
        attachment.bounds = CGRect(x: 0, y: -3, width: font.lineHeight, height: font.lineHeight)
        attachment.image = UIImage(named: "good9_30x30")
        let imageAttrStr = NSAttributedString(attachment: attachment)
        mAttrStr.append(imageAttrStr)
        return mAttrStr
    }
    
    class func generateTextMessage(_ userName: String, _ message: String) -> NSMutableAttributedString {
        let chatMessage = "\(userName): \(message)"
        let chatMsgMAttr = NSMutableAttributedString(string: chatMessage)
        chatMsgMAttr.addAttributes([NSForegroundColorAttributeName: UIColor.orange], range: NSRange(location: 0, length: userName.characters.count))
        let pattern = "\\[.*?\\]"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return chatMsgMAttr }
        let results = regex.matches(in: chatMessage, options: [], range: NSRange(location: 0, length: chatMessage.characters.count))
        for i in (0..<results.count).reversed() {
            let result = results[i]
            let emoticonName = (chatMessage as NSString).substring(with: result.range)
            guard let image = UIImage(named: emoticonName) else {
                continue
            }
            let attachment = NSTextAttachment()
            attachment.image = image
            let font = UIFont.systemFont(ofSize: 15)
            attachment.bounds = CGRect(x: 0, y: -3, width: font.lineHeight, height: font.lineHeight)
            let attributedStr = NSAttributedString(attachment: attachment)
            chatMsgMAttr.replaceCharacters(in: result.range, with: attributedStr)
        }
        return chatMsgMAttr
    }
    
    class func generateGiftMessge(_ userName: String, _ giftName: String, _ giftUrl: String) -> NSMutableAttributedString {
        let giftMsgStr = "\(userName) 赠送 \(giftName)"
        let sendGiftMAttrMsg = NSMutableAttributedString(string: giftMsgStr)
        sendGiftMAttrMsg.addAttributes([NSForegroundColorAttributeName: UIColor.orange], range: NSRange(location: 0, length: userName.characters.count))
        let range = (giftMsgStr as NSString).range(of: giftName)
        sendGiftMAttrMsg.addAttributes([NSForegroundColorAttributeName: UIColor.red], range: range)
        guard let image = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: giftUrl) else {
            return sendGiftMAttrMsg
        }
        let attacment = NSTextAttachment()
        attacment.image = image
        let font = UIFont.systemFont(ofSize: 15)
        attacment.bounds = CGRect(x: 0, y: -3, width: font.lineHeight, height: font.lineHeight)
        let imageAttrStr = NSAttributedString(attachment: attacment)
        sendGiftMAttrMsg.append(imageAttrStr)
        return sendGiftMAttrMsg
    }
    
}

