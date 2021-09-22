//
//  MemoryBoardView.swift
//  Games
//
//  Created by Jo Albright on 4/25/18.
//  Copyright © 2018 Jo Albright. All rights reserved.
//

import UIKit



@IBDesignable class MemoryBoardView : BoardView {

    var guesses: Int = 0
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.memory)
        _ = try? board?.select(cardAt: (0,2))
        _ = try? board?.match(cardAt: (2,1), withCard: (0,2))
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.memory)
        super.awakeFromNib()
        
    }
    
    override func selectSquare(_ square: Square) {
        
        let clean: () -> Void = {
            
            self.board.highlights = [self.board.selected, square].compactMap { $0 }
            self.board.selected = nil
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
                
                guard let highlights = self?.board.highlights, highlights.count > 1 else { return }

                
                _ = try? self?.board.match(cardAt: highlights[1], withCard: highlights[0], reset: true)
                self?.board.highlights = []

                self?.updateBoard()
                self?.checkDone()
                
            }
            
        }
        
        if board.highlights.count > 1 {

            return
            
        } else if let selected = board.selected {

            guesses += 1

            do {
                
                _ = try board.match(cardAt: square, withCard: selected)
                clean()
                
            } catch MemoryError.badmatch {

                clean()
                
            } catch { }
            
        } else {
            
            guard let _ = try? board.select(cardAt: square) else { return }
            board.selected = square
            
        }
        
        updateBoard()
        
    }

    override func checkDone() {

        let cardCount = board.grid.content.reduce(0) {

            $0 + $1.reduce(0) { $0 + ($1 != EmptyPiece ? 1 : 0) }

        }

        if cardCount == 0 {

            board?.showAlert?("Game Over", "It took \(guesses) Guesses")
            guesses = 0

        }

    }
    
}
