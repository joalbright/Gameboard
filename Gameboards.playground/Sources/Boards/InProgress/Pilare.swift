import UIKit

public struct Pilare {
    
    public static var board: Grid {
        
        return Grid([
        
            6 ✕ "∙●",
            ["∙●","∙","∙","∙","∙","∙●"],
            ["∙●","∙","∙","∙","∙","∙●"],
            ["∙○","∙","∙","∙","∙","∙○"],
            ["∙○","∙","∙","∙","∙","∙○"],
            6 ✕ "∙○"
        
        ])
        
        
    }
    
    public static let playerPieces = ["●","○"]

}
