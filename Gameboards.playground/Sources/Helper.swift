import UIKit

extension Gameboard {
    
    public mutating func showAvailable(_ s1: Square) {
        
        highlights = []
        
        switch _type {
        
        case .chess, .checkers:
            
            selected = nil
            
            for r in grid.rowRange {
                
                for c in grid.colRange {
                    
                    guard let _ = try? validateMove(s1, (r,c), true) else { continue }
                    selected = s1
                    highlights.append((r,c))
                    
                }
                
            }
            
        default: break
            
        }
        
    }
    
    public mutating func showAvailable(_ s1: ChessSquare) {
        
        let cols: [String] = "abcdefgh".map { "\($0)" }
        guard let c1 = cols.index(of: s1.0) else { return }
        let r1 = 8 - s1.1
        
        showAvailable((r1,c1))
        
    }
    
}
