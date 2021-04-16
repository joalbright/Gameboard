import UIKit

public struct Four {
    
    public static var board: Grid { return Grid(6 ✕ (7 ✕ " ")) }
    
    public static let playerPieces = ["◉","◎"]

    public static var staticboard: Grid {
        
        return Grid([
            
            7 ✕ " ",
            7 ✕ " ",
            "     ◎ ".array(),
            "     ◉ ".array(),
            "    ◎◉ ".array(),
            "   ◎◉◉ ".array()
            
        ])
        
    }
    
    public static func validateDrop(_ s1: Square, _ p1: Piece, _ grid: Grid) throws {
     
        guard let piece = grid[s1.0 + 1][s1.1] as? Piece, piece == " " else { throw MoveError.invalidmove }
        grid[s1.0 + 1][s1.1] = p1
        
        guard grid.onBoard(s1) else { return }
        grid[s1.0][s1.1] = " "
        
    }
    
}
