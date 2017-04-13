//
//  TGGiftContainerV.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/11.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGGiftContainerV: UIView {

    fileprivate lazy var channelVs : [TGGiftChannelV] = [TGGiftChannelV]()
    fileprivate lazy var cacheGiftMs : [TGGiftAnimationM] = [TGGiftAnimationM]()
    fileprivate var style : TGGiftStyle
    
    init(frame: CGRect,style:TGGiftStyle=TGGiftStyle()) {
        self.style = style
        super.init(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: style.ContainerH ))
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        self.backgroundColor = style.BGColor
        let w : CGFloat = frame.width
        let h : CGFloat = style.ChannelViewH
        let x : CGFloat = self.frame.width * (self.style.inDirection == .left ?  -1.0 : self.style.inDirection == .none ? 0 : 1.0)
        var y : CGFloat = 0
        for i in 0..<style.ChannelCount {
            y = (h + style.ChannelMargin) * CGFloat(i)
            let channelView = TGGiftChannelV.loadFromNib()
            channelView.frame = CGRect(x: x, y: y, width: w, height: h)
            channelView.alpha = 0.0
            channelView.style = self.style
            addSubview(channelView)
            channelVs.append(channelView)
            //闭包或代理方案，二选一
            channelView.delegate = self
            channelView.complectionCallback = {[unowned self] channelV in
                guard self.cacheGiftMs.count != 0 else {
                    return
                }
                let firstGiftM = self.cacheGiftMs.first!
                self.cacheGiftMs.removeFirst()
                channelV.giftM = firstGiftM
                for i in (0..<self.cacheGiftMs.count).reversed() {
                    if self.cacheGiftMs[i].isEqual(firstGiftM) {
                        channelV.addOnceGiftToCache()
                        self.cacheGiftMs.remove(at: i)
                    }
                }
            }
        }
    }

    func showGiftModel(_ giftModel : TGGiftAnimationM) {
        if let channelV = checkUsingChanel(giftModel) {
            channelV.addOnceGiftToCache()
            return
        }
        if let channelV = checkIdleChannel() {
            channelV.giftM = giftModel
            return
        }
        cacheGiftMs.append(giftModel)
        print(" --- 缓存\(giftModel.giftName)---")
    }
    
    private func checkUsingChanel(_ giftModel : TGGiftAnimationM) -> TGGiftChannelV? {
        return channelVs.filter({ giftModel.isEqual($0.giftM) && $0.state != .endAnimating && $0.state != .idle }).first
    }
    
    private func checkIdleChannel() -> TGGiftChannelV? {
        return channelVs.filter({ $0.state == .idle }).first
    }

}

extension TGGiftContainerV: TGGiftChannelViewDelegate {
    func giftAnimationDidCompletion(giftChannelView: TGGiftChannelV) {
        guard cacheGiftMs.count != 0 else {
            return
        }
        let firstGiftM = cacheGiftMs.first
        cacheGiftMs.removeFirst()
        giftChannelView.giftM = firstGiftM
        for i in (0..<cacheGiftMs.count).reversed() {
            if cacheGiftMs[i].isEqual(firstGiftM) {
                giftChannelView.addOnceGiftToCache()
                cacheGiftMs.remove(at: i)
            }
        }
    }
}
