import UIKit

public struct Four {
    
    public static var board: Grid { return Grid(6 ✕ (7 ✕ " ")) }
    
    public static let playerPieces = ["◉","◎"]

    public static var staticboard: Grid {
        
        return Grid([
            
            7 ✕ " ",
            7 ✕ " ",
            "     ◎ ".array(),
            "     ◉ ".array(),
            "    ◎◉ ".array(),
            "   ◎◉◉ ".array()
            
        ])
        
    }
    
    public static func validateDrop(_ s1: Square, _ p1: Piece, _ grid: Grid) throws {
     
        guard let piece = grid[s1.0 + 1][s1.1] as? Piece, piece == " " else { throw MoveError.invalidmove }
        grid[s1.0 + 1][s1.1] = p1
        
        guard grid.onBoard(s1) else { return }
        grid[s1.0][s1.1] = " "
        
    }
    
}

extension Grid {
    
    public func four(_ rect: CGRect) -> UIView {
        
        let view = FourView(frame: rect)
        
        let w = (rect.width - padding * 2) / 7
        let h = (rect.height - padding * 2) / 7
        
        view.backgroundColor = colors.foreground
        view.holeColor = colors.background
        view.spotColor = colors.selected
        
        view.p = padding
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {

                var piece = "\(item)"

                let label = UILabel(frame: CGRect(x: c * w + padding, y: r * h + padding + h, width: w, height: h))
                label.textColor = player(piece) == 0 ? colors.player1 : colors.player2
                
                if player(piece) == 1 {
                    
                    if let index = playerPieces[1].array().index(of: piece) { piece = playerPieces[0].array()[index] }
                    
                }
                
                label.text = piece
                label.textAlignment = .center
                label.font = .systemFont(ofSize: (w + h) / 2 - 10, weight: .regular)
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
}
