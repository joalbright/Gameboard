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
    @IBOutlet weak var difficultyControl: UISegmentedControl!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        boardView?.board?.playerChange = { p in
         
            self.playerLabel.text = "Player \(p)"
            
        }
        
        difficultyControl?.selectedSegmentIndex = boardView?.board?.difficulty.hashValue ?? 0
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        
        guard let square = boardView?.coordinate(touch) else { return }
        
        boardView?.selectSquare(square)
        
    }
    
    @IBAction func chooseMinesweeperMark(sender: UISegmentedControl) {
        
        boardView?.minesweeperGuess = sender.selectedSegmentIndex == 0
        
    }
    

    @IBAction func chooseSudokuNymber(sender: UISegmentedControl) {
        
        boardView?.sudokuNumber = "\(sender.selectedSegmentIndex + 1)"
        
    }
    
    @IBAction func chooseDifficulty(sender: UISegmentedControl) {
        
        boardView?.board?.difficulty = Difficulty(sender.selectedSegmentIndex)
        boardView?.updateBoard()
                
    }
    
    @IBAction func resetBoard(sender: Any) {
        
        boardView?.board?.reset()
        boardView?.updateBoard()
        
    }
    
    
}

@IBDesignable class GradientView: UIView {
    
    @IBInspectable var startColor: UIColor = .white
    @IBInspectable var endColor: UIColor = .black
    
    override func draw(_ rect: CGRect) {
        
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x: 1, y: 1)
        
        let context = UIGraphicsGetCurrentContext()
        
        
        let colors: CFArray = [startColor.cgColor,endColor.cgColor] as CFArray
        
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: [0, 1]) else { return }
        
        let s = CGPoint(x: frame.width * startPoint.x, y: frame.height * startPoint.y)
        let e = CGPoint(x: frame.width * endPoint.x, y: frame.height * endPoint.y)
        
        context?.drawLinearGradient(gradient, start: s, end: e, options: .drawsAfterEndLocation)
        
    }
    
}

@IBDesignable class BoardView : UIView {
    
    var board: Gameboard!
    var boardView: UIView?
    
    var minesweeperGuess: Bool = true
    var sudokuNumber: String = "1"
    
    @IBInspectable var bgColor: UIColor = .white
    @IBInspectable var fgColor: UIColor = .black
    
    @IBInspectable var player1Color: UIColor = .red
    @IBInspectable var player2Color: UIColor = .blue
    
    @IBInspectable var selectedColor: UIColor = .white
    @IBInspectable var highlightColor: UIColor = .white
    
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
    
    func coordinate(_ touch: UITouch) -> Square {
        
        let w = frame.width / board.gridSize
        let h = frame.height / board.gridSize
        
        let loc = touch.location(in: self)
        
        let c = Int(loc.x / w)
        let r = Int(loc.y / h)
        
        return (r,c)
        
    }
    
    func selectSquare(_ square: Square) { }
    
}

@IBDesignable class BackgammonBoardView : BoardView {
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.backgammon)
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.backgammon)
        super.awakeFromNib()
        
    }
    
    override func selectSquare(_ square: Square) {
        
//        do {
//            
//            try board.move(toSquare: square)
//            
//        } catch {
//            
//            print(error)
//            
//        }
        
        updateBoard()
        
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
    
}

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
        
    }
    
}

@IBDesignable class ChessBoardView : BoardView {
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.chess)
        board.showAvailable(C7)
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.chess)
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

@IBDesignable class ConnectFourBoardView : BoardView {
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.connectfour, testing: true)
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.connectfour, testing: true)
        super.awakeFromNib()
        
    }
    
    override func selectSquare(_ square: Square) {
        
//        if let selected = board.selected {
//            
//            do {
//                
//                _ = try board.move(pieceAt: selected, toSquare: square)
//                
//                board.selected = nil
//                board.highlights = []
//                
//            } catch {
//                
//                print(error)
//                
//                board.showAvailable(square)
//                
//            }
//            
//        } else {
//            
//            board.showAvailable(square)
//            
//        }
        
        updateBoard()
        
    }
    
}

@IBDesignable class DotsBoardView : BoardView {
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.dots, testing: true)
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.dots, testing: true)
        super.awakeFromNib()
        
    }
    
    override func selectSquare(_ square: Square) {
        
//        do {
//            
//            try board.move(toSquare: square)
//            
//        } catch {
//            
//            print(error)
//            
//        }
        
        updateBoard()
        
    }
    
//    override func coordinate(_ touch: UITouch) -> Square {
//        
//        let p = 30
//        let w = (frame.width - p * 2) / (board.gridSize - 1)
//        let h = (frame.height - p * 2) / (board.gridSize - 1)
//        
//        let loc = touch.location(in: self)
//        
//        let c = Int((loc.x - (w / 2)) / w)
//        let r = Int((loc.y - (w / 2)) / h)
//        
//        return (r,c)
//        
//    }
    
}

@IBDesignable class GoBoardView : BoardView {
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.go)
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.go)
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
    
    override func coordinate(_ touch: UITouch) -> Square {
        
        let p = 30
        let w = (frame.width - p * 2) / (board.gridSize - 1)
        let h = (frame.height - p * 2) / (board.gridSize - 1)
        
        let loc = touch.location(in: self)
        
        let c = Int((loc.x - (w / 2)) / w)
        let r = Int((loc.y - (w / 2)) / h)
        
        return (r,c)
        
    }
    
}

@IBDesignable class MancalaBoardView : BoardView {
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.mancala, testing: true)
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.mancala, testing: true)
        super.awakeFromNib()
        
    }
    
    override func selectSquare(_ square: Square) {

//        do {
//
//            try board.move(toSquare: square)
//
//        } catch {
//
//            print(error)
//
//        }

        updateBoard()
        
    }
    
//    override func coordinate(_ touch: UITouch) -> Square {
//
//        let p = 30
//        let w = (frame.width - p * 2) / (board.gridSize - 1)
//        let h = (frame.height - p * 2) / (board.gridSize - 1)
//
//        let loc = touch.location(in: self)
//
//        let c = Int((loc.x - (w / 2)) / w)
//        let r = Int((loc.y - (w / 2)) / h)
//
//        return (r,c)
//
//    }
    
}

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
                
            } catch {
                
                print(error)
                
                if let error = error as? MemoryError, case error = MemoryError.badmatch {
                    
                    clean()
                    
                }
                
            }
            
        } else {
            
            guard let _ = try? board.select(cardAt: square) else { return }
            board.selected = square
            
        }
        
        updateBoard()
        
    }
    
}

@IBDesignable class MinesweeperBoardView : BoardView {
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.minesweeper, testing: true)
        _ = try? board.guess(toSquare: (4,4))
        _ = try? board.mark(toSquare: (7,4))
        _ = try? board.guess(toSquare: (9,0))
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.minesweeper)
        super.awakeFromNib()
        
    }
    
    override func selectSquare(_ square: Square) {
        
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

@IBDesignable class WordsBoardView : BoardView {
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.words)
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.words)
        super.awakeFromNib()
        
    }
    
    override func selectSquare(_ square: Square) {
        
//        do {
//            
//            try board.guess(toSquare: square, withGuess: sudokuNumber)
//            
//        } catch {
//            
//            print(error)
//            
//        }
        
        updateBoard()
        
    }
    
}

