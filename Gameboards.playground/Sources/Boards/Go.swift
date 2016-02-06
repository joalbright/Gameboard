import UIKit

enum GoError: ErrorType {
    
    case OpenChain
    
}

public struct Go {
    
    public static var board: Grid = Grid(9 ✕ (9 ✕ ""))
    
    public static let playerPieces = ["●","○"]
    
    public static func checkCapture(s1: Square, _ p1: Piece, _ grid: Grid) {
        
        let points = [ (-1,0),(0,1),(1,0),(0,-1) ]
        
        func checkChain(s1: Square, var _ chain: [Square]) throws -> [Square] {
            
            var squares = [s1]
            
            for p in points {
                
                let s = (s1.0 + p.0, s1.1 + p.1)
                guard !(chain.contains { $0.0 == s.0 && $0.1 == s.1 }) else { continue }
                guard grid.onBoard(s) else { continue }
                guard let a1 = grid[s.0,s.1] as? Piece where a1 != p1 else { continue }
                guard a1 != "" else { throw GoError.OpenChain }
                
                chain.append(s)
                print(chain)
                
                do { squares += try checkChain(s, chain) } catch { throw error }
                
            }
            
            return squares
            
        }
        
        for p in points {
            
            let s = (s1.0 + p.0, s1.1 + p.1)
            guard grid.onBoard(s) else { continue }
            guard let a1 = grid[s.0,s.1] as? Piece where a1 != "" && a1 != p1 else { continue }
            
            if let squares = try? checkChain(s, [s]) {
                
                for s in squares { grid[s.0,s.1] = "" }
                
            }
            
        }
        
    }
    
    public static func validateMove(s1: Square, _ p1: Piece, _ grid: Grid, _ player: Int) throws {
        
        guard p1 == "" else { throw MoveError.InvalidMove }
        
        grid[s1.0,s1.1] = playerPieces[player]
        
        checkCapture(s1, playerPieces[player], grid)
        
    }
    
}
