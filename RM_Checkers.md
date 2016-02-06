# Checkers

![Checkers](./images/checkers.png?raw=true)

```swift
var checkers = GameBoard(.Checkers)

// setup colors

var colors = BoardColors()

colors.background = UIColor(red:0.66, green:0.62, blue:0.48, alpha:1)
colors.foreground = UIColor(red:0.62, green:0.58, blue:0.44, alpha:1)

colors.player1 = UIColor(red:0.8, green:0.13, blue:0, alpha:1)
colors.player2 = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1)

colors.selected = UIColor.whiteColor()
colors.highlight = UIColor.whiteColor()

checkers.boardColors = colors

// collection of moves

let moves: [(Square,Square)] = [

    ((2,1),(3,2)), // move
    ((5,2),(4,3)), // move
    ((2,3),(3,4)), // move
    ((4,3),(2,1)), // jump
    ((2,5),(4,3)), // cannot jump yourself
    ((2,5),(3,4)), // cannot land on your own piece
    ((1,0),(2,1)), // cannot land on another piece

]

// loop moves

for move in moves {
    
    do {
        
        try checkers.move(pieceAt: move.0, toSquare: move.1)
    
    } catch {
        
        error
    
    }
    
}

// show available moves for a square

checkers.showAvailable((1,2))

checkers.visualize()
```

#### General

- [wikipedia](https://simple.wikipedia.org/wiki/Checkers)
- [x] Coordinates
	- columns 0 - 7
	- rows 0 - 7

#### Validation

- [x] Standard Moves
	- [x] Diagonal -> 1
	- [x] Diagonal Jump

- [ ] Special Moves
	- [ ] Multiple Jumps
	- [ ] Promotion