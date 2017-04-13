//
//  TGGiftChannelV.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/11.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit
import Kingfisher

enum TGGiftChannelState {
    case idle
    case animating
    case willEnd//waiting to end
    case endAnimating
}

protocol TGGiftChannelViewDelegate : class {
    func giftAnimationDidCompletion(giftChannelView: TGGiftChannelV)
}

class TGGiftChannelV: UIView,TGNibLoadable {

    weak var delegate: TGGiftChannelViewDelegate?
    
    @IBOutlet weak var bgV: UIView!
    @IBOutlet weak var iconImageV: UIImageView!
    @IBOutlet weak var senderLbl: UILabel!
    @IBOutlet weak var giftDescLbl: UILabel!
    @IBOutlet weak var giftImageV: UIImageView!
    @IBOutlet weak var digitLbl: TGGiftDigitLabel!
    
    var style : TGGiftStyle?
    fileprivate var cacheNumber : Int = 0
    fileprivate var currentNumber : Int = 0
    var state : TGGiftChannelState = .idle
    var complectionCallback : ((TGGiftChannelV) -> Void)?
    
    var giftM : TGGiftAnimationM? {
        didSet {
            guard let giftModel = giftM else {
                return
            }
            iconImageV.image = UIImage(named: giftModel.senderURL)
            senderLbl.text = giftModel.senderName
            giftDescLbl.text = "送出礼物：【\(giftModel.giftName)】"
            if let image = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: giftModel.giftURL){
                giftImageV.image = image
            }else{
                giftImageV.image = UIImage(named: giftModel.giftURL)
            }
            state = .animating
            performAnimation()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgV.layer.cornerRadius = frame.height * 0.5
        bgV.layer.masksToBounds = true
        
        iconImageV.layer.cornerRadius = frame.height * 0.5
        iconImageV.layer.masksToBounds = true
        iconImageV.layer.borderWidth = 1
        iconImageV.layer.borderColor = UIColor.clear.cgColor
    }
    
    func addOnceGiftToCache() {
        if state == .willEnd {
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            performDigitAnimation()
        } else if state == .animating {
            cacheNumber += 1
        } else{
            print("pls check")
        }
    }
    
//    class func loadFromNib() -> TGGiftChannelV {
//        return Bundle.main.loadNibNamed("TGGiftChannelV", owner: nil, options: nil)?.first as! TGGiftChannelV
//    }
    
    fileprivate func performAnimation() {
        state = .animating
        self.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1.0
            self.frame.origin.x = 0
        }, completion: { isFinished in
            self.digitLbl.alpha = 1.0
            //self.digitLbl.text = " x1 "
            self.performDigitAnimation()
        })
    }
    
    fileprivate func performDigitAnimation() {
        currentNumber += 1
        digitLbl.text = " x\(currentNumber) "
        self.transform = CGAffineTransform.identity
        self.alpha = 1.0
        digitLbl.showDigitAnimation {
            if self.cacheNumber > 0 {
                self.cacheNumber -= 1
                self.performDigitAnimation()
            } else {
                self.state = .willEnd
                self.perform(#selector(self.performEndAnimation), with: nil, afterDelay: 3.0)
            }
        }
    }
    
    @objc fileprivate func performEndAnimation() {
        state = .endAnimating
        if style!.isNeedFadeOutEffect{
            UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1, animations: {
                    self.alpha = 0.6
                })
                UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.9, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    self.frame.origin.x = UIScreen.main.bounds.width * (self.style!.outDirection == .left ?  -1.0 : self.style!.outDirection == .none ? 0 : 1.0)
                    self.alpha = 0.3
                })
            }, completion: { isFinished in
                self.giftM = nil
                self.transform = CGAffineTransform.identity
                self.frame.origin.x = UIScreen.main.bounds.width * (self.style!.inDirection == .left ?  -1.0 : self.style!.inDirection == .none ? 0 : 1.0)
                self.alpha = 0.0
                self.currentNumber = 0
                self.cacheNumber = 0
                self.state = .idle
                self.digitLbl.alpha = 0.0
                self.digitLbl.text = nil
                self.complectionCallback?(self)
            })
        }else{
            UIView.animate(withDuration: 0.5, animations: {
                self.frame.origin.x = self.frame.width * (self.style!.outDirection == .left ?  -1.0 : self.style!.outDirection == .none ? 0 : 1.0)
                self.alpha = 0.0
            }) { isFinished in
                self.state = .idle
                self.currentNumber = 0
                self.cacheNumber = 0
                self.giftM = nil
                self.frame.origin.x = self.frame.width * (self.style!.inDirection == .left ?  -1.0 : self.style!.inDirection == .none ? 0 : 1.0)
                self.digitLbl.alpha = 0.0
                self.digitLbl.text = nil
                //闭包或代理二选一
                self.complectionCallback?(self)
                self.delegate?.giftAnimationDidCompletion(giftChannelView: self)
            }
        }
    }

}
