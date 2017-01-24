//
//  Flashable.swift
//  SocialDevs
//
//  Created by Steve Baker on 4/1/17.
//  Copyright © 2017 Steve Baker. All rights reserved.
//

import UIKit

protocol Flashable {}

extension Flashable where Self: UIView {
   
    func flashingText() {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.alpha = 1.0
        }) { (animationComplete) in
            if animationComplete == true {
                UIView.animate(withDuration: 0.3, delay: 4.0, options: .curveEaseOut, animations: {
                    self.alpha = 0.0
                }, completion: nil)
            }
        }
    }

}
