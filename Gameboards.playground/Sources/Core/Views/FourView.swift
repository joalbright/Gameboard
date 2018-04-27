//
//  FourView.swift
//  Games
//
//  Created by Jo Albright on 4/21/18.
//  Copyright © 2018 Jo Albright. All rights reserved.
//

import UIKit

class FourView: UIView {
    
    public var p: CGFloat = 15
    public var holeColor: UIColor = .white
    public var spotColor: UIColor = UIColor(white: 0.90, alpha: 1)
    
    public override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineCap(.round)
        context?.setLineJoin(.round)
        context?.setLineWidth(2)
        
        holeColor.set()
        
        let w = (rect.width - p * 2) / 7
        let h = (rect.height - p * 2) / 7
        
        context?.fill(CGRect(x: 0, y: 0, width: rect.width, height: h + 10))
        
        backgroundColor?.set()
        
        context?.addPath(UIBezierPath(roundedRect: CGRect(x: 0, y: h, width: rect.width, height: 20), cornerRadius: 10).cgPath)
        context?.fillPath()
                
        for c in 0..<7 {
            
            holeColor.set()
            
            context?.addPath(UIBezierPath(roundedRect: CGRect(x: w * c + p + 5, y: 10, width: w - 10, height: h), cornerRadius: 10).cgPath)
            context?.fillPath()
            
            for r in 0..<6 {
                
                context?.fillEllipse(in: CGRect(x: w * c + p, y: h * r + p + h, width: w, height: h).insetBy(dx: 5, dy: 5))
                
            }
            
            spotColor.set()
            
            context?.strokeEllipse(in: CGRect(x: w * c + p, y: 0, width: w, height: h).insetBy(dx: 10, dy: 10))
            context?.fillEllipse(in: CGRect(x: w * c + p, y: 0, width: w, height: h).insetBy(dx: 15, dy: 15))
            
        }
        
    }

}
