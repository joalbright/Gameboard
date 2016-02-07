# Chess

![Chess](./images/chess.png?raw=true)

```swift
var chess = GameBoard(.Chess)

// setup colors

var colors = BoardColors()

colors.background = UIColor(red:0.52, green:0.68, blue:0.43, alpha:1)
colors.foreground = UIColor(red:0.48, green:0.64, blue:0.39, alpha:1)

colors.player1 = UIColor.whiteColor()
colors.player2 = UIColor.blackColor()

colors.selected = UIColor(red:0.06, green:0.46, blue:0.71, alpha:1)
colors.highlight = UIColor(red:0.06, green:0.46, blue:0.71, alpha:1)

chess.boardColors = colors

// collection of moves

let moves: [(ChessSquare,ChessSquare)] = [
    
    (B7,B5), // pawn leaps
    (C2,C4), // pawn leaps
    (B5,C4), // pawn takes pawn
    (B1,C3), // knight charges
    (C8,A6), // bishop advances
    (E2,E4), // pawn leaps
    (G7,G6), // pawn creeps
    (F1,C4), // bishop take pawn
    (A6,D3), // blocked move throws error
    
]

// loop moves

for move in moves {
    
    do {
        
        try chess.move(pieceAt: move.0, toSquare: move.1)
        
    } catch {
        
        error
    
    }
    
}

// show available moves for a square

chess.showAvailable(A6)

chess.visualize()
```

#### General

- [wikipedia](https://en.wikipedia.org/wiki/Chess)
- [x] Coordinates
	- columns A - H
	- rows 8 - 1
	
#### Validation

- [ ] Win / Lose

- [x] Standard Moves
	- [x] Pawn
	- [x] Rook 
	- [x] Knight 
	- [x] Bishop 
	- [x] Queen 
	- [x] King

- [ ] Special Moves
	- [ ] Castling
	- [ ] En passant : *pawn take down in passing*
	- [ ] Pawn Promotion
	- [ ] Check & Checkmate