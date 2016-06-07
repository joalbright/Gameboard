import UIKit

public struct Sudoku {
    
    public static var board: Grid {
                
        let grid = Grid([
            
            "123456789".array(),
            "456789123".array(),
            "789123456".array(),
            "234567891".array(),
            "567891234".array(),
            "891234567".array(),
            "345678912".array(),
            "678912345".array(),
            "912345678".array()
            
        ])
        
        return randomize(grid)
        
    }
    
    public static var staticboard: Grid {
        
        let grid = Grid([
            
            "123456789".array(),
            "456789123".array(),
            "789123456".array(),
            "234567891".array(),
            "567891234".array(),
            "891234567".array(),
            "345678912".array(),
            "678912345".array(),
            "912345678".array()
            
            ])
        
        return Grid([ grid[6], grid[8], grid[7], grid[1], grid[0], grid[2], grid[5], grid[3], grid[4] ])
        
    }
    
    public static let playerPieces = ["123456789"]
    
    public static func validateGuess(s1: Square, _ g1: Guess, _ grid: Grid, _ solution: Grid) throws {
        
        guard g1 != "" else { throw MoveError.InvalidMove }
        guard let a1 = solution[s1.0,s1.1] as? Guess else { throw MoveError.IncorrectPiece }
        
        print(a1)
        print(g1)
        
        guard a1 == g1 else { throw MoveError.IncorrectGuess }
        
        grid[s1.0,s1.1] = g1
        
    }
    
    static func randomize(grid: Grid) -> Grid {
        
        var grid = grid
        
        for _ in 0...2 {
            
            let g1 = [grid[0],grid[1],grid[2]].randomize()
            let g2 = [grid[3],grid[4],grid[5]].randomize()
            let g3 = [grid[6],grid[7],grid[8]].randomize()
            
            grid = Grid([ g1[0], g1[1], g1[2], g2[0], g2[1], g2[2], g3[0], g3[1], g3[2] ])
            
            grid = flipGrid(grid)
            
        }
        
        return grid
        
    }
    
    static func flipGrid(grid: Grid) -> Grid {
        
        let newGrid = Grid(9 ✕ (9 ✕ ""))
        
        for r in newGrid.rowRange {
            
            for c in newGrid.colRange {
                
                newGrid[c,r] = grid[r,c]
                
            }
            
        }
        
        return newGrid
        
    }
    
    static func puzzle(grid: Grid) -> Grid {
        
        let grid = Grid(grid.content)
        
        for r in 0...8 {
            
            var cols = [0,1,2,3,4,5,6,7,8].randomize()
            
            cols.removeRange(3...5)
            
            for c in cols {
                
                grid[r,c] = ""
                
            }
            
        }
        
        return grid
        
    }
    
    static func staticpuzzle(grid: Grid) -> Grid {
        
        let grid = Grid(grid.content)
        
        let hide = [
        
            [0,2,3,4,6,7],
            [0,1,3,6,7,8],
            [1,2,3,5,6,7],
            [0,1,2,4,5,8],
            [0,1,4,6,7,8],
            [2,3,4,5,7,8],
            [0,1,2,5,6,7],
            [0,3,4,5,6,8],
            [1,3,4,6,7,8]
        
        ]
        
        for (r,row) in hide.enumerate() {
            
            for c in row {
                
                grid[r,c] = ""
                
            }
            
        }
        
        return grid
        
    }
    
}
