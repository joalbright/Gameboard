import UIKit

var checkers = GameBoard(.Checkers)

// history of moves

// current move

do {

    try checkers.move(pieceAt: (2,1), toSquare: (1,0))

} catch {

    error
        
}


checkers.visualize()









