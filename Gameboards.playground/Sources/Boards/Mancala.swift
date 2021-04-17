import UIKit

public struct Mancala {
    
    public static var board: Grid {
        
        return Grid([
            
            "333333".array(),
            "333333".array(),
            "000000".array(),
            "000000".array(),
            "333333".array(),
            "333333".array()
            
        ])
        
    }
    
    public static let playerPieces = ["123456789","123456789"]
    
    public static var staticboard: Grid {
        
        return Grid([
            
            "341433".array(),
            "345033".array(),
            "000000".array(),
            "000001".array(),
            "333444".array(),
            "330404".array()
            
        ])
        
    }

}
