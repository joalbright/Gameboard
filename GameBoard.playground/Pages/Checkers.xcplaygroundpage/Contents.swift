import UIKit

var checkers = GameBoard(.Checkers)

// collection of moves

let moves: [(Square,Square)] = [

    ((2,1),(3,2)),
    ((5,2),(4,3)),
    ((2,3),(3,4)),
    ((4,3),(2,1)),

]

// loop moves

for move in moves {
    
    do {
        
        try checkers.move(pieceAt: move.0, toSquare: move.1)
    
    } catch {
        
        error
    
    }
    
}


checkers.visualize()









