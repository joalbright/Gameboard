import UIKit


var chess = GameBoard(.Chess)

// history of moves

// current move

do {
    
    try chess.move(pieceAt: ("b",7), toSquare: ("b",5))
    
} catch {
    
    error
    
}

do {
    
    try chess.move(pieceAt: ("c",2), toSquare: ("c",4))
    
} catch {
    
    error
    
}

do {
    
    try chess.move(pieceAt: ("b",5), toSquare: ("c",4))
    
} catch {
    
    error
    
}


chess.visualize()

