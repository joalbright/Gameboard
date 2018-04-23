//
//  DotsView.swift
//  Games
//
//  Created by Jo Albright on 4/22/18.
//  Copyright © 2018 Jo Albright. All rights reserved.
//

import UIKit

class DotsView: UIView {
    
    public var p: CGFloat = 10
    public var lineColor: UIColor = .black
    
    public override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineCap(.round)
        context?.setLineJoin(.round)
        context?.setLineWidth(6)
        
        lineColor.set()
        
        let w = (rect.width - p * 2) / 8
        let h = (rect.height - p * 2) / 8
        
        for r in 0...8 {
            
            for c in 0...8 {
                
                context?.move(to: CGPoint(x: w * c + p, y: h * r + p))
                context?.addLine(to: CGPoint(x: w * c + p, y: h * r + p))
                
                context?.strokePath()
                
            }
            
        }
        
    }

}

class DotsLineView: UIView {
    
    public var playerColor: UIColor = .white
    public var lineColor: UIColor = .black
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineCap(.round)
        context?.setLineJoin(.round)
        context?.setLineWidth(1)
        
        lineColor.set()
        
        let h: Bool = rect.width > rect.height
        let p: CGFloat = 2
        let d: CGFloat = h ? rect.height - p * 2 : rect.width - p * 2
        
        context?.strokeEllipse(in: CGRect(x: p, y: p, width: d, height: d))
        context?.strokeEllipse(in: CGRect(x: rect.width - (d + p), y: rect.height - (d + p), width: d, height: d))
                
        let x = h ? d + 7 : d / 2 + p
        let y = h ? d / 2 + p : d + 7
        
        context?.setLineWidth(2)
        context?.setLineDash(phase: 0, lengths: [0,4])
        
        context?.move(to: CGPoint(x: x, y: y))
        context?.addLine(to: CGPoint(x: rect.width - x, y: rect.height - y))

        context?.strokePath()
        
    }
    
}

class DotsSquareView: UIView {
    
    public var playerColor: UIColor = .white
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        playerColor.set()
        
        context?.fillEllipse(in: rect.insetBy(dx: 5, dy: 5))
        
    }
    
}
