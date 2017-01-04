//
//  Jitterable.swift
//  SocialDevs
//
//  Created by Steve Baker on 4/1/17.
//  Copyright © 2017 Steve Baker. All rights reserved.
//

import UIKit

protocol Jitterable {}

extension Jitterable where Self: UIView {

    func jitter() {
        let animate = CABasicAnimation(keyPath: "position")
        animate.duration = 0.05
        animate.repeatCount = 5
        animate.autoreverses = true
        animate.fromValue = NSValue(cgPoint: CGPoint.init(x: self.center.x - 5.0, y: self.center.y))
        animate.toValue = NSValue(cgPoint: CGPoint.init(x: self.center.x + 5.0, y: self.center.y))
        layer.add(animate, forKey: "position")
        
    }
    
}
