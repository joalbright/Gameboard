import Foundation

extension Difficulty {

    var bombFlags: Int {

        switch self {
        case .easy: return 20
        case .medium: return 20
        case .hard: return 20
        }

    }

    var bombs: Int {

        switch self {
        case .easy: return 10
        case .medium: return 15
        case .hard: return 20
        }

    }

    var bombsize: Int {

        switch self {
        case .easy: return 10
        case .medium: return 15
        case .hard: return 20
        }

    }

}

public struct Bombsweeper {
    
    public static var board: Grid { return board(.easy) }

    static func board(_ difficulty: Difficulty) -> Grid {

        let size = difficulty.bombsize
        let emptyCount = size * size - difficulty.bombs
        let pieces = ((difficulty.bombs ✕ "•") + (emptyCount ✕ " ")).randomize().randomize().randomize()
        let content = (0..<size).map { row in Array(pieces[(row * size)..<((row + 1) * size)]) }

        return addBombCount(Grid(content))

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

        return addBombCount(grid)
        
    }
    
    public static var field: Grid { return field(.easy) }

    static func field(_ difficulty: Difficulty) -> Grid {

        return Grid(difficulty.bombsize ✕ (difficulty.bombsize ✕ "•"))

    }
    
    public static let playerPieces = ["⚑","✘","⚐"]
    
    public static func validateGuess(_ s1: Square, _ grid: inout Grid, _ solution: Grid) throws {
        
        let a1 = solution[s1.0,s1.1]
        guard a1 != "⚑" else { throw MoveError.invalidmove }
        
        grid[s1.0,s1.1] = a1
        
        guard a1 != "•" else { grid[s1.0,s1.1] = "✘"; throw GameStatus.gameover }
        guard a1 == " " else { return }
                
        try checkAdjacent(s1, &grid, solution)
        
    }
    
    public static func validateMark(_ s1: Square, _ grid: inout Grid, _ solution: Grid) throws {
        
        let g1 = grid[s1.0,s1.1]
        guard ["⚑","•"].contains(g1) else { throw MoveError.invalidmove }
        
        grid[s1.0,s1.1] = g1 == "•" ? "⚑" : "•"
        
    }
    
    public static func checkAdjacent(_ s1: Square, _ grid: inout Grid, _ solution: Grid) throws {
        
        let adjacent = [ (-1,-1),(-1,0),(-1,1),(0,1),(1,1),(1,0),(1,-1),(0,-1) ]
        
        for a in adjacent {
            
            let s = (s1.0 + a.0, s1.1 + a.1)
            guard grid.onBoard(s) else { continue }
            let a1 = solution[s.0,s.1]
            let g1 = grid[s.0,s.1]
            guard g1 != a1 else { continue }
            
            grid[s.0,s.1] = a1
            
            guard a1 == " " else { continue }
            
            try checkAdjacent(s, &grid, solution)
            
        }
        
    }
    
    public static func addBombCount(_ grid: Grid) -> Grid {

        var grid = grid
        
        for r in grid.rowRange {
            
            for c in grid.colRange {
                
                let g1 = grid[r,c]
                guard g1 != "•" else { continue }
            
                let bombs = bombCount((r,c), grid)
                
                grid[r,c] = bombs == 0 ? " " : "\(bombs)"
                
            }
            
        }
        
        return grid
        
    }
    
    public static func bombCount(_ s1: Square, _ grid: Grid) -> Int {
        
        var count = 0
        
        let adjacent = [ (-1,-1),(-1,0),(-1,1),(0,1),(1,1),(1,0),(1,-1),(0,-1) ]
        
        for a in adjacent {
            
            let s = (s1.0 + a.0, s1.1 + a.1)
            guard grid.onBoard(s) else { continue }
            let a1 = grid[s.0,s.1]
            if a1 == "•" { count += 1 }
        
        }
        
        return count
        
    }
    
}
