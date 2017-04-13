//
//  TGEmitterable.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/8.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

protocol TGEmitterable {
}

extension TGEmitterable where Self : UIViewController {
    func startEmittering(_ point : CGPoint) {
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = point
        emitter.preservesDepth = true
        
        var cells = [CAEmitterCell]()
        for i in 0..<10 {
            let cell = CAEmitterCell()
            
            cell.velocity = 150
            cell.velocityRange = 100
            
            cell.scale = 0.7
            cell.scaleRange = 0.3
            
            cell.emissionLongitude = CGFloat(-M_PI_2)
            cell.emissionRange = CGFloat(M_PI_2 / 6)
            
            cell.lifetime = 3
            cell.lifetimeRange = 1.5
            
            cell.spin = CGFloat(M_PI_2)
            cell.spinRange = CGFloat(M_PI_2 / 2)
            
            cell.birthRate = 2
            cell.contents = UIImage(named: "good\(i)_30x30")?.cgImage
            cells.append(cell)
        }
        emitter.emitterCells = cells
        view.layer.addSublayer(emitter)
    }
    
    func stopEmittering() {
        view.layer.sublayers?.filter({$0.isKind(of: CAEmitterLayer.self)}).first?.removeFromSuperlayer()
    }
}

