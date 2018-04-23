import UIKit

public struct Words {
    
    public enum PieceType: String {
        
        static var all: [PieceType] { return [.start,.doubleword,.doubleletter,.tripleword,.tripleletter] }
        static var names: [String] { return all.map { $0.rawValue } }
        
        case empty = " "
        case start = "★"
        case doubleword = "DW"
        case tripleword = "TW"
        case doubleletter = "DL"
        case tripleletter = "TL"
        
        var backgroundColor: UIColor {
            
            switch self {
            case .empty: return .clear
            case .start: return #colorLiteral(red: 0.4582899487, green: 0.1780638536, blue: 0.4886863426, alpha: 1)
            case .doubleletter: return #colorLiteral(red: 0.0121835285, green: 0.524357516, blue: 0.8901960784, alpha: 1)
            case .tripleletter: return #colorLiteral(red: 0.1972305775, green: 0.7161869407, blue: 0.3783127069, alpha: 1)
            case .doubleword: return #colorLiteral(red: 0.8, green: 0, blue: 0.2666666667, alpha: 1)
            case .tripleword: return #colorLiteral(red: 0.968627451, green: 0.5960784314, blue: 0.2666666667, alpha: 1)
            }
            
        }
        
        var textColor: UIColor { return .white }
        
    }
    
    public static var board: Grid {
        
        let grid = Grid([
        
            [" "," "," ","TW"," "," ","TL"," ","TL"," "," ","TW"," "," "," "],
            [" "," ","DL"," "," ","DW"," "," "," ","DW"," "," ","DL"," "," "],
            [" ","DL"," "," ","DL"," "," "," "," "," ","DL"," "," ","DL"," "],
            ["TW"," "," ","TL"," "," "," ","DW"," "," "," ","TL"," "," ","TW"],
            [" "," ","DL"," "," "," ","DL"," ","DL"," "," "," ","DL"," "," "],
            [" ","DW"," "," "," ","TL"," "," "," ","TL"," "," "," ","DW"," "],
            ["TL"," "," "," ","DL"," "," "," "," "," ","DL"," "," "," ","TL"],
            [" "," "," ","DW"," "," "," ","★"," "," "," ","DW"," "," "," "],
            ["TL"," "," "," ","DL"," "," "," "," "," ","DL"," "," "," ","TL"],
            [" ","DW"," "," "," ","TL"," "," "," ","TL"," "," "," ","DW"," "],
            [" "," ","DL"," "," "," ","DL"," ","DL"," "," "," ","DL"," "," "],
            ["TW"," "," ","TL"," "," "," "," "," "," "," ","TL"," "," ","TW"],
            [" ","DL"," "," ","DL"," "," "," "," "," ","DL"," "," ","DL"," "],
            [" "," ","DL"," "," ","DW"," "," "," ","DW"," "," ","DL"," "," "],
            [" "," "," ","TW"," "," ","TL"," ","TL"," "," ","TW"," "," "," "]
        
        ])
        
        
        return grid
        
    }
    
    public static let playerPieces = ["ABCDEFGHIJKLMNOPQRSTUVWXYZ","ABCDEFGHIJKLMNOPQRSTUVWXYZ"]

}
