import UIKit

var sudoku = Gameboard(.Sudoku)

// collection of guesses

let guesses: [(Square,Guess)] = [
    
    // guesses
    ((0,2),"5"),
    ((8,8),"4"),
    ((6,5),"4"),
    ((2,7),"4"),
    ((3,0),"4"),
    ((5,3),"1"),
    ((6,2),"1"),
    ((7,8),"1"),
    ((2,5),"2"),
    
]

// loop moves

for guess in guesses {
    
    do {
        
        try sudoku.guess(toSquare: guess.0, withGuess: guess.1)
        
    } catch {
        
        print(error)
        
    }
    
}

 
sudoku.visualize(CGRect(x: 0, y: 0, width: 198, height: 198))




