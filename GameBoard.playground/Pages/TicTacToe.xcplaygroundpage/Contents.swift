import UIKit

var tictactoe = GameBoard(.TicTacToe)

// collection of moves

let moves: [Square] = [
 
    (1,1),
    (0,0),
    (0,2),
    (2,0),
    (1,0),
    (1,2),
    (0,1),
    (1,1), // cant play filled spot
    (2,1),
    (2,2), // stalemate
    
]

// loop moves

for move in moves {
    
    do {
        
        try tictactoe.move(toSquare: move)
        
    } catch {
        
        error
        
    }
    
}


tictactoe.visualize()

