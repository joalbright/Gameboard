//
//  BackgammonView.swift
//  Games
//
//  Created by Jo Albright on 4/20/18.
//  Copyright © 2018 Jo Albright. All rights reserved.
//

import UIKit

class BackgammonView: UIView {
    
    public var p: CGFloat = 15
    public var backgroundColor2: UIColor = .black
    
    public override func draw(_ rect: CGRect) {
        
        let lineColor1 = backgroundColor2.withAlphaComponent(0.3)
        let lineColor2 = backgroundColor2.withAlphaComponent(0.7)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineCap(.round)
        context?.setLineJoin(.round)
        
        let vG: CGFloat = 20
        let hG: CGFloat = 50
        
        backgroundColor2.set()
        
        context?.addPath(UIBezierPath(roundedRect: rect.insetBy(dx: 15, dy: 15), cornerRadius: 0).cgPath)
        context?.fillPath()
        
        backgroundColor?.set()

        context?.addRect(CGRect(x: rect.midX - vG / 2, y: 0, width: vG, height: rect.height))
        context?.fillPath()
        
        context?.setBlendMode(.multiply)
        
        let w = (rect.width - p * 2 - vG) / 12
        let h = (rect.height - p * 2 - hG) / 10
        
        for c in 0..<12 {
            
            let x = c > 5 ? 35 : 15
            
            (c % 2 == 0 ? lineColor1 : lineColor2).set()
            
            context?.move(to: CGPoint(x: w * c + x, y: 15))
            context?.addLine(to: CGPoint(x: w * c + x + w, y: 15))
            context?.addLine(to: CGPoint(x: w * c + x + w / 2, y: h * 5 + 15))
            context?.closePath()
            
            context?.fillPath()
            
            (c % 2 == 1 ? lineColor1 : lineColor2).set()
            
            context?.move(to: CGPoint(x: w * c + x, y: rect.height - 15))
            context?.addLine(to: CGPoint(x: w * c + x + w, y: rect.height - 15))
            context?.addLine(to: CGPoint(x: w * c + x + w / 2, y: h * 5 + 65))
            context?.closePath()
            
            context?.fillPath()
            
        }
        
    }

}
