import UIKit

extension Gameboard {
    
    
    public func showAvailable(s1: Square) {
        
//        switch _type {
//            
//        case .Checkers:
//        case .Chess:
//            
//        }
        
    }
    
    public func showAvailable(s1: ChessSquare) {
        
        let cols: [String] = "abcdefgh".characters.map { "\($0)" }
        guard let c1 = cols.indexOf(s1.0) else { return }
        let r1 = 8 - s1.1
        
        showAvailable((r1,c1))
        
    }
    
}
