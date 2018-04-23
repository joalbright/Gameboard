import UIKit

public struct Dots {
    
    public static var board: Grid { return Grid(8 ✕ (8 ✕ "00000")) }
    
    public static let playerPieces = ["1","2"]
    
    public static var staticboard: Grid {
        
        let grid = Grid(8 ✕ (8 ✕ "00000"))
        
        grid[1][1] = "00100"
        grid[1][2] = "10010"
        grid[2][2] = "21122"
        grid[2][3] = "12121"
        grid[3][3] = "22112"
        grid[3][4] = "10000"
        
        return grid
        
    }

}
