import SwiftUI

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
    public static let playerColors = [Color.white, Color.black]
    
}
