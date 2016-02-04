import UIKit

var go = Gameboard(.Go)

// collection of guesses

let moves: [Square] = [
    
    // moves
    (1,1),
    (6,7),
    (1,7),
    (6,0)
    
]

// loop moves

for move in moves {
    
    do {
        
        try go.move(toSquare: move)
        
    } catch {
        
        print(error)
        
    }
    
}

go.visualize()
