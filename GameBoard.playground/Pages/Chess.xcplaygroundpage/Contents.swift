import UIKit


var chess = GameBoard(.Chess)

// history of moves

// current move
chess.move(pieceAt: ("b",7), toSquare: ("b",6))

chess.visualize()

