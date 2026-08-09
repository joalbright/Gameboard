import SwiftUI

public struct Dots {

    public static var board: Grid {

        var content = 17 ✕ (17 ✕ "")

        for row in 0..<17 {

            for column in 0..<17 {

                if row.isMultiple(of: 2) {

                    content[row][column] = column.isMultiple(of: 2) ? "●" : "0"

                } else {

                    content[row][column] = column.isMultiple(of: 2) ? "0" : " "

                }

            }

        }

        return Grid(content)

    }
    
//    public static var board: Grid { return Grid(8 ✕ (8 ✕ "00000")) }

    public static let playerPieces = ["1","2"]
    public static let playerColors = [Color.cyan, Color.pink]

    public static func validateMove(_ s1: Square, _ p1: Piece, _ grid: inout Grid, _ player: Int) throws -> Bool {

        guard p1 == "0" else { throw MoveError.invalidmove }

        grid[s1.0,s1.1] = playerPieces[player]

        return checkSpaces(s1, &grid, player: player)

    }

    public static func isSegment(_ square: Square) -> Bool {

        return square.0.isMultiple(of: 2) != square.1.isMultiple(of: 2)

    }

    @discardableResult public static func checkSpaces(_ s1: Square, _ grid: inout Grid, player: Int) -> Bool {

        let adjacent2 = [ (-1,0),(0,1),(1,0),(0,-1) ]
        var completedSquare = false

        for a in adjacent2 {

            let s = (s1.0 + a.0, s1.1 + a.1)
            guard grid.onBoard(s) else { continue }
            let a1 = grid[s.0,s.1]
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
            let a1 = grid[s.0,s.1]
            if a1 != "0" { count += 1 }

        }

        return count == 4

    }

}
