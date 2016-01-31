import UIKit

public struct Checkers {
    
    public static var board: Grid {
        
        var grid = Grid(8 ✕ (8 ✕ ""))
        
        grid[0] = 8 ✕ ("" %% "◎")
        grid[1] = 8 ✕ ("◎" %% "")
        grid[2] = 8 ✕ ("" %% "◎")
        grid[5] = 8 ✕ ("◉" %% "")
        grid[6] = 8 ✕ ("" %% "◉")
        grid[7] = 8 ✕ ("◉" %% "")
        
        return grid
        
    }
    
    public static let playerPieces = ["◎","◉"]
    
    public static func validateMove(s1: Square, _ s2: Square, _ piece: Piece, _ p2: Piece) throws {
        
        let m1 = s2.0 - s1.0
        let m2 = s2.1 - s1.1
        
        guard abs(m1) == 1 && abs(m2) == 1 else { throw MoveError.InvalidMove }
        
    }
    
}
