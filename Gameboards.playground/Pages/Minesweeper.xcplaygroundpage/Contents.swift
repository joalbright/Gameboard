import UIKit

enum MoveType { case Guess, Mark }

var minesweeper = Gameboard(.Minesweeper)

// setup colors

var colors = BoardColors()

colors.background = UIColor(red:0.5, green:0.5, blue:0.5, alpha:1)
colors.foreground = UIColor(red:0.6, green:0.6, blue:0.6, alpha:1)

colors.player1 = UIColor.yellowColor()
colors.player2 = UIColor.blackColor()

colors.highlight = UIColor.blueColor()
colors.selected = UIColor.redColor()

minesweeper.boardColors = colors

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

// loop guesses

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
