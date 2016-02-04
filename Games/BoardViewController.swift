//
//  ViewController.swift
//  Games
//
//  Created by Jo Albright on 2/3/16.
//  Copyright © 2016 Jo Albright. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController {
    
    @IBOutlet weak var boardView: BoardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        
        try? boardView.board.guess(toSquare: boardView.coordinate(touch))
        
    }

}

@IBDesignable class BoardView : UIView {
    
    var board: Gameboard!
    
    override func prepareForInterfaceBuilder() {
        
        addSubview(board.visualize(bounds))
        
    }
    
    func coordinate(touch: UITouch) -> (Int,Int) {
        
        let w = frame.width / board.grid.content[0].count
        let h = frame.height / board.grid.content.count
        
        let loc = touch.locationInView(self)
        
        let c = Int(loc.x / w)
        let r = Int(loc.y / h)
        
        return (r,c)
        
    }
    
}

@IBDesignable class CheckersBoardView : BoardView {
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.Checkers)
        super.prepareForInterfaceBuilder()
        
    }
    
    override func didMoveToWindow() {
        
        board = Gameboard(.Checkers)
        super.prepareForInterfaceBuilder()
        
    }
    
}

@IBDesignable class ChessBoardView : BoardView {
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.Chess)
        super.prepareForInterfaceBuilder()
        
    }
    
    override func didMoveToWindow() {
        
        board = Gameboard(.Chess)
        super.prepareForInterfaceBuilder()
        
    }
    
}

@IBDesignable class GoBoardView : BoardView {
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.Go)
        super.prepareForInterfaceBuilder()
        
    }
    
    override func didMoveToWindow() {
        
        board = Gameboard(.Go)
        super.prepareForInterfaceBuilder()
        
    }
    
}

@IBDesignable class MinesweeperBoardView : BoardView {
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.Minesweeper)
        super.prepareForInterfaceBuilder()
        
    }
    
    override func didMoveToWindow() {
        
        board = Gameboard(.Minesweeper)
        super.prepareForInterfaceBuilder()
        
    }
    
}

@IBDesignable class SudokuBoardView : BoardView {
        
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.Sudoku)
        super.prepareForInterfaceBuilder()
        
    }
    
    override func didMoveToWindow() {
        
        board = Gameboard(.Sudoku)
        super.prepareForInterfaceBuilder()
        
    }
    
}

@IBDesignable class TicTacToeBoardView : BoardView {
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.TicTacToe)
        super.prepareForInterfaceBuilder()
        
    }
    
    override func didMoveToWindow() {
        
        board = Gameboard(.TicTacToe)
        super.prepareForInterfaceBuilder()
        
    }
    
}

