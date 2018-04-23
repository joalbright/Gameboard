import UIKit

public struct Backgammon {
    
    public static var board: Grid {
        
        return Grid([
        
            "●   ○ ○    ●".array(),
            "●   ○ ○    ●".array(),
            "●   ○ ○     ".array(),
            "●     ○     ".array(),
            "●     ○     ".array(),
            "○     ●     ".array(),
            "○     ●     ".array(),
            "○   ● ●     ".array(),
            "○   ● ●    ○".array(),
            "○   ● ●    ○".array()
            
        ])
                
    }
    
    public static let playerPieces = ["●","○"]
    
}
