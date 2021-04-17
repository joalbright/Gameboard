import UIKit

public struct Checkers {
    
    public enum PieceType: String {
        
        case none = ""
        case checker1 = "●"
        case checker2 = "○"
        
        case king1 = "◉"
        case king2 = "◎"
        
    }
    
    public static var board: Grid {
        
        return Grid([
            
            8 ✕ ("" %% "●"),
            8 ✕ ("●" %% ""),
            8 ✕ ("" %% "●"),
            8 ✕ "",
            8 ✕ "",
            8 ✕ ("○" %% ""),
            8 ✕ ("" %% "○"),
            8 ✕ ("○" %% "")
            
        ])
        
    }
    
    public static let playerPieces = ["●◉","○◎"]
    
    public static func validateJump(_ s1: Square, _ s2: Square, _ p1: Piece, _ p2: Piece, _ grid: Grid, _ hint: Bool = false) -> Bool {
        
        let m1 = s2.0 - s1.0
        let m2 = s2.1 - s1.1
        
        let e1 = s1.0 + m1 / 2
        let e2 = s1.1 + m2 / 2
        
        
        switch PieceType(rawValue: p1) ?? .none {
            
        case .checker1:
            
            guard m1 == 2 && abs(m2) == 2 else { return false }
            
        case .checker2:
            
            guard m1 == -2 && abs(m2) == 2 else { return false }
            
        case .king1, .king2:
            
            guard abs(m1) == 2 && abs(m2) == 2 else { return false }
            
        case .none: return false
            
        }
        
        guard let piece1 = grid[s1.0,s1.1] as? String else { return false }
        guard let piece2 = grid[e1,e2] as? String else { return false }
        guard piece2 != "" && piece1 != piece2 else { return false }
        
        guard !hint else { return true }
        
        grid[e1,e2] = "" // remove other player piece
        
        return true
        
    }
    
    public static func validateMove(_ s1: Square, _ s2: Square, _ p1: Piece, _ p2: Piece, _ grid: Grid, _ hint: Bool = false) throws -> Piece? {
        
        let m1 = s2.0 - s1.0
        let m2 = s2.1 - s1.1
        
        guard p2 == "" else { throw MoveError.invalidmove }
        
        switch PieceType(rawValue: p1) ?? .none {
         
        case .checker1:
            
            guard (m1 == 1 && abs(m2) == 1) || validateJump(s1, s2, p1, p2, grid, hint) else { throw MoveError.invalidmove }
            
        case .checker2:
            
            guard (m1 == -1 && abs(m2) == 1) || validateJump(s1, s2, p1, p2, grid, hint) else { throw MoveError.invalidmove }
            
        case .king1, .king2:
            
            guard (abs(m1) == 1 && abs(m2) == 1) || validateJump(s1, s2, p1, p2, grid, hint) else { throw MoveError.invalidmove }
            
        case .none: throw MoveError.incorrectpiece

        }
        
        guard !hint else { return nil }
        
        let piece = grid[s2.0,s2.1]
        
        grid[s2.0,s2.1] = p1 // place my piece in target square
        grid[s1.0,s1.1] = "" // remove my piece from original square
        
        return piece as? Piece
        
    }
    
}
