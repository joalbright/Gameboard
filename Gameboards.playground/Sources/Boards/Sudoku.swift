import UIKit

extension Difficulty {
    
    var sudokuRange: CountableClosedRange<Int> {
        
        switch self {
        case .easy: return 2...6
        case .medium: return 3...5
        case .hard: return 4...4
        }
        
    }
    
}

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
    
    public static func validateGuess(_ s1: Square, _ g1: Guess, _ grid: Grid, _ solution: Grid) throws {
        
        guard g1 != "" else { throw MoveError.invalidmove }
        guard let a1 = solution[s1.0,s1.1] as? Guess else { throw MoveError.incorrectpiece }
        
        print(a1)
        print(g1)
        
        guard a1 == g1 else { throw MoveError.incorrectguess }
        
        grid[s1.0,s1.1] = g1
        
    }
    
    static func randomize(_ grid: Grid) -> Grid {
        
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
    
    static func flipGrid(_ grid: Grid) -> Grid {
        
        let newGrid = Grid(9 ✕ (9 ✕ ""))
        
        for r in newGrid.rowRange {
            
            for c in newGrid.colRange {
                
                newGrid[c,r] = grid[r,c]
                
            }
            
        }
        
        return newGrid
        
    }
    
    static func puzzle(_ grid: Grid, difficulty: Difficulty) -> Grid {
        
        let grid = Grid(grid.content)
        
        for r in 0...8 {
            
            var cols = [0,1,2,3,4,5,6,7,8].randomize()
            
            cols.removeSubrange(difficulty.sudokuRange)
            
            for c in cols {
                
                grid[r,c] = ""
                
            }
            
        }
        
        return grid
        
    }
    
    static func staticpuzzle(_ grid: Grid) -> Grid {
        
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
        
        for (r,row) in hide.enumerated() {
            
            for c in row {
                
                grid[r,c] = ""
                
            }
            
        }
        
        return grid
        
    }
    
}

extension Grid {
    
    public func sudoku(_ rect: CGRect, highlights: [Square]) -> UIView {
        
        let view = SudokuView(frame: rect)
        
        view.backgroundColor = colors.background
        view.lineColor = colors.foreground
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let w = rect.width / content.count
        let h = rect.height / content.count
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {
                
                let label = UILabel(frame: CGRect(x: c * w, y: r * h, width: w, height: h))
                
                label.text = "\(item)"
                label.textAlignment = .center
                label.font = .systemFont(ofSize: (w + h) / 2 - 15, weight: .regular)
                label.textColor = colors.foreground
                
                for highlight in highlights {
                    
                    guard highlight.0 == r && highlight.1 == c else { continue }
                    label.textColor = colors.highlight
                    label.backgroundColor = colors.foreground
                    
                }
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
}
