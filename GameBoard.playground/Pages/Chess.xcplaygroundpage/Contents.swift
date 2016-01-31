import UIKit


var chess = GameBoard(.Chess)

// collection of moves

let moves: [(ChessSquare,ChessSquare)] = [
    
    (B7,B5),
    (C2,C4),
    (B5,C4),
    (B1,C3),
    (C8,A6),
    (E2,E4),
    (G7,G6),
    (F1,C4),
    (A6,C4)
    
]

// loop moves

for move in moves {
    
    do {
        
        try chess.move(pieceAt: move.0, toSquare: move.1)
        
    } catch {
        
        error
    
    }
    
}


chess.visualize()

