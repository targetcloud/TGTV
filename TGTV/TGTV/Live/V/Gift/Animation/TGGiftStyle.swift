//
//  TGGiftStyle.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/11.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

enum TGChannelDirection {
    case left
    case right
    case none
}

class TGGiftStyle: NSObject {
    var ChannelCount = 3
    var ChannelViewH : CGFloat = 40
    var ChannelMargin : CGFloat = 10
    var BGColor = UIColor.lightGray
    var isNeedFadeOutEffect : Bool = true
    var inDirection : TGChannelDirection = .left
    var outDirection : TGChannelDirection = .left
    var ContainerH : CGFloat {
        return CGFloat(ChannelCount) * (ChannelMargin + ChannelViewH) - ChannelMargin
    }
}
