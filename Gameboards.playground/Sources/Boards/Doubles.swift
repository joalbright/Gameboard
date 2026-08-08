import Foundation

public struct Doubles {
    
    public static var board: Grid { return Grid(4 ✕ (4 ✕ " ")) }
    
    public static let playerPieces: [String] = []
    
    public static var staticboard: Grid {
        
        return Grid([
        
            "  2 ".array(),
            "    ".array(),
            "   8".array(),
            [" "," ","16","128"],
            
        ])
        
    }
    
    public static func validateMove(_ s1: Square, _ s2: Square, _ p1: Piece, _ p2: Piece, _ grid: Grid) throws -> Piece? {
        
        guard p1 != " " && (p1 == p2 || p2 == " ") else { throw MoveError.invalidmove }
        
        let double = "\((Int(p1) ?? 0) + (Int(p2) ?? 0))"
        
        grid[s2.0][s2.1] = p2 == " " ? p1 : double
        grid[s1.0][s1.1] = " " // remove initial piece
        
        return p1 == p2 && p1 != " " ? double : nil
        
    }
    
    public static func random(_ grid: Grid) -> Bool {

        var openSquares: [Square] = []

        for row in grid.rowRange {

            for column in grid.colRange where grid[row, column] as? String == " " {

                openSquares.append((row, column))

            }

        }

        guard let square = openSquares.randomElement() else { return false }

        grid[square.c, square.r] = "2"
        
        return true
        
    }
    
}
