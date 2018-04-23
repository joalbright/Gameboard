import UIKit

public struct ConnectFour {
    
    public static var board: Grid { return Grid(6 ✕ (7 ✕ "")) }
    
    public static let playerPieces = ["◉","◎"]

    public static var staticboard: Grid {
        
        return Grid([
            
            7 ✕ "",
            7 ✕ "",
            "     ◎ ".array(),
            "     ◉ ".array(),
            "    ◎◉ ".array(),
            "   ◎◉◉ ".array()
            
        ])
        
    }
    
}
