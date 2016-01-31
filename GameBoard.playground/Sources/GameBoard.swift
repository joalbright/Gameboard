import UIKit

public typealias Square = (c: Int, r: Int)
public typealias ChessSquare = (c: String, r: Int)
public typealias Piece = String

public struct GameBoard {
    
    public enum BoardType: String {
        
        case Chess, Checkers, TicTacToe
        
    }
    
    var _type: BoardType
    var player1Turn: Bool = false // arc4random_uniform(100) % 2 == 0 // uncomment to randomize starting player
    var playerPieces: [Piece] = []
    var grid: Grid = Grid(1 ✕ (1 ✕ ""))
    
    public init(_ type: BoardType) {
        
        _type = type
        reset()
        
    }
    
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
        
        let cols: [String] = "abcdefgh".characters.map { "\($0)" }
        guard let c1 = cols.indexOf(s1.0), let c2 = cols.indexOf(s2.0) else { return nil }
        let r1 = 8 - s1.1, r2 = 8 - s2.1
        
        try validateMove((r1,c1), (r2,c2))
        
        let piece2 = grid[r2,c2]
        
        player1Turn = !player1Turn
        
        return piece2 as? Piece
        
    }
    
    public mutating func reset() {
        
        player1Turn = !player1Turn
        
        switch _type {
            
        case .Chess:
            
            grid = Chess.board
            playerPieces = Chess.playerPieces
            
        case .Checkers:
            
            grid = Checkers.board
            playerPieces = Checkers.playerPieces
            
        case .TicTacToe:
            
            grid = TicTacToe.board
            playerPieces = TicTacToe.playerPieces
            
        }
        
    }
    
    public var highlights: [Square] = []
    public var selected: Square?
    
    public func visualize(rect: CGRect = CGRect(x: 0, y: 0, width: 200, height: 200)) -> UIView {
        
        switch _type {
            
        case .Chess, .Checkers: return grid.checker(rect, highlights: highlights, selected: selected)
        case .TicTacToe: return grid.ttt(rect)
            
        }
        
        
        
    }
    
}


