import UIKit

public typealias Square = (c: Int, r: Int)
public typealias ChessSquare = (c: String, r: Int)
public typealias Piece = String

public struct GameBoard {
    
    public enum BoardType: String {
        
        case Chess, Checkers
        
    }
    
    var _type: BoardType
    var player1Turn: Bool = false // arc4random_uniform(100) % 2 == 0 // uncomment to randomize starting player
    var playerPieces: [Piece] = []
    var grid: Grid = Grid(1 ✕ (1 ✕ ""))
    
    public init(_ type: BoardType) {
        
        _type = type
        reset()
        
    }
    
    public mutating func move(pieceAt s1: Square, toSquare s2: Square) throws -> Piece? {
        
        let piece1 = grid[s1.0,s1.1]
        let piece2 = grid[s2.0,s2.1]
        
        try validateMove(s1, s2)
        
        grid[s2.0,s2.1] = piece1
        grid[s1.0,s1.1] = ""
        
        player1Turn = !player1Turn
        
        return piece2 as? Piece
        
    }
    
    public mutating func move(pieceAt s1: ChessSquare, toSquare s2: ChessSquare) throws -> Piece? {
        
        let cols: [String] = "abcdefgh".characters.map { "\($0)" }
        guard let c1 = cols.indexOf(s1.0), let c2 = cols.indexOf(s2.0) else { return nil }
        let r1 = 8 - s1.1, r2 = 8 - s2.1
        
        try validateMove((r1,c1), (r2,c2))
        
        let piece1 = grid[r1,c1]
        let piece2 = grid[r2,c2]
        
        grid[r2,c2] = piece1
        grid[r1,c1] = ""
        
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
            
        }
        
    }
    
    public func visualize(rect: CGRect = CGRect(x: 0, y: 0, width: 200, height: 200)) -> UIView {
        
        return grid.checker(rect)
        
    }
    
}


