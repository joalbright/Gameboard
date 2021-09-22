import UIKit

enum GoError: Error {
    
    case openchain
    
}

public struct Go {
    
    public static var board: Grid { return Grid(9 ✕ (9 ✕ EmptyPiece)) }
    
    public static let playerPieces = ["●","○"]
    
    public static func checkCapture(_ s1: Square, _ p1: Piece, _ grid: Grid) {
        
        let points = [ (-1,0),(0,1),(1,0),(0,-1) ]
        
        func checkChain(_ s1: Square, _ chain: [Square]) throws -> [Square] {
            
            var chain = chain
            
            var squares = [s1]
            
            for p in points {
                
                let s = (s1.0 + p.0, s1.1 + p.1)

                guard !(chain.contains { $0.0 == s.0 && $0.1 == s.1 }) else { continue }
                guard grid.onBoard(s) else { continue }

                let a1 = grid[s.0,s.1]

                guard a1 != p1 else { continue }
                guard a1 != EmptyPiece else { throw GoError.openchain }
                
                chain.append(s)
                
                do { squares += try checkChain(s, chain) } catch { throw error }
                
            }
            
            return squares
            
        }
        
        for p in points {
            
            let s = (s1.0 + p.0, s1.1 + p.1)

            guard grid.onBoard(s) else { continue }

            let a1 = grid[s.0,s.1]

            guard a1 != EmptyPiece && a1 != p1 else { continue }
            
            if let squares = try? checkChain(s, [s]) {
                
                for s in squares { grid[s.0,s.1] = EmptyPiece }
                
            }
            
        }
        
    }
    
    public static func validateMove(_ s1: Square, _ p1: Piece, _ grid: Grid, _ player: Int) throws {
        
        guard p1 == EmptyPiece else { throw MoveError.invalidmove }
        
        grid[s1.0,s1.1] = playerPieces[player]
        
        checkCapture(s1, playerPieces[player], grid)
        
    }
    
}

extension Grid {
    
    public func go(_ rect: CGRect) -> UIView {
        
        let view = GoView(frame: rect)
        
        view.p = padding
        view.backgroundColor = colors.background
        view.lineColor = colors.foreground
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let w = (rect.width - padding * 2) / 8
        let h = (rect.height - padding * 2) / 8
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {

                var piece = "\(item)"

                let label = UILabel(frame: CGRect(x: c * w + padding - w / 2, y: r * h + padding - h / 2, width: w, height: h))
                label.textColor = player(piece) == 0 ? colors.player1 : colors.player2
                
                if player(piece) == 1 {
                    
                    if let index = playerPieces[1].array().index(of: piece) { piece = playerPieces[0].array()[index] }
                    
                }
                
                label.text = piece
                label.textAlignment = .center
                label.font = .systemFont(ofSize: (w + h) / 2, weight: .thin)
                
                view.addSubview(label)
                
                
            }
            
        }
        
        return view
        
    }
    
}
