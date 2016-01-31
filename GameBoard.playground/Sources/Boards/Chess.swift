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
        
        var grid = Grid(8 ✕ (8 ✕ ""))
        
        grid[0] = ["♜","♞","♝","♛","♚","♝","♞","♜"]
        grid[1] = 8 ✕ "♟"
        grid[6] = 8 ✕ "♙"
        grid[7] = ["♖","♘","♗","♕","♔","♗","♘","♖"]
        
        return grid
        
    }
    
    public static let playerPieces = ["♜♞♝♛♚♝♞♜♟","♖♘♗♕♔♗♘♖♙"]
    
    public static func validateMove(s1: Square, _ s2: Square, _ p1: Piece, _ p2: Piece) throws {
        
        let mRow = s2.0 - s1.0
        let mCol = s2.1 - s1.1
        
        print(mRow,mCol)
        
        switch PieceType(rawValue: p1) ?? .None {
            
        case .Bishop1, .Bishop2:
            
            guard abs(mRow) == abs(mCol) else { throw MoveError.InvalidMove }
            
        case .King1, .King2:
            
            guard abs(mRow) < 2 && abs(mCol) < 2 else { throw MoveError.InvalidMove }
            
        case .Knight1, .Knight2:
            
            guard (mRow == 2 && mCol == 1) || (mRow == 1 && mCol == 2) else { throw MoveError.InvalidMove }
            
        case .Pawn1:
            
            guard abs(mCol) == 0 || (abs(mCol) == 1 && mRow == 1 && p2 != "") else { throw MoveError.InvalidMove }
            guard mRow < 2 || (s1.0 == 1 && mRow == 2) else { throw MoveError.InvalidMove }
            
        case .Pawn2:
            
            
            guard abs(mCol) == 0 || (abs(mCol) == 1 && mRow == -1 && p2 != "") else { throw MoveError.InvalidMove }
            guard mRow > -2 || (s1.0 == 6 && mRow == -2) else { throw MoveError.InvalidMove }
            
        case .Queen1, .Queen2: break
            
        case .Rook1, .Rook2:
            
            guard mRow == 0 || mCol == 0 else { throw MoveError.InvalidMove }
            
        case .None: throw MoveError.IncorrectPieces
            
        }
        
        
    }
    
}
