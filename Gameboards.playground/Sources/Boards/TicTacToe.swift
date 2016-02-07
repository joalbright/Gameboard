import UIKit

public struct TicTacToe {
    
    public static var board: Grid { return Grid(3 ✕ (3 ✕ "")) }
    
    public static let playerPieces = ["✕","○"]
    
    public static func validateMove(s1: Square, _ p1: Piece, _ grid: Grid, _ player: Int) throws {
        
        guard p1 == "" else { throw MoveError.InvalidMove }
        
        grid[s1.0,s1.1] = playerPieces[player] // place my piece in target square
        
    }
    
}