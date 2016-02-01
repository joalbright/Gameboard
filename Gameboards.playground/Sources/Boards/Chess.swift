import UIKit

public struct Chess {
    
    public enum PieceType: String {
        
        case None = ""
        
        case Rook1 = "♜"
        case Knight1 = "♞"
        case Bishop1 = "♝"
        case Queen1 = "♛"
        case King1 = "♚"
        case Pawn1 = "♟"
        
        case Rook2 = "♖"
        case Knight2 = "♘"
        case Bishop2 = "♗"
        case Queen2 = "♕"
        case King2 = "♔"
        case Pawn2 = "♙"
        
    }
    
    public static var board: Grid {
        
        let grid = Grid(8 ✕ (8 ✕ ""))
        
        grid[0] = ["♜","♞","♝","♛","♚","♝","♞","♜"]
        grid[1] = 8 ✕ "♟"
        grid[6] = 8 ✕ "♙"
        grid[7] = ["♖","♘","♗","♕","♔","♗","♘","♖"]
        
        return grid
        
    }
    
    public static let playerPieces = ["♜♞♝♛♚♝♞♜♟","♖♘♗♕♔♗♘♖♙"]
    
    public static func validateEmptyPath(s1: Square, _ s2: Square, _ grid: Grid) throws {
        
        let mRow = s2.0 - s1.0
        let mCol = s2.1 - s1.1
        
        let d1 = mRow == 0 ? 0 : mRow > 0 ? 1 : -1
        let d2 = mCol == 0 ? 0 : mCol > 0 ? 1 : -1
        
        var p1 = s1.0 + d1, p2 = s1.1 + d2
        
        while p1 != s2.0 || p2 != s2.1 {
            
            guard let piece = grid[p1][p2] as? Piece where piece == "" else { throw MoveError.BlockedMove }
            
            p1 += d1
            p2 += d2
            
        }
        
    }
    
    public static func validateMove(s1: Square, _ s2: Square, _ p1: Piece, _ p2: Piece, _ grid: Grid) throws {
        
        let mRow = s2.0 - s1.0
        let mCol = s2.1 - s1.1
        
        let d1 = mRow == 0 ? 0 : mRow > 0 ? 1 : -1
        let d2 = mCol == 0 ? 0 : mCol > 0 ? 1 : -1
        
        switch PieceType(rawValue: p1) ?? .None {
            
        case .Bishop1, .Bishop2:
            
            try validateEmptyPath(s1, s2, grid)
            guard abs(mRow) == abs(mCol) else { throw MoveError.InvalidMove }
            
        case .King1, .King2:
            
            guard abs(mRow) < 2 && abs(mCol) < 2 else { throw MoveError.InvalidMove }
            
        case .Knight1, .Knight2:
            
            guard let piece = grid[s1.0 + d1][s1.1 + d2] as? Piece where piece == "" else { throw MoveError.BlockedMove }
            guard (abs(mRow) == 2 && abs(mCol) == 1) || (abs(mRow) == 1 && abs(mCol) == 2) else { throw MoveError.InvalidMove }
            
        case .Pawn1:
            
            try validateEmptyPath(s1, s2, grid)
            guard abs(mCol) == 0 || (abs(mCol) == 1 && mRow == 1 && p2 != "") else { throw MoveError.InvalidMove }
            guard mRow < 2 || (s1.0 == 1 && mRow == 2) else { throw MoveError.InvalidMove }
            
        case .Pawn2:
            
            try validateEmptyPath(s1, s2, grid)
            guard abs(mCol) == 0 || (abs(mCol) == 1 && mRow == -1 && p2 != "") else { throw MoveError.InvalidMove }
            guard mRow > -2 || (s1.0 == 6 && mRow == -2) else { throw MoveError.InvalidMove }
            
        case .Queen1, .Queen2:
            
            try validateEmptyPath(s1, s2, grid)
            
        case .Rook1, .Rook2:
            
            try validateEmptyPath(s1, s2, grid)
            guard mRow == 0 || mCol == 0 else { throw MoveError.InvalidMove }
            
        case .None: throw MoveError.IncorrectPiece
            
        }
        
        grid[s2.0,s2.1] = p1 // place my piece in target square
        grid[s1.0,s1.1] = "" // remove my piece from original square
        
    }
    
}


// Coordinates

public let A8 = ("a",8), A7 = ("a",7), A6 = ("a",6), A5 = ("a",5), A4 = ("a",4), A3 = ("a",3), A2 = ("a",2), A1 = ("a",1)
public let B8 = ("b",8), B7 = ("b",7), B6 = ("b",6), B5 = ("b",5), B4 = ("b",4), B3 = ("b",3), B2 = ("b",2), B1 = ("b",1)
public let C8 = ("c",8), C7 = ("c",7), C6 = ("c",6), C5 = ("c",5), C4 = ("c",4), C3 = ("c",3), C2 = ("c",2), C1 = ("c",1)
public let D8 = ("d",8), D7 = ("d",7), D6 = ("d",6), D5 = ("d",5), D4 = ("d",4), D3 = ("d",3), D2 = ("d",2), D1 = ("d",1)
public let E8 = ("e",8), E7 = ("e",7), E6 = ("e",6), E5 = ("e",5), E4 = ("e",4), E3 = ("e",3), E2 = ("e",2), E1 = ("e",1)
public let F8 = ("f",8), F7 = ("f",7), F6 = ("f",6), F5 = ("f",5), F4 = ("f",4), F3 = ("f",3), F2 = ("f",2), F1 = ("f",1)
public let G8 = ("g",8), G7 = ("g",7), G6 = ("g",6), G5 = ("g",5), G4 = ("g",4), G3 = ("g",3), G2 = ("g",2), G1 = ("g",1)
public let H8 = ("h",8), H7 = ("h",7), H6 = ("h",6), H5 = ("h",5), H4 = ("h",4), H3 = ("h",3), H2 = ("h",2), H1 = ("h",1)
