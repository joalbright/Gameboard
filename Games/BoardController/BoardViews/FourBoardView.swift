//
//  FourBoardView.swift
//  Games
//
//  Created by Jo Albright on 4/25/18.
//  Copyright © 2018 Jo Albright. All rights reserved.
//

import UIKit

@IBDesignable class FourBoardView : BoardView {
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.four, testing: true)
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.four)
        super.awakeFromNib()
        
    }
    
    override func selectSquare(_ square: Square) {
        
        do {
            
            try board.drop(pieceAt: square)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
                self.selectSquare((square.0 + 1,square.1))
            
            }
            
        } catch {
            
            print(error)
            
        }
        
        self.updateBoard()
        
    }
    
    override func coordinate(_ touch: UITouch) -> Square {
        
        let w = (frame.width - board.padding * 2) / 7
        let loc = touch.location(in: self)
        let c = Int((loc.x - board.padding) / w)
        
        return (-1,c)
        
    }
    
}
