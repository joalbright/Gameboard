import UIKit

public struct Go {
    
    public static var board: Grid = Grid(9 ✕ (9 ✕ ""))
    
    public static let playerPieces = ["●1","●2"]
    
    public static func validateMove(s1: Square, _ grid: Grid, _ player1: Bool) throws {
        
        // validate if playable
        
        // current player
        let player = player1 ? 0 : 1
        grid[s1.0,s1.1] = playerPieces[player]
        
    }
    
}
