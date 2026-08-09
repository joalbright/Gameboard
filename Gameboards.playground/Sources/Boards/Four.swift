import SwiftUI

public struct Four {
    
    public static var board: Grid { return Grid(6 ✕ (7 ✕ " ")) }
    
    public static let playerPieces = ["◉","◎"]
    public static let playerColors = [Color(red: 0.892, green: 0, blue: 0.222), Color(red: 0.947, green: 0.845, blue: 0.025)]

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
    
    public static func validateDrop(_ s1: Square, _ p1: Piece, _ grid: inout Grid) throws {
     
        guard grid[s1.0 + 1][s1.1] == " " else { throw MoveError.invalidmove }
        grid[s1.0 + 1][s1.1] = p1
        
        guard grid.onBoard(s1) else { return }
        grid[s1.0][s1.1] = " "
        
    }
    
}
