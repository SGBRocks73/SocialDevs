//
//  HeaderSahdow.swift
//  SocialDevs
//
//  Created by Steve Baker on 6/1/17.
//  Copyright © 2017 Steve Baker. All rights reserved.
//

import UIKit

class HeaderShadow: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(colorLiteralRed: Float(shadow_grey), green: Float(shadow_grey), blue: Float(shadow_grey), alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)

    }
}
