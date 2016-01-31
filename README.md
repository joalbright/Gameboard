# Gameboard

Gameboards built in a playground

- [x] Swift Player Per Turn
- [x] Coordinate System
- [x] Ability to Reset
- [ ] Piece Collection
- [ ] Simple Move AI

#### Overall Validation

- [x] Stop friendly fire : *checks if target piece is yours*
- [x] Only play on your turn : *checks against pieces for player*
- [x] No piece available : *checks for no piece*
- [x] Off the board : *checks if target square is on board*

## Chess

- [x] Coordinates
	- columns A - H
	- rows 8 - 1

![Chess](./images/chess.png)

#### Validation

- [x] Pawn
- [x] Rook ~
- [x] Knight ~
- [x] Bishop ~
- [x] Queen ~
- [x] King

~ *needs to check path*

## Checkers

- [x] Coordinates
	- columns 0 - 7
	- rows 0 - 7

![Checkers](./images/checkers.png)

#### Validation

- [x] Diagonal -> 1
- [x] Diagonal Jump
- [ ] Multiple Jumps