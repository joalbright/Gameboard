//
//  MemoryBoardView.swift
//  Games
//
//  Created by Jo Albright on 4/25/18.
//  Copyright © 2018 Jo Albright. All rights reserved.
//

import UIKit



@IBDesignable class MemoryBoardView : BoardView {
    
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                
                guard self.board.highlights.count > 1 else { return }
                
                _ = try? self.board.match(cardAt: self.board.highlights[1], withCard: self.board.highlights[0], reset: true)
                self.board.highlights = []
                self.updateBoard()
                
                let cardCount = self.board.grid.content.reduce(0) {
                    
                    $0 + $1.reduce(0) { $0 + (($1 as! String) != "" ? 1 : 0) }
                    
                }
                
                if cardCount == 0 {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        
                        self.board.reset()
                        self.updateBoard()
                        
                    }
                    
                }
                
            }
            
        }
        
        if board.highlights.count > 1 {
            
            _ = try? self.board.match(cardAt: self.board.highlights[1], withCard: self.board.highlights[0], reset: true)
            self.board.highlights = []
            
            guard let _ = try? board.select(cardAt: square) else { return }
            board.selected = square
            
        } else if let selected = board.selected {
            
            do {
                
                _ = try board.match(cardAt: square, withCard: selected)
                clean()
                
            } catch MemoryError.badmatch {

                clean()
                
            } catch {

                print(error)

            }
            
        } else {
            
            guard let _ = try? board.select(cardAt: square) else { return }
            board.selected = square
            
        }
        
        updateBoard()
        
    }
    
}
