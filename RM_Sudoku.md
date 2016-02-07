# Sudoku

![Sudoku](./images/sudoku.png?raw=true)

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

#### General

- [wikipedia](https://en.wikipedia.org/wiki/Sudoku)
- [x] Coordinates
	- columns 0 - 8
	- rows 0 - 8
- [x] Solution Generator : *randomizes solution*
- [x] Puzzle Generator : *hides numbers*
- [ ] Alphabetical Option

#### Validation

- [ ] Win / Lose

- [x] Standard Moves