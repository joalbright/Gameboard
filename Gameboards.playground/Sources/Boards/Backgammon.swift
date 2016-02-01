import UIKit

public struct Backgammon {
    
    public static var board: Grid {
        
        let grid = Grid(9 ✕ (9 ✕ ""))
        
        return grid
        
    }
    
    public static let playerPieces = ["",""]
    
    public static func validateMove(s1: Square, _ p1: Piece, _ grid: Grid, _ player1: Bool) throws {
        
        guard p1 == "" else { throw MoveError.InvalidMove }
        
        grid[s1.0,s1.1] = player1 ? playerPieces[0] : playerPieces[1] // place my piece in target square
        
    }
    
}