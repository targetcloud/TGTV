//
//  TGPageStyle.swift
//  TGPageView
//
//  Created by targetcloud on 2017/3/22.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

class TGPageStyle {
    var titleBgColor : UIColor = UIColor.clear
    var contentBgColor : UIColor = UIColor.clear
    var splitLineColor : UIColor = UIColor.lightGray
    var animateWithDuration : TimeInterval = 0.25
    
    var titleViewHeight : CGFloat = 44 //导航条的高度，一般不用修改
    var titleFont : UIFont = UIFont.systemFont(ofSize: 15.0)//导航条上的字体大小，如果需要缩放请设置后面的isNeedTitleScale
    var isScrollEnable : Bool = false //默认是等分，不滚动模式，如果内容多，请设置为true开启滚动模式，此时下划线的长度是根据各个标题内容自适应
    
    var titleMargin : CGFloat = 20//滚动模式下的标题Margin
    
    var normalColor : UIColor = UIColor(r:255,g:255,b:255)//正常显示的颜色
    var selectColor : UIColor = UIColor.random()//选中（点中）时的标题文字颜色 ，正式使用时请设置你想要的颜色 UIColor(r:255,g:127,b:0) ！！！
    
    var isShowBottomLine : Bool = true //默认有跟踪滚动条（下划线）
    var bottomLineColor : UIColor = UIColor.random()//下划线的颜色
    var bottomLineHeight : CGFloat = 2//下划线的高度
    var bottomLineExtendWidth : CGFloat = 4//下划线的inset
    var bottomLineMargin : CGFloat = 1//下划线距离导航条底部默认有一个像素
    
    var isNeedTitleScale : Bool = false//是否需要缩放动画支持
    var scaleRange : CGFloat = 1.2//缩放比例，如有需要可以设置1.1～1.4比较合适
    
    var isShowCoverView : Bool = false{//遮罩模式，开启时会自动取消跟踪滚动条（下划线），如果在开启遮罩模式后，再设置isShowBottomLine为true则两者同时生效
        didSet{
            if isShowCoverView {
                isShowBottomLine = false
            }
        }
    }
    var coverBgColor : UIColor = UIColor.random()//遮罩的背景色，正式使用时请设置！！！
    var coverAlpha : CGFloat = 0.4//遮罩的透明，根据需要设置
    var coverMargin : CGFloat = 8//遮罩的边距
    var coverRadius : CGFloat = 8//遮罩四个角的圆角模式支持，如果不需要圆角设置为0
    var coverHeight : CGFloat = 28{//遮罩的高度，根据titleViewHeight调整,不允许超过titleViewHeight的80%
        didSet{
            if coverHeight >= titleViewHeight * 0.8{
                coverHeight = titleViewHeight * 0.8
            }
        }
    }
    
    var pageControlHeigth : CGFloat = 16
    
    var isTitleInTop : Bool = true //标题栏所在位置，上面还是下面，默认在上面
    var isFastDraggingEnable : Bool = true //是否允许连续快速滚动
}
