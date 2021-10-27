//
//  MancalaView.swift
//  Games
//
//  Created by Jo Albright on 4/22/18.
//  Copyright © 2018 Jo Albright. All rights reserved.
//

import UIKit

class MancalaView: UIView {
    
    public var p: CGFloat = 15
    public var holeColor: UIColor = .white
    public var spotColor: UIColor = UIColor(white: 0.90, alpha: 1)
    
    public override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineCap(.round)
        context?.setLineJoin(.round)
        context?.setLineWidth(4)
        
        let w = (rect.width - p * 2) / 6
        let h = (rect.height - p * 2) / 6
        
        holeColor.set()
        
        for c in 0..<6 {
            
            if c % 2 == 1 {
                
                context?.move(to: CGPoint(x: w * c + p, y: h / 2 + p))
                context?.addLine(to: CGPoint(x: w * c + p, y: h / 2 + p))
                context?.strokePath()
                
            }
            
            context?.fillEllipse(in: CGRect(x: w * c + p, y: p, width: w, height: h).insetBy(dx: 5, dy: 5))
            
            if c % 2 == 0, c > 0 {
                
                context?.move(to: CGPoint(x: w * c + p, y: h + h / 2 + p))
                context?.addLine(to: CGPoint(x: w * c + p, y: h + h / 2 + p))
                context?.strokePath()
                
            }
            
            context?.fillEllipse(in: CGRect(x: w * c + p, y: h + p, width: w, height: h).insetBy(dx: 5, dy: 5))
            
            context?.move(to: CGPoint(x: w * c + w / 2 + p, y: h + p))
            context?.addLine(to: CGPoint(x: w * c + w / 2 + p, y: h + p))
            context?.strokePath()
            
            if c == 0 || c == 5 {
                
                context?.move(to: CGPoint(x: w * c + w / 2 + p, y: h * 2 + p))
                context?.addLine(to: CGPoint(x: w * c + w / 2 + p, y: h * 2 + p))
                context?.strokePath()
                
                context?.move(to: CGPoint(x: w * c + w / 2 + p, y: rect.height - (h * 2 + p)))
                context?.addLine(to: CGPoint(x: w * c + w / 2 + p, y: rect.height - (h * 2 + p)))
                context?.strokePath()
                
            }
            
            context?.move(to: CGPoint(x: w * c + w / 2 + p, y: rect.height - (h + p)))
            context?.addLine(to: CGPoint(x: w * c + w / 2 + p, y: rect.height - (h + p)))
            context?.strokePath()
            
            context?.fillEllipse(in: CGRect(x: w * c + p, y: rect.height - (h * 2 + p), width: w, height: h).insetBy(dx: 5, dy: 5))
            
            if c % 2 == 0, c > 0 {
                
                context?.move(to: CGPoint(x: w * c + p, y: rect.height - (h + h / 2 + p)))
                context?.addLine(to: CGPoint(x: w * c + p, y: rect.height - (h + h / 2 + p)))
                context?.strokePath()
                
            }
            
            context?.fillEllipse(in: CGRect(x: w * c + p, y: rect.height - (h + p), width: w, height: h).insetBy(dx: 5, dy: 5))
            
            if c % 2 == 1 {
                
                context?.move(to: CGPoint(x: w * c + p, y: rect.height - (h / 2 + p)))
                context?.addLine(to: CGPoint(x: w * c + p, y: rect.height - (h / 2 + p)))
                context?.strokePath()
                
            }
            
        }
        
        context?.addPath(UIBezierPath(roundedRect: CGRect(x: p, y: h * 2 + p, width: w * 2, height: h * 2).insetBy(dx: 5, dy: 5), cornerRadius: w / 4).cgPath)
        
        context?.addPath(UIBezierPath(roundedRect: CGRect(x: rect.width - (w * 2 + p), y: h * 2 + p, width: w * 2, height: h * 2).insetBy(dx: 5, dy: 5), cornerRadius: w / 4).cgPath)
        
        context?.fillPath()
        
    }

}

class MancalaSpotView: UILabel {
    
    var stoneColor: UIColor = .black
    var stones: Int = 0 {
        
        didSet {
            
            setNeedsDisplay()
//            text = stones == 0 ? EmptyPiece : "\(stones)"
            
        }
        
    }
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        let d: CGFloat = rect.width / 4
        let r: CGFloat = stones > 4 ? d / 2 : (CGFloat(stones) / 4) * (d / 2)
        let s: CGFloat = 360 / CGFloat(stones)
        var a: CGFloat = 0
        
        stoneColor.withAlphaComponent(0.4).set()
        
        context?.setLineCap(.round)
        context?.setLineWidth(d)
        context?.setBlendMode(.multiply)
        
        for _ in 0..<stones {
            
            a += CGFloat(arc4random_uniform(30) + UInt32(s))

            let radian = a * .pi / 180
            let x = r * cos(radian)
            let y = r * sin(radian)
            let p = CGPoint(x: x + rect.midX, y: y + rect.midY)
            
            context?.move(to: p)
            context?.addLine(to: p)
            context?.strokePath()
            
        }
        
        super.draw(rect)
        
    }
    
}

class MancalaHomeView: UIView {
    
    
    
}
