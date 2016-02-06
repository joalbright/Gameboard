# Gameboard

Gameboards built in a playground

#### Games

- [ ] Backgammon
- [x] Checkers
- [x] Chess
- [x] Go
- [ ] Mancala
- [x] MineSweeper
- [x] Sudoku
- [x] TicTacToe

#### Features

- [x] Swift Player Per Turn
- [x] Coordinate System
- [x] Ability to Reset
- [x] Available Moves : *hint system*
- [x] Custom Colors
- [ ] Piece Collection
- [ ] Time Control : *timer for moves*
- [ ] Simple Move AI : *need a friend?*

#### Overall Validation

- [x] Stop friendly fire : *checks if target piece is yours*
- [x] Only play on your turn : *checks against pieces for player*
- [x] No piece available : *checks for no piece*
- [x] Off the board : *checks if target square is on board*

## Checkers

- [x] Coordinates
	- columns 0 - 7
	- rows 0 - 7

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

![Checkers](./images/checkers.png?raw=true)

#### Validation

- [x] Standard Moves
	- [x] Diagonal -> 1
	- [x] Diagonal Jump

- [ ] Special Moves
	- [ ] Multiple Jumps
	- [ ] Promotion

## Chess

- [x] Coordinates
	- columns A - H
	- rows 8 - 1

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

![Chess](./images/chess.png?raw=true)

#### Validation

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

## Go

- [x] Coordinates
	- columns 0 - 9
	- rows 0 - 9
- [ ] Adjustable Board Size : *9, 13, 17, 19*

```swift
var go = Gameboard(.Go)

// setup colors

var colors = BoardColors()

colors.background = UIColor(red:0.36, green:0.29, blue:0.16, alpha:1)
colors.foreground = UIColor(red:0.11, green:0.08, blue:0.03, alpha:1)

colors.player1 = UIColor.whiteColor()
colors.player2 = UIColor.blackColor()

go.boardColors = colors

// collection of moves

let moves: [Square] = [
    
    // moves
    (1,1),
    (6,7),
    (1,7),
    (6,0),
    (4,4),
    (4,5),
    (1,2),
    
]

// loop moves

for move in moves {
    
    do {
        
        try go.move(toSquare: move)
        
    } catch {
        
        print(error)
        
    }
    
}

go.visualize()
```

![Go](./images/go.png?raw=true)

#### Validation

- [x] Standard Moves
	- [x] Capture

- [ ] Special Moves
	- [ ] KO
	- [ ] Suicide

## Minesweeper

- [x] Coordinates
	- columns 0 - 9
	- rows 0 - 9

```swift
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
    ((2,7),.Mark),  // mark
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

minesweeper.visualize()
```

![Minesweeper](./images/minesweeper.png?raw=true)

#### Validation

- [x] Standard Moves
	- [x] Mark : *flag*
	- [x] Guess
	- [x] Boom : *mine*

## Sudoku

- [x] Coordinates
	- columns 0 - 8
	- rows 0 - 8
- [x] Solution Generator : *randomizes solution*
- [x] Puzzle Generator : *hides numbers*
- [ ] Alphabetical Option

```swift
var sudoku = Gameboard(.Sudoku)

// setup colors

var colors = BoardColors()

colors.background = UIColor(red:0.19, green:0.78, blue:0.71, alpha:1)
colors.foreground = UIColor(red:0.09, green:0.4, blue:0.44, alpha:1)

sudoku.boardColors = colors

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

// loop guesses

for guess in guesses {
    
    do {
        
        try sudoku.guess(toSquare: guess.0, withGuess: guess.1)
        
    } catch {
        
        print(error)
        
    }
    
}

sudoku.visualize(CGRect(x: 0, y: 0, width: 198, height: 198))
```

![Sudoku](./images/sudoku.png?raw=true)

#### Validation

- [x] Standard Moves
	
## TicTacToe

- [x] Coordinates
	- columns 0 - 2
	- rows 0 - 2

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

![TicTacToe](./images/tictactoe.png?raw=true)

#### Validation

- [x] Standard Moves