//
//  BombsweeperBoardView.swift
//  Games
//
//  Created by Jo Albright on 4/25/18.
//  Copyright © 2018 Jo Albright. All rights reserved.
//

import UIKit



@IBDesignable class BombsweeperBoardView : BoardView {
    
    var bombsweeperGuess: Bool = true
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.bombsweeper, testing: true)
        _ = try? board.guess(toSquare: (4,4))
        _ = try? board.mark(toSquare: (7,4))
        _ = try? board.guess(toSquare: (9,0))
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.bombsweeper)
        super.awakeFromNib()
        
    }
    
    override func selectSquare(_ square: Square) {
        
        do {
            
            if bombsweeperGuess {
                
                try board.guess(toSquare: square)
                
            } else {
                
                try board.mark(toSquare: square)
                
            }
            
        } catch {
            
            print(error)
            
        }
        
        updateBoard()
        
    }
    
}

extension BoardViewController {
    
    @IBAction func chooseBombsweeperMark(sender: UISegmentedControl) {
        
        (boardView as? BombsweeperBoardView)?.bombsweeperGuess = sender.selectedSegmentIndex == 0
        
    }
    
}
