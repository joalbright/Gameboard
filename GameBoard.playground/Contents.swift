import UIKit


var chess = GameBoard(.Chess)

// history of moves
chess.move(pieceAt: (1,1), toSquare: (3,1))


// current move

chess.visualize()

