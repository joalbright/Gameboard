# TicTacToe

![TicTacToe](./images/tictactoe.png?raw=true)

```swift
var tictactoe = GameBoard(.TicTacToe)

// setup colors

var colors = BoardColors()

colors.player1 = UIColor(red:0.43, green:0.98, blue:0.7, alpha:1)
colors.player2 = UIColor(red:1, green:0.15, blue:0.18, alpha:1)

tictactoe.boardColors = colors

// collection of moves

let moves: [Square] = [
 
    (1,1),
    (0,0),
    (0,2),
    (2,0),
    (1,0),
    (1,2),
    (0,1),
    (1,1), // cant play filled spot
    (2,1),
    (2,2), // stalemate
    
]

// loop moves

for move in moves {
    
    do {
        
        try tictactoe.move(toSquare: move)
        
    } catch {
        
        error
        
    }
    
}

tictactoe.visualize()
```

#### General

- [wikipedia](https://en.wikipedia.org/wiki/Tic-tac-toe)
- [x] Coordinates
	- columns 0 - 2
	- rows 0 - 2

#### Validation

- [x] Standard Moves