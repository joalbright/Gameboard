import UIKit

public struct Battleship {
    
    public enum PieceType: String {
        
        case carrier
        case battleship
        case cruiser
        case destoyer
        
        var horizontal: String {
            
            switch self {
                
            case .carrier: return "◀︎◼︎◼︎◼︎▶︎"
            case .battleship: return "◀︎◼︎◼︎▶︎"
            case .cruiser: return "◀︎◼︎▶︎"
            case .destoyer: return "◀︎▶︎"
                
            }
            
        }
        
        var vertical: String {
            
            switch self {
                
            case .carrier: return "▲◼︎◼︎◼︎▼"
            case .battleship: return "▲◼︎◼︎▼"
            case .cruiser: return "▲◼︎▼"
            case .destoyer: return "▲▼"
                
            }
            
        }
        
    }
    
    public static var board: Grid { return Grid(6 ✕ (7 ✕ "")) }
    
    public static let playerPieces = ["",""]

}
