import UIKit

public struct Minesweeper {
    
    public static var board: Grid {
        
        let grid = Grid([
            
            "111•1111  ".array(),
            "•21222•21 ".array(),
            "2•11•22•21".array(),
            "222111212•".array(),
            "1•1  11111".array(),
            "111  1•1  ".array(),
            "   11211  ".array(),
            "   1•1 111".array(),
            "11 11223•1".array(),
            "•1   1••21".array()
            
        ])
        
        return grid

        // randomize play area
        
//        let grid = Grid(10 ✕ (10 ✕ " "))
//        
//        for (r,_) in grid.content.enumerate() { grid[r,0] = "✘" }
//        for (r,row) in grid.content.enumerate() { grid[r] = row.randomize() }
//        
//        return grid

    }
    
    public static var field = Grid(10 ✕ (10 ✕ "•"))
    
    public static let playerPieces = ["⚑","✘"]
    
    public static func validateGuess(s1: Square, _ grid: Grid, _ solution: Grid) throws {
        
        guard let a1 = solution[s1.0,s1.1] as? Guess else { throw MoveError.IncorrectPiece }
        guard a1 != "⚑" else { throw MoveError.InvalidMove }
        
        grid[s1.0,s1.1] = a1
        
        guard a1 != "•" else { grid[s1.0,s1.1] = "✘"; throw GameStatus.GameOver }
        guard a1 == " " else { return }
                
        try checkAdjacent(s1, grid, solution)
        
    }
    
    public static func validateMark(s1: Square, _ grid: Grid, _ solution: Grid) throws {
        
        guard let g1 = grid[s1.0,s1.1] as? Guess else { throw MoveError.IncorrectPiece }
        
        guard g1 != "⚑" else { return grid[s1.0,s1.1] = "•" }
        
        grid[s1.0,s1.1] = "⚑"
        
    }
    
    public static func checkAdjacent(s1: Square, _ grid: Grid, _ solution: Grid) throws {
        
        let adjacent2 = [ (-1,-1),(-1,0),(-1,1),(0,1),(1,1),(1,0),(1,-1),(0,-1) ]
        
        for a in adjacent2 {
            
            let s = (s1.0 + a.0, s1.1 + a.1)
            guard grid.onBoard(s) else { continue }
            guard let a1 = solution[s.0,s.1] as? String, let g1 = grid[s.0,s.1] as? String where g1 != a1 else { continue }
            
            grid[s.0,s.1] = a1
            
            guard a1 == " " else { continue }
            
            try checkAdjacent(s, grid, solution)
            
        }
        
    }
    
}
