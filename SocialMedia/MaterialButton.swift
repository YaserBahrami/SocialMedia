//
//  MaterialButton.swift
//  SocialMedia
//
//  Created by yaser on 10/6/16.
//  Copyright © 2016 yaserBahrami. All rights reserved.
//

import UIKit

class MaterialButton: UIButton {
    override func awakeFromNib() {
        layer.cornerRadius = 5.0
        layer.shadowColor = UIColor(red: Shadow_Color, green: Shadow_Color, blue: Shadow_Color, alpha: 0.5).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize.init(width: 0.0, height: 2.0)
    }

}
