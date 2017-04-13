//
//  UIImage+extension.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/5.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

extension UIImage {
    func tg_avatarImage(size: CGSize?, backColor: UIColor = UIColor.white, lineColor: UIColor = UIColor.lightGray) -> UIImage? {
        var size = size
        if size == nil {
            size = self.size
        }
        let rect = CGRect(origin: CGPoint(), size: size!)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        backColor.setFill()
        UIRectFill(rect)
        let path = UIBezierPath(ovalIn: rect)
        path.addClip()
        draw(in: rect)
        let ovalPath = UIBezierPath(ovalIn: rect)
        ovalPath.lineWidth = 2
        lineColor.setStroke()
        ovalPath.stroke()
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    func tg_image(size: CGSize? = nil, backColor: UIColor = UIColor.white) -> UIImage? {
        var size = size
        if size == nil {
            size = self.size
        }
        let rect = CGRect(origin: CGPoint(), size: size!)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        backColor.setFill()
        UIRectFill(rect)
        draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}

