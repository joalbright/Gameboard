import UIKit

var chess = Gameboard(.Chess)

// collection of moves

let moves: [(ChessSquare,ChessSquare)] = [
    
    (B7,B5), // pawn leaps
    (C2,C4), // pawn leaps
    (B5,C4), // pawn takes pawn
    (B1,C3), // knight charges
    (C8,A6), // bishop advances
    (E2,E4), // pawn leaps
    (G7,G6), // pawn creeps
    (F1,C4), // bishop take pawn
    (A6,D3), // blocked move throws error
    
]

// loop moves

for move in moves {
    
    do {
        
        try chess.move(pieceAt: move.0, toSquare: move.1)
        
    } catch {
        
        print(error)
    
    }
    
}


chess.visualize()

