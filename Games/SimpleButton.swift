//
//  SimpleButton.swift
//  Games
//
//  Created by Jo Albright on 2/7/16.
//  Copyright © 2016 Jo Albright. All rights reserved.
//

import UIKit

@IBDesignable class SimpleButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0
    
    override func drawRect(rect: CGRect) {
        
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        
    }

}
