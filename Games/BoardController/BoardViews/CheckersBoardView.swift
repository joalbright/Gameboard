//
//  CheckersBoardView.swift
//  Games
//
//  Created by Jo Albright on 4/25/18.
//  Copyright © 2018 Jo Albright. All rights reserved.
//

import UIKit

@IBDesignable class CheckersBoardView : BoardView {
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.checkers)
        board.showAvailable((2,3))
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.checkers)
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
        checkDone()
        
    }

    override func checkDone() {

        if checkLost(player: 0) {

            board?.showAlert?("Game Over", "Player 2 Wins")

        } else if checkLost(player: 1) {

            board?.showAlert?("Game Over", "Player 1 Wins")

        }

    }

    private func checkLost(player: Int) -> Bool {

        return board.grid.piecesOnBoard().filter({ board.playerPieces[player].contains($0) }).isEmpty

    }
    
}
