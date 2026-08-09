import Foundation

public struct Mancala {
    
    public static var board: Grid {
        
        return Grid([
            
            ["3","0","3"],
            ["3"," ","3"],
            ["3"," ","3"],
            ["3"," ","3"],
            ["3"," ","3"],
            ["3","0","3"]
            
        ])
        
    }
    
    public static let playerPieces = ["123456789","123456789"]
    
    public static var staticboard: Grid {
        
        return Grid([
            
            ["0","3","4"],
            ["4"," ","4"],
            ["0"," ","3"],
            ["3"," ","0"],
            ["4"," ","1"],
            ["5","4","1"]
            
        ])
        
    }

}
