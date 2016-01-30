import UIKit

public typealias Square = (c: Int, r: Int)
public typealias ChessSquare = (c: String, r: Int)
public typealias Piece = String

public struct GameBoard {
    
    public enum BoardType {
        
        case Chess, Checkers
        
    }
    
    var grid: Grid
    
    
    public init(_ type: BoardType) {
        
        switch type {
            
        case .Chess:
            
            grid = Grid(8 ✕ (8 ✕ ""))
            
            grid[0] = ["♜","♞","♝","♛","♚","♝","♞","♜"]
            grid[1] = 8 ✕ "♟"
            grid[6] = 8 ✕ "♙"
            grid[7] = ["♖","♘","♗","♕","♔","♗","♘","♖"]
        
        case .Checkers:
            
            grid = Grid(8 ✕ (8 ✕ ""))
            
            grid[0] = 8 ✕ ("" %% "◎")
            grid[1] = 8 ✕ ("◎" %% "")
            grid[2] = 8 ✕ ("" %% "◎")
            grid[5] = 8 ✕ ("◉" %% "")
            grid[6] = 8 ✕ ("" %% "◉")
            grid[7] = 8 ✕ ("◉" %% "")
            
        }
        
        
    }
    
    public mutating func move(pieceAt s1: Square, toSquare s2: Square) -> Piece? {
        
        let piece1 = grid[s1.0,s1.1]
        let piece2 = grid[s2.0,s2.1]
        
        grid[s2.0,s2.1] = piece1
        grid[s1.0,s1.1] = ""
        
        return piece2 as? Piece
        
    }
    
    public mutating func move(pieceAt s1: ChessSquare, toSquare s2: ChessSquare) -> Piece? {
        
        let cols: [String] = "abcdefgh".characters.map { "\($0)" }
        guard let c1 = cols.indexOf(s1.0), let c2 = cols.indexOf(s1.0) else { return nil }
        let r1 = 8 - s1.1
        let r2 = 8 - s2.1
        
        let piece1 = grid[r1,c1]
        let piece2 = grid[r2,c2]
        
        grid[r2,c2] = piece1
        grid[r1,c1] = ""
        
        return piece2 as? Piece
        
    }
    
    public func visualize(rect: CGRect = CGRect(x: 0, y: 0, width: 200, height: 200)) -> UIView {
        
        return grid.checker(rect)
        
    }
    
}