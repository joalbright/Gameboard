import UIKit

var go = Gameboard(.Go)

// collection of guesses

let moves: [Square] = [
    
    // moves
    
]

// loop moves

for move in moves {
    
    do {
        
        try sudoku.guess(toSquare: move)
        
    } catch {
        
        print(error)
        
    }
    
}

go.visualize()