import UIKit

public struct TicTacToe {
    
    public static var board: Grid { return Grid(3 ✕ (3 ✕ "")) }
    
    public static let playerPieces = ["○","✕"]
    
    public static func validateMove(_ s1: Square, _ p1: Piece, _ grid: Grid, _ player: Int) throws {
        
        guard p1 == "" else { throw MoveError.invalidmove }
        
        grid[s1.0,s1.1] = playerPieces[player] // place my piece in target square
        
    }
    
}

extension Grid {
    
    public func ttt(_ rect: CGRect) -> UIView {
        
        let view = TicTacToeView(frame: rect)
        
        view.p = padding
        view.backgroundColor = colors.background
        view.lineColor = colors.foreground
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let w = (rect.width - padding * 2) / content.count
        let h = (rect.height - padding * 2) / content.count
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {

                let piece = "\(item)"

                let label = UILabel(frame: CGRect(x: c * w + padding, y: r * h + padding, width: w, height: h))
                label.text = piece
                label.textAlignment = .center
                label.font = .systemFont(ofSize: (w + h) / 2 - 10, weight: .thin)
                label.textColor = player(piece) == 0 ? colors.player1 : colors.player2
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
}
