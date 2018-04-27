import UIKit

public struct Ludo {
    
    public static var board: Grid {
        
        return Grid([
            
            5 ✕ "●",
            5 ✕ "●",
            "●● ○○".array(),
            5 ✕ "○",
            5 ✕ "○",
            
        ])
        
    }
    
    public static let playerPieces = ["●","○"]

}
