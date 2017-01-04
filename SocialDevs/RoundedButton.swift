//
//  RoundedButton.swift
//  SocialDevs
//
//  Created by Steve Baker on 4/1/17.
//  Copyright © 2017 Steve Baker. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(colorLiteralRed: Float(shadow_grey), green: Float(shadow_grey), blue: Float(shadow_grey), alpha: 0.4).cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 3.0
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 4.5
    }

}
