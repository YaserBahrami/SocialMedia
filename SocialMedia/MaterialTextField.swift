//
//  MaterialTextField.swift
//  SocialMedia
//
//  Created by yaser on 10/6/16.
//  Copyright © 2016 yaserBahrami. All rights reserved.
//

import UIKit

class MaterialTextField: UITextField {

    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.borderColor = UIColor(red: Shadow_Color, green: Shadow_Color, blue: Shadow_Color, alpha: 0.1).cgColor
        layer.borderWidth = 1.0
    }
    
    //For PlaceHolder
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10.0, dy: 0.0)
    }
    
    //For Editable Text
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
             return bounds.insetBy(dx: 10, dy: 0)

//        return bounds.insetBy(dx: 0, dy: 10)
        
    }
}
