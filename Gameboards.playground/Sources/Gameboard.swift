import UIKit

public struct Gameboard {
    
    public enum BoardType: String {
        
        case Backgammon, Checkers, Chess, Mancala, Minesweeper, Sudoku, TicTacToe
        
    }
    
    public enum DifficultyLevel: String {
        
        case Easy, Medium, Hard, Expert, Nightmare
        
    }
    
    var _type: BoardType
    
    var player1Turn: Bool = false // arc4random_uniform(100) % 2 == 0 // uncomment to randomize starting player
    var playerPieces: [Piece] = []
    
    var grid: Grid = Grid(1 ✕ (1 ✕ ""))
    var solution: Grid = Grid(1 ✕ (1 ✕ ""))
    
    var _size: Int?
    var _difficulty: DifficultyLevel = .Easy
    
    public init(_ type: BoardType) {
        
        _type = type
        reset()
        
    }
    
    public init(_ type: BoardType, size: Int) {
        
        _type = type
        _size = size
        reset()
        
    }
    
    public mutating func guess(toSquare s1: Square) throws { try validateGuess(s1) }
    
    public mutating func guess(toSquare s1: Square, withGuess g1: Guess) throws { try validateGuess(s1, g1) }
    
    public mutating func mark(toSquare s1: Square) throws { try validateMark(s1) }
    
    public mutating func move(toSquare s1: Square) throws {
        
        try validateMove(s1)
        player1Turn = !player1Turn
        
    }
    
    public mutating func move(pieceAt s1: Square, toSquare s2: Square) throws -> Piece? {
        
        try validateMove(s1, s2)
        
        let piece2 = grid[s2.0,s2.1]
        
        player1Turn = !player1Turn
        
        return piece2 as? Piece
        
    }
    
    public mutating func move(pieceAt s1: ChessSquare, toSquare s2: ChessSquare) throws -> Piece? {
        
        let cols = "abcdefgh".array()
        guard let c1 = cols.indexOf(s1.0), let c2 = cols.indexOf(s2.0) else { return nil }
        let r1 = 8 - s1.1, r2 = 8 - s2.1
        
        try validateMove((r1,c1), (r2,c2))
        
        let piece2 = grid[r2,c2]
        
        player1Turn = !player1Turn
        
        return piece2 as? Piece
        
    }
    
    public mutating func reset() {
        
        player1Turn = !player1Turn
        highlights = []
        selected = nil
        
        switch _type {
            
        case .Backgammon: break
            
        case .Checkers:
            
            grid = Checkers.board
            playerPieces = Checkers.playerPieces
            
        case .Chess:
            
            grid = Chess.board
            playerPieces = Chess.playerPieces
            
        case .Mancala: break
            
        case .Minesweeper:
            
            solution = Minesweeper.board
            grid = Minesweeper.field
            
        case .Sudoku:
            
            solution = Sudoku.board
            grid = Sudoku.puzzle(solution)
            playerPieces = Sudoku.playerPieces
            
        case .TicTacToe:
            
            grid = TicTacToe.board
            playerPieces = TicTacToe.playerPieces
            
        }
        
    }
    
    public var highlights: [Square] = []
    public var selected: Square?
    
    public func visualize(rect: CGRect = CGRect(x: 0, y: 0, width: 200, height: 200)) -> UIView {
        
        switch _type {
            
        case .Backgammon: return UIView()
        case .Checkers, .Chess: return grid.checker(rect, highlights: highlights, selected: selected)
        case .Mancala: return UIView()
        case .Minesweeper: return grid.mine(rect)
        case .Sudoku: return grid.sudoku(rect, highlights: highlights)
        case .TicTacToe: return grid.ttt(rect)
            
        }
        
    }
    
}


