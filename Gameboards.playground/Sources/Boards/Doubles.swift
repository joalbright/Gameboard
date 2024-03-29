import UIKit

public struct Doubles {
    
    public static var board: Grid { return Grid(4 ✕ (4 ✕ EmptyPiece)) }
    
    public static let playerPieces: [String] = []
    
    public static var staticboard: Grid {
        
        return Grid([
        
            "  2 ".array(),
            "    ".array(),
            "   8".array(),
            [EmptyPiece,EmptyPiece,"16","128"],
            
        ])
        
    }
    
    public static func validateMove(_ s1: Square, _ s2: Square, _ p1: Piece, _ p2: Piece, _ grid: Grid) throws -> Piece? {
        
        guard p1 != EmptyPiece && (p1 == p2 || p2 == EmptyPiece) else { throw MoveError.invalidmove }
        
        let double = "\((Int(p1) ?? 0) + (Int(p2) ?? 0))"
        
        grid[s2.0][s2.1] = p2 == EmptyPiece ? p1 : double
        grid[s1.0][s1.1] = EmptyPiece // remove initial piece
        
        return p1 == p2 && p1 != EmptyPiece ? double : nil
        
    }
    
    public static func random(_ grid: Grid) -> Bool {
        
        let c = Int(arc4random_uniform(4))
        let r = Int(arc4random_uniform(4))
        
        guard EmptyPiece == grid[c][r] else { return random(grid) }
        
        grid[c][r] = "2"
        
        return true
        
    }
    
}

extension String {
    
    var doublesColor: UIColor {
        
        switch self {
            
        case "2": return #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        case "4": return #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        case "8": return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        case "16": return #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        case "32": return #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        case "64": return #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        case "128": return #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        case "256": return #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        case "512": return #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        case "1024": return #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        case "2048": return #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        case "4096": return #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        default: return .clear
            
        }
        
    }
    
}

extension Grid {
    
    public func doubles(_ rect: CGRect) -> UIView {
        
        let view = UIView(frame: rect)
        
        view.backgroundColor = colors.background
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let w = (rect.width - padding * 2) / 4
        let h = (rect.height - padding * 2) / 4
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {

                let piece = "\(item)"

                let holder = UIView(frame: CGRect(x: c * w + padding, y: r * h + padding, width: w, height: h).insetBy(dx: 2, dy: 2))
                holder.backgroundColor = piece == EmptyPiece ? colors.foreground : piece.doublesColor
                holder.layer.cornerRadius = 10
                holder.layer.masksToBounds = true
                
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: w - 4, height: h - 4))
                label.backgroundColor = .clear
                label.text = piece
                label.textAlignment = .center
                label.font = .systemFont(ofSize: (w + h) / 4 - 5, weight: .heavy)
                label.textColor = colors.player1
                label.adjustsFontSizeToFitWidth = true
                
                holder.addSubview(label)
                view.addSubview(holder)
                
            }
            
        }
        
        return view
        
    }
    
}
