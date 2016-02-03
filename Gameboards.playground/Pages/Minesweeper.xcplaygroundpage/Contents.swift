import UIKit

enum MoveType { case Guess, Mark }

var minesweeper = Gameboard(.Minesweeper)

// collection of guesses

let guesses: [(Square,MoveType)] = [
    
    ((4,3),.Guess), // guess
    ((9,0),.Mark),  // mark
    ((7,4),.Mark),  // mark
    ((4,1),.Mark),  // mark
    ((4,0),.Guess), // guess
    ((0,9),.Guess), // guess
    ((2,7),.Mark), // guess
    ((6,9),.Guess), // guess
    ((1,0),.Guess), // game over
    
]

// loop moves

for guess in guesses {
    
    do {
        
        switch guess.1 {
            
        case .Guess: try minesweeper.guess(toSquare: guess.0)
        case .Mark: try minesweeper.mark(toSquare: guess.0)
            
        }
        
    } catch {
        
        print(error)
        
    }
    
}

minesweeper.visualize(CGRect(x: 0, y: 0, width: 199, height: 199))
