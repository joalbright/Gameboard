//
//  PegsView.swift
//  Games
//
//  Created by Jo Albright on 4/25/18.
//  Copyright © 2018 Jo Albright. All rights reserved.
//

import UIKit

class PegsView: UIView {
    
    var p: CGFloat = 20
    var color: UIColor = .lightGray
    var lineColor: UIColor = .black
    
    public override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineCap(.round)
        context?.setLineJoin(.round)
        context?.setLineWidth(p)

        backgroundColor?.set()

        context?.fill(rect)
        
        let w = (rect.width - p * 2) / 7
        let h = (rect.height - p * 2) / 7
        
        color.set()
        
        context?.move(to: CGPoint(x: rect.width / 2, y: p / 2))
        context?.addLine(to: CGPoint(x: rect.width - p / 2, y: rect.height / 2))
        context?.addLine(to: CGPoint(x: rect.width / 2, y: rect.height - p / 2))
        context?.addLine(to: CGPoint(x: p / 2, y: rect.height / 2))
        
        context?.fillPath()
        
        context?.move(to: CGPoint(x: rect.width / 2, y: p / 2))
        context?.addLine(to: CGPoint(x: rect.width - p / 2, y: rect.height / 2))
        context?.addLine(to: CGPoint(x: rect.width / 2, y: rect.height - p / 2))
        context?.addLine(to: CGPoint(x: p / 2, y: rect.height / 2))
        context?.closePath()
        
        context?.strokePath()

        lineColor.set()
        
        context?.setLineWidth(6)
        
        let skip: [(Int,Int)] = [(0,0),(0,1),(1,0),(1,1),(5,0),(5,1),(6,0),(6,1),(0,5),(1,5),(0,6),(1,6),(5,5),(5,6),(6,5),(6,6)]
        
        for r in 0..<7 {
            
            for c in 0..<7 {
                
                guard !(skip.contains { $0.0 == c && $0.1 == r }) else { continue }
                
                context?.move(to: CGPoint(x: w * c + w / 2 + p, y: h * r + h / 2 + p))
                context?.addLine(to: CGPoint(x: w * c + w / 2 + p, y: h * r + h / 2 + p))
                context?.strokePath()
                
            }
            
        }
        
    }

}
