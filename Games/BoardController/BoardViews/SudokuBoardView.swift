//
//  SudokuBoardView.swift
//  Games
//
//  Created by Jo Albright on 4/25/18.
//  Copyright © 2018 Jo Albright. All rights reserved.
//

import UIKit

@IBDesignable class SudokuBoardView : BoardView {
    
    var sudokuNumber: String = "1"
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.sudoku, testing: true)
        _ = try? board.guess(toSquare: (2,7), withGuess: "4")
        _ = try? board.guess(toSquare: (8,8), withGuess: "4")
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.sudoku)
        super.awakeFromNib()
        
    }
    
    override func selectSquare(_ square: Square) {
        
        do {
            
            try board.guess(toSquare: square, withGuess: sudokuNumber)
            
        } catch {
            
            print(error)
            
        }
        
        updateBoard()
        
    }
    
}

extension BoardViewController {
    
    @IBAction func chooseSudokuNymber(sender: UISegmentedControl) {
        
        (boardView as? SudokuBoardView)?.sudokuNumber = "\(sender.selectedSegmentIndex + 1)"
        
    }
    
}
