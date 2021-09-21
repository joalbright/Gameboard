//
//  Pegs.swift
//  Games
//
//  Created by Jo Albright on 4/25/18.
//  Copyright © 2018 Jo Albright. All rights reserved.
//

import UIKit

class Pegs: NSObject {
    
    public static var board: Grid {
        
        return Grid([
        
            "!!●●●!!".array(),
            "!!●●●!!".array(),
            "●●●●●●●".array(),
            "●●● ●●●".array(),
            "●●●●●●●".array(),
            "!!●●●!!".array(),
            "!!●●●!!".array()
            
        ])
        
    }
    
    public static let playerPieces = ["●"]
    
    public static func validateMove(_ s1: Square, _ s2: Square, _ p1: Piece, _ p2: Piece, _ grid: Grid, _ hint: Bool = false) throws -> Piece? {
        
        let m1 = s2.0 - s1.0
        let m2 = s2.1 - s1.1
        
        guard p1 == "●" && p2 == " " else { throw MoveError.invalidmove }
        
        guard (abs(m1) == 2 && abs(m2) == 0) || (abs(m1) == 0 && abs(m2) == 2) else { throw MoveError.invalidmove }
        
        let e1 = s1.0 + m1 / 2
        let e2 = s1.1 + m2 / 2
        
        let piece = grid[e1,e2] as? Piece
        
        guard piece == "●" else { throw MoveError.invalidmove }
        
        guard !hint else { return nil }
        
        grid[s2.0,s2.1] = p1
        grid[s1.0,s1.1] = " " // remove initial piece
        grid[e1,e2] = " " // remove jumped piece
        
        return piece
        
    }

}

extension Grid {
    
    public func pegs(_ rect: CGRect, highlights: [Square], selected: Square?) -> UIView {
        
        let view = PegsView(frame: rect)

        view.backgroundColor = colors.background
        view.p = padding
        view.color = colors.foreground
        view.lineColor = colors.player2
        
        let w = (rect.width - padding * 2) / content.count
        let h = (rect.height - padding * 2) / content.count
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {
                
                guard "\(item)" != "!" else { continue }
                
                let label = HintLabel(frame: CGRect(x: c * w + padding, y: r * h + padding, width: w, height: h))
                label.text = "\(item)"
                label.textAlignment = .center
                label.font = .systemFont(ofSize: (w + h) / 2 - 15, weight: .regular)
                label.textColor = colors.player1
                label.highlightColor = colors.highlight
                
                if let selected = selected, selected.0 == r && selected.1 == c { label.textColor = colors.selected }

                for highlight in highlights { label.highlight = label.highlight ? true : highlight.0 == r && highlight.1 == c }

                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
}
