//
//  WordsView.swift
//  Games
//
//  Created by Jo Albright on 4/23/18.
//  Copyright © 2018 Jo Albright. All rights reserved.
//

import UIKit

class WordsView: UIView {
    
    public var p: CGFloat = 2
    var lineColor: UIColor = .black
    
    public override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineCap(.round)
        context?.setLineJoin(.round)
        context?.setLineWidth(1)
        
        lineColor.set()
        
        let w = (rect.width - p * 2) / 15
        let h = (rect.height - p * 2) / 15

        for r in 0..<15 {
            
            for c in 0..<15 {
                
                context?.addPath(UIBezierPath(roundedRect: CGRect(x: w * c + p, y: h * r + p, width: w, height: h).insetBy(dx: 1, dy: 1), cornerRadius: 4).cgPath)
                context?.fillPath()
                
            }
            
        }
        
    }

}
