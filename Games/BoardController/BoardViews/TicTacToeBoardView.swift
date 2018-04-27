//
//  TicTacToeBoardView.swift
//  Games
//
//  Created by Jo Albright on 4/25/18.
//  Copyright © 2018 Jo Albright. All rights reserved.
//

import UIKit

@IBDesignable class TicTacToeBoardView : BoardView {
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.tictactoe)
        _ = try? board.move(toSquare: (1,1))
        _ = try? board.move(toSquare: (0,1))
        _ = try? board.move(toSquare: (1,0))
        _ = try? board.move(toSquare: (1,2))
        _ = try? board.move(toSquare: (2,0))
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.tictactoe)
        super.awakeFromNib()
        
    }
    
    override func selectSquare(_ square: Square) {
        
        do {
            
            try board.move(toSquare: square)
            
        } catch {
            
            print(error)
            
        }
        
        updateBoard()
        
    }
    
}
