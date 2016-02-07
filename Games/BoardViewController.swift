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
    @IBOutlet weak var playerLabel: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        boardView?.board?.playerChange = { p in
         
            self.playerLabel.text = "Player \(p)"
            
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        
        let square = boardView.coordinate(touch)
        
        boardView.selectSquare(square)
        
    }
    
    @IBAction func chooseMinesweeperMark(sender: UISegmentedControl) {
        
        boardView.minesweeperGuess = sender.selectedSegmentIndex == 0
        
    }
    

    @IBAction func chooseSudokuNymber(sender: UISegmentedControl) {
        
        boardView.sudokuNumber = sender.titleForSegmentAtIndex(sender.selectedSegmentIndex) ?? "1"
        
    }
    
    @IBAction func resetBoard(sender: AnyObject) {
        
        boardView?.board?.reset()
        boardView?.updateBoard()
        
    }
    
    
}

@IBDesignable class BoardView : UIView {
    
    var board: Gameboard!
    var boardView: UIView?
    
    var minesweeperGuess: Bool = true
    var sudokuNumber: String = "1"
    
    @IBInspectable var bgColor: UIColor = UIColor.whiteColor()
    @IBInspectable var fgColor: UIColor = UIColor.blackColor()
    
    @IBInspectable var player1Color: UIColor = UIColor.redColor()
    @IBInspectable var player2Color: UIColor = UIColor.blueColor()
    
    @IBInspectable var selectedColor: UIColor = UIColor.whiteColor()
    @IBInspectable var highlightColor: UIColor = UIColor.whiteColor()
    
    override func prepareForInterfaceBuilder() { updateBoard() }
    override func didMoveToWindow() { updateBoard() }
    override func layoutSubviews() { updateBoard() }
    
    func updateBoard() {
        
        board?.boardColors.background = bgColor
        board?.boardColors.foreground = fgColor
        board?.boardColors.player1 = player1Color
        board?.boardColors.player2 = player2Color
        board?.boardColors.selected = selectedColor
        board?.boardColors.highlight = highlightColor
        
        boardView?.removeFromSuperview()
        boardView = board?.visualize(bounds)
        guard let boardView = boardView else { return }
        addSubview(boardView)
        
    }
    
    func coordinate(touch: UITouch) -> Square {
        
        let w = frame.width / board.gridSize
        let h = frame.height / board.gridSize
        
        let loc = touch.locationInView(self)
        
        let c = Int(loc.x / w)
        let r = Int(loc.y / h)
        
        return (r,c)
        
    }
    
    func selectSquare(square: Square) { }
    
}

@IBDesignable class CheckersBoardView : BoardView {
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.Checkers)
        board.showAvailable((2,3))
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.Checkers)
        super.awakeFromNib()
        
    }
    
    override func selectSquare(square: Square) {
        
        if let selected = board.selected {
            
            do {
                
                try board.move(pieceAt: selected, toSquare: square)
                
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

@IBDesignable class ChessBoardView : BoardView {
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.Chess)
        board.showAvailable(C7)
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.Chess)
        super.awakeFromNib()
        
    }
    
    override func selectSquare(square: Square) {
        
        if let selected = board.selected {
            
            do {
                
                try board.move(pieceAt: selected, toSquare: square)
                
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

@IBDesignable class GoBoardView : BoardView {
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.Go)
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.Go)
        super.awakeFromNib()
        
    }
    
    override func selectSquare(square: Square) {
        
        do {
            
            try board.move(toSquare: square)
            
        } catch {
            
            print(error)
            
        }
        
        updateBoard()
        
    }
    
    override func coordinate(touch: UITouch) -> Square {
        
        let p = 30
        let w = (frame.width - p * 2) / (board.gridSize - 1)
        let h = (frame.height - p * 2) / (board.gridSize - 1)
        
        let loc = touch.locationInView(self)
        
        let c = Int((loc.x - (w / 2)) / w)
        let r = Int((loc.y - (w / 2)) / h)
        
        return (r,c)
        
    }
    
}

@IBDesignable class MinesweeperBoardView : BoardView {
    
    
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.Minesweeper, testing: true)
        _ = try? board.guess(toSquare: (4,4))
        _ = try? board.mark(toSquare: (7,4))
        _ = try? board.guess(toSquare: (9,0))
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.Minesweeper)
        super.awakeFromNib()
        
    }
    
    override func selectSquare(square: Square) {
        
        do {
            
            if minesweeperGuess {
                
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

@IBDesignable class SudokuBoardView : BoardView {
        
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.Sudoku, testing: true)
        _ = try? board.guess(toSquare: (2,7), withGuess: "4")
        _ = try? board.guess(toSquare: (8,8), withGuess: "4")
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.Sudoku)
        super.awakeFromNib()
        
    }
    
    override func selectSquare(square: Square) {
        
        do {
            
            try board.guess(toSquare: square, withGuess: sudokuNumber)
            
        } catch {
            
            print(error)
            
        }
        
        updateBoard()
        
    }
    
}

@IBDesignable class TicTacToeBoardView : BoardView {
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.TicTacToe)
        _ = try? board.move(toSquare: (1,1))
        _ = try? board.move(toSquare: (0,1))
        _ = try? board.move(toSquare: (1,0))
        _ = try? board.move(toSquare: (1,2))
        _ = try? board.move(toSquare: (2,0))
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.TicTacToe)
        super.awakeFromNib()
        
    }
    
    override func selectSquare(square: Square) {
        
        do {
            
            try board.move(toSquare: square)
            
        } catch {
            
            print(error)
            
        }
        
        updateBoard()
        
    }
    
}

