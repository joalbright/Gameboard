//
//  PegSolitaireBoardView.swift
//  Games
//
//  Created by Jo Albright on 4/25/18.
//  Copyright © 2018 Jo Albright. All rights reserved.
//

import UIKit

class PegsBoardView: BoardView {
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.pegs)
        _ = try? board.validateMove((3,1), (3,3))
        _ = try? board.validateMove((3,4), (3,2))
        _ = try? board.validateMove((1,3), (3,3))
        _ = try? board.validateMove((3,3), (3,1))
        _ = try? board.validateMove((3,0), (3,2))
        _ = try? board.validateMove((3,6), (3,4))
        _ = try? board.validateMove((5,3), (3,3))
        board.showAvailable((3,3))
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.pegs)
        super.awakeFromNib()
        
    }
    
    override func selectSquare(_ square: Square) {
        
        if let selected = board.selected {
            
            do {
                
                _ = try board.move(pieceAt: selected, toSquare: square)
                
                board.selected = nil
                board.highlights = []
                
            } catch {
                
                print(error)
                
                board.showAvailable(square)
                
            }
            
        } else {
            
            board.showAvailable(square)
            
        }
        
        updateBoard()
        
    }

}
