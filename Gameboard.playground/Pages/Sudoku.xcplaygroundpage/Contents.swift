import UIKit

var sudoku = Gameboard(.Sudoku)

// collection of guesses

let guesses: [(Square,Guess)] = [
    
    // guesses
    
]

// loop moves

for guess in guesses {
    
    do {
        
        try sudoku.guess(toSquare: guess.0, withGuess: guess.1)
        
    } catch {
        
        print(error)
        
    }
    
}


sudoku.visualize()




