import SwiftUI

public struct Dots {

    public static var board: Grid { return Grid(17 ✕ (17 ✕ ("●" %% "0") %% 17 ✕ ("0" %% " "))) }
    
//    public static var board: Grid { return Grid(8 ✕ (8 ✕ "00000")) }

    public static let playerPieces = ["1","2"]
    public static let playerColors = [Color.cyan, Color.pink]

    public static func validateMove(_ s1: Square, _ p1: Piece, _ grid: Grid, _ player: Int) throws -> Bool {

        guard p1 == "0" else { throw MoveError.invalidmove }

        grid[s1.0,s1.1] = playerPieces[player]

        return checkSpaces(s1, grid, player: player)

    }

    public static func isSegment(_ square: Square) -> Bool {

        return square.0.isMultiple(of: 2) != square.1.isMultiple(of: 2)

    }

    @discardableResult public static func checkSpaces(_ s1: Square, _ grid: Grid, player: Int) -> Bool {

        let adjacent2 = [ (-1,0),(0,1),(1,0),(0,-1) ]
        var completedSquare = false

        for a in adjacent2 {

            let s = (s1.0 + a.0, s1.1 + a.1)
            guard grid.onBoard(s) else { continue }
            guard let a1 = grid[s.0,s.1] as? String else { continue }
            guard a1 == " ", checkClosed(s, grid) else { continue }

            grid[s.0,s.1] = playerPieces[player]
            completedSquare = true

        }

        return completedSquare

    }

    public static func checkClosed(_ s1: Square, _ grid: Grid) -> Bool {

        var count = 0

        let adjacent2 = [ (-1,0),(0,1),(1,0),(0,-1) ]

        for a in adjacent2 {

            let s = (s1.0 + a.0, s1.1 + a.1)
            guard grid.onBoard(s) else { continue }
            guard let a1 = grid[s.0,s.1] as? String else { continue }
            if a1 != "0" { count += 1 }

        }

        return count == 4

    }

}
