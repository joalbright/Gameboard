import UIKit

public struct TicTacToe {
    
    public static var board: Grid = Grid(3 ✕ (3 ✕ ""))
    
    public static let playerPieces = ["✕","⦿"]
    
    public static func validateMove(s1: Square, _ p1: Piece, _ grid: Grid, _ player1: Bool) throws {
        
        guard p1 == "" else { throw MoveError.InvalidMove }
        
        grid[s1.0,s1.1] = player1 ? playerPieces[0] : playerPieces[1] // place my piece in target square
        
    }
    
}