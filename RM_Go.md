# Go

![Go](./images/go.png?raw=true)

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

#### General

- [wikipedia](https://en.wikipedia.org/wiki/Go_(game))
- [x] Coordinates
	- columns 0 - 9
	- rows 0 - 9
- [ ] Adjustable Board Size : *9, 13, 17, 19*

#### Validation

- [x] Standard Moves
	- [x] Capture

- [ ] Special Moves
	- [ ] KO
	- [ ] Suicide