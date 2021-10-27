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

class TileView: UIView {
    
    var color: UIColor = .lightGray { didSet { setNeedsDisplay() } }
    var selectedColor: UIColor = .lightGray
    
    var letterLabel: UILabel!
    var valueLabel: UILabel!
    
    var tile: Words.Letter = .none {
        
        didSet {
            
            letterLabel?.removeFromSuperview()
            valueLabel?.removeFromSuperview()
            
            guard tile != .none else { return }
            
            letterLabel = UILabel()
            letterLabel.text = tile == .blank ? EmptyPiece : tile.rawValue.uppercased()
            letterLabel.textAlignment = .center
            letterLabel.font = .systemFont(ofSize: 18, weight: .heavy)
            addSubview(letterLabel)
            
            valueLabel = UILabel()
            valueLabel.text = tile.point == 0 ? EmptyPiece : "\(tile.point)"
            valueLabel.textAlignment = .right
            valueLabel.font = .systemFont(ofSize: 10, weight: .heavy)
            addSubview(valueLabel)
            
        }
        
    }
    
    var selected: (Words.Letter) -> Void = { _ in }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        letterLabel?.frame = rect
        valueLabel?.frame = CGRect(x: 0, y: 4, width: frame.width - 4, height: 10)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.clear(rect)
        
        guard tile != .none else { return }
        
        color.set()
        
        context?.addPath(UIBezierPath(roundedRect: rect.insetBy(dx: 1, dy: 1), cornerRadius: 6).cgPath)
        context?.fillPath()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard tile != .none else { return }
        
        selected(tile)
        color = selectedColor
        
    }
    
}
