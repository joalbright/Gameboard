import UIKit

public struct Bombsweeper {
    
    public static var board: Grid {

        // randomize play area
        
        let grid = Grid(10 ✕ (10 ✕ " "))
        
        for (r,_) in grid.content.enumerated() { grid[r,4] = "•" }
        for (r,row) in grid.content.enumerated() { grid[r] = row.randomize().randomize().randomize() }

        return addBombCount(grid)

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
    
    public static var field: Grid { return Grid(10 ✕ (10 ✕ "•")) }
    
    public static let playerPieces = ["⚑","✘","⚐"]
    
    public static func validateGuess(_ s1: Square, _ grid: Grid, _ solution: Grid) throws {
        
        guard let a1 = solution[s1.0,s1.1] as? Guess else { throw MoveError.incorrectpiece }
        guard a1 != "⚑" else { throw MoveError.invalidmove }
        
        grid[s1.0,s1.1] = a1
        
        guard a1 != "•" else { grid[s1.0,s1.1] = "✘"; throw GameStatus.gameover }
        guard a1 == " " else { return }
                
        try checkAdjacent(s1, grid, solution)
        
    }
    
    public static func validateMark(_ s1: Square, _ grid: Grid, _ solution: Grid) throws {
        
        guard let g1 = grid[s1.0,s1.1] as? Guess else { throw MoveError.incorrectpiece }
        
        guard !["⚑","⚐"].contains(g1) else { return grid[s1.0,s1.1] = g1 == "⚑" ? "•" : " " }
        
        grid[s1.0,s1.1] = g1 == "•" ? "⚑" : "⚐"
        
    }
    
    public static func checkAdjacent(_ s1: Square, _ grid: Grid, _ solution: Grid) throws {
        
        let adjacent2 = [ (-1,-1),(-1,0),(-1,1),(0,1),(1,1),(1,0),(1,-1),(0,-1) ]
        
        for a in adjacent2 {
            
            let s = (s1.0 + a.0, s1.1 + a.1)
            guard grid.onBoard(s) else { continue }
            guard let a1 = solution[s.0,s.1] as? String, let g1 = grid[s.0,s.1] as? String, g1 != a1 else { continue }
            
            grid[s.0,s.1] = a1
            
            guard a1 == " " else { continue }
            
            try checkAdjacent(s, grid, solution)
            
        }
        
    }
    
    public static func addBombCount(_ grid: Grid) -> Grid {
        
        for r in grid.rowRange {
            
            for c in grid.colRange {
                
                guard let g1 = grid[r,c] as? String else { continue }
                guard g1 != "•" else { continue }
            
                let bombs = bombCount((r,c), grid)
                
                grid[r,c] = bombs == 0 ? " " : "\(bombs)"
                
            }
            
        }
        
        return grid
        
    }
    
    public static func bombCount(_ s1: Square, _ grid: Grid) -> Int {
        
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

extension Grid {
    
    public func bomb(_ rect: CGRect) -> UIView {
        
        let view = UIView(frame: rect)
        
        view.backgroundColor = colors.background
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let w = (rect.width - content.count + 1) / content.count
        let h = (rect.height - content.count + 1) / content.count
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {
                
                let label = UILabel(frame: CGRect(x: c * w + c, y: r * h + r, width: w, height: h))
                let piece = "\(item)"
                
                label.text = player(piece) == 2 ? playerPieces[0] : piece
                label.textAlignment = .center
                label.font = .systemFont(ofSize: (w + h) / 2 - 10, weight: .regular)
                
                label.textColor = [0,2].contains(player(piece)) ? colors.player1 : colors.player2
                label.backgroundColor = player(piece) == 1 ? colors.selected : colors.background
                
                if piece == "•" {
                    
                    label.textColor = colors.foreground
                    label.backgroundColor = colors.foreground
                    
                }
                
                if let num = Int("\(item)"), num > 0 { label.textColor = colors.highlight }
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
}
