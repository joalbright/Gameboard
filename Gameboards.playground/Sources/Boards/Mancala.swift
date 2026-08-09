import SwiftUI

struct MancalaMove {

    let start: Square
    let destinations: [Square]
    let player: Int
    let retainsTurn: Bool

}

public struct Mancala {

    private static let route: [Square] = [(0,0), (1,0), (2,0), (3,0), (4,0), (5,0), (5,1), (5,2), (4,2), (3,2), (2,2), (1,2), (0,2), (0,1)]
    
    public static var board: Grid {
        
        return Grid([
            
            ["3","0","3"],
            ["3"," ","3"],
            ["3"," ","3"],
            ["3"," ","3"],
            ["3"," ","3"],
            ["3","0","3"]
            
        ])
        
    }
    
    public static let playerPieces = ["123456789","123456789"]
    public static let playerColors = [Color.cyan, Color.pink]
    
    public static var staticboard: Grid {
        
        return Grid([
            
            ["0","3","4"],
            ["4"," ","4"],
            ["0"," ","3"],
            ["3"," ","0"],
            ["4"," ","1"],
            ["5","4","1"]
            
        ])
        
    }

    public static func validateMove(_ square: Square, _ piece: Piece, _ grid: Grid, _ player: Int) throws -> Bool {

        let move = try plannedMove(from: square, piece: piece, player: player)

        begin(move, in: grid)

        for destination in move.destinations { placeStone(at: destination, in: grid) }

        finish(move, in: grid)

        return move.retainsTurn

    }

    static func plannedMove(from square: Square, piece: Piece, player: Int) throws -> MancalaMove {

        guard player == 0 || player == 1 else { throw MoveError.noplayer }
        guard ownedPits(for: player).contains(where: { $0 == square }) else { throw MoveError.notyourturn }
        guard let stones = Int(piece), stones > 0 else { throw MoveError.invalidmove }
        guard let startingIndex = route.firstIndex(where: { $0 == square }) else { throw MoveError.invalidmove }

        let opponentStore = store(for: 1 - player)
        var destinations: [Square] = []
        var routeIndex = startingIndex

        for _ in 0..<stones {

            repeat {

                routeIndex = (routeIndex + 1) % route.count

            } while route[routeIndex] == opponentStore

            destinations.append(route[routeIndex])

        }

        let retainsTurn = destinations.last.map { $0 == store(for: player) } ?? false

        return MancalaMove(start: square, destinations: destinations, player: player, retainsTurn: retainsTurn)

    }

    static func begin(_ move: MancalaMove, in grid: Grid) {

        grid[move.start.c, move.start.r] = "0"

    }

    static func placeStone(at square: Square, in grid: Grid) {

        grid[square.c, square.r] = "\(stoneCount(at: square, in: grid) + 1)"

    }

    static func finish(_ move: MancalaMove, in grid: Grid) {

        guard let lastSquare = move.destinations.last else { return }

        captureIfNeeded(at: lastSquare, for: move.player, in: grid)

        if isComplete(grid) { collectRemainingStones(in: grid) }

    }

    public static func isComplete(_ grid: Grid) -> Bool {

        return (0...1).contains { player in ownedPits(for: player).allSatisfy { stoneCount(at: $0, in: grid) == 0 } }

    }

    public static func score(for player: Int, in grid: Grid) -> Int {

        return stoneCount(at: store(for: player), in: grid)

    }

    private static func ownedPits(for player: Int) -> [Square] {

        let column = player == 0 ? 0 : 2
        return (0..<6).map { ($0, column) }

    }

    private static func store(for player: Int) -> Square {

        return player == 0 ? (5,1) : (0,1)

    }

    private static func stoneCount(at square: Square, in grid: Grid) -> Int {

        return Int(grid[square.c, square.r] as? String ?? "") ?? 0

    }

    private static func captureIfNeeded(at square: Square, for player: Int, in grid: Grid) {

        guard ownedPits(for: player).contains(where: { $0 == square }) else { return }
        guard stoneCount(at: square, in: grid) == 1 else { return }

        let opposite: Square = (square.c, player == 0 ? 2 : 0)
        let capturedStones = stoneCount(at: opposite, in: grid)

        guard capturedStones > 0 else { return }

        let playerStore = store(for: player)
        let total = stoneCount(at: playerStore, in: grid) + capturedStones + 1

        grid[square.c, square.r] = "0"
        grid[opposite.c, opposite.r] = "0"
        grid[playerStore.c, playerStore.r] = "\(total)"

    }

    private static func collectRemainingStones(in grid: Grid) {

        for player in 0...1 {

            let pits = ownedPits(for: player)
            let remainingStones = pits.reduce(0) { $0 + stoneCount(at: $1, in: grid) }
            let playerStore = store(for: player)

            for pit in pits { grid[pit.c, pit.r] = "0" }

            grid[playerStore.c, playerStore.r] = "\(stoneCount(at: playerStore, in: grid) + remainingStones)"

        }

    }

}
