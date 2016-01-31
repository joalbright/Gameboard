import UIKit


var chess = GameBoard(.Chess)

// history of moves
let moves: [(ChessSquare,ChessSquare)] = [
    
    (B7,B5),
    (C2,C4),
    (B5,C5)
    
]

// current move


chess.visualize()

