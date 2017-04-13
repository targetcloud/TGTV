//
//  UIColor+extension.swift
//  TGPageView
//
//  Created by targetcloud on 2017/3/22.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

extension UIColor{
    class func randomColor() -> UIColor{
        return UIColor(red: CGFloat(arc4random_uniform(255))/255.0, green: CGFloat(arc4random_uniform(255))/255.0, blue: CGFloat(arc4random_uniform(255))/255.0, alpha: 1.0)
    }
    
    class func random() -> UIColor{
        return UIColor.randomColor()
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }
    
    convenience init(c: CGFloat,  alpha: CGFloat = 1.0) {
        self.init(red: c/255.0, green: c/255.0, blue: c/255.0, alpha: alpha)
    }
    
    convenience init?(hex:String) {
        guard hex.characters.count>=6 else {
            return nil
        }
        
        var hexTemp = hex.uppercased()
        if hexTemp.hasPrefix("0X") || hexTemp.hasPrefix("##"){
            hexTemp = (hexTemp as NSString).substring(from: 2)
        }
        
        if hexTemp.hasPrefix("#"){
            hexTemp = (hexTemp as NSString).substring(from: 1)
        }
        
        var range = NSRange(location: 0, length: 2)
        let rHex = (hexTemp as NSString).substring(with: range)
        range.location = 2
        let gHex = (hexTemp as NSString).substring(with: range)
        range.location = 4
        let bHex = (hexTemp as NSString).substring(with: range)
    
        var r : UInt32 = 0
        var g : UInt32 = 0
        var b : UInt32 = 0
        
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
    }
    
    func getRGB() -> (CGFloat,CGFloat,CGFloat) {
        var r : CGFloat = 0
        var g : CGFloat = 0
        var b : CGFloat = 0
        
        if self.getRed(&r, green: &g, blue: &b, alpha: nil){
            return (r * 255,g * 255,b * 255)
        }
        
        guard let cmps = cgColor.components else {
//            throw
            fatalError("请使用RGB创建UIColor")
        }
        return(cmps[0] * 255,cmps[1] * 255,cmps[2] * 255)
    }
}
