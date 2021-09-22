//
//  GoBoardView.swift
//  Games
//
//  Created by Jo Albright on 4/25/18.
//  Copyright © 2018 Jo Albright. All rights reserved.
//

import UIKit

@IBDesignable class GoBoardView : BoardView {

    var passes: Int = 0
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.go)
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.go)
        super.awakeFromNib()

    }

    @IBAction func pass() {

        passes += 1
        board.changePlayer()
        checkDone()

    }
    
    override func selectSquare(_ square: Square) {
        
        do {
            
            try board.move(toSquare: square)
            
        } catch {
            
            print(error)
            
        }
        
        updateBoard()
        checkDone()
        
    }
    
    override func coordinate(_ touch: UITouch) -> Square {
        
        let p = 30
        let w = (frame.width - p * 2) / (board.gridSize - 1)
        let h = (frame.height - p * 2) / (board.gridSize - 1)
        
        let loc = touch.location(in: self)
        
        let c = Int((loc.x - (w / 2)) / w)
        let r = Int((loc.y - (w / 2)) / h)
        
        return (r,c)
        
    }

    override func checkDone() {

        guard board.grid.piecesOnBoard().count == board.totalSpaces || passes == 2 else { return }

        let pieces1 = board.grid.piecesOnBoard().filter { board.playerPieces[0].contains($0) }
        let pieces2 = board.grid.piecesOnBoard().filter { board.playerPieces[1].contains($0) }

        board?.showAlert?("Game Over", "Player \(pieces1.count > pieces2.count ? 1 : 2) Wins")
        passes = 0

    }
    
}
