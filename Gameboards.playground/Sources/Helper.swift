import UIKit

extension Gameboard {
    
    public mutating func showAvailable(s1: Square) {
        
        highlights = []
        
        switch _type {
            
        case .Go, .Mancala, .Minesweeper, .Sudoku, .TicTacToe: break
            
        case .Chess, .Checkers:
            
            selected = nil
            
            for r in grid.rowRange {
                
                for c in grid.colRange {
                    
                    guard let _ = try? validateMove(s1, (r,c), true) else { continue }
                    selected = s1
                    highlights.append((r,c))
                    
                }
                
            }
            
        }
        
    }
    
    public mutating func showAvailable(s1: ChessSquare) {
        
        let cols: [String] = "abcdefgh".characters.map { "\($0)" }
        guard let c1 = cols.indexOf(s1.0) else { return }
        let r1 = 8 - s1.1
        
        showAvailable((r1,c1))
        
    }
    
}
