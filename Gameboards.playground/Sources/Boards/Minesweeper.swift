import UIKit

public struct Minesweeper {
    
    public static var board: Grid {

        // randomize play area
        
        let grid = Grid(10 ✕ (10 ✕ " "))
        
        for (r,_) in grid.content.enumerate() { grid[r,4] = "•" }
        for (r,row) in grid.content.enumerate() { grid[r] = row.randomize().randomize().randomize() }

        return addMineCount(grid)

    }
    
    public static var staticboard: Grid {
        
        let grid = Grid([

            "   •      ".array(),
            "•     •   ".array(),
            " •  •  •  ".array(),
            "         •".array(),
            " •        ".array(),
            "      •   ".array(),
            "          ".array(),
            "    •     ".array(),
            "        • ".array(),
            "•     ••  ".array()

        ])

        return addMineCount(grid)
        
    }
    
    public static var field: Grid { return Grid(10 ✕ (10 ✕ "•")) }
    
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
    
    public static func addMineCount(grid: Grid) -> Grid {
        
        for r in grid.rowRange {
            
            for c in grid.colRange {
                
                guard let g1 = grid[r,c] as? String else { continue }
                guard g1 != "•" else { continue }
            
                let mines = mineCount((r,c), grid)
                
                grid[r,c] = mines == 0 ? " " : "\(mines)"
                
            }
            
        }
        
        return grid
        
    }
    
    public static func mineCount(s1: Square, _ grid: Grid) -> Int {
        
        var count = 0
        
        let adjacent2 = [ (-1,-1),(-1,0),(-1,1),(0,1),(1,1),(1,0),(1,-1),(0,-1) ]
        
        for a in adjacent2 {
            
            let s = (s1.0 + a.0, s1.1 + a.1)
            guard grid.onBoard(s) else { continue }
            guard let a1 = grid[s.0,s.1] as? String else { continue }
            if a1 == "•" { count += 1 }
        
        }
        
        return count
        
    }
    
}
