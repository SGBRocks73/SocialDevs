//
//  TextFieldExtras.swift
//  SocialDevs
//
//  Created by Steve Baker on 4/1/17.
//  Copyright © 2017 Steve Baker. All rights reserved.
//

import UIKit

class TextFieldExtras: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor(colorLiteralRed: Float(shadow_grey), green: Float(shadow_grey), blue: Float(shadow_grey), alpha: 0.2).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 4.5
    
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)

    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
}
