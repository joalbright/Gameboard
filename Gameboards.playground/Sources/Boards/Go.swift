import SwiftUI

public struct Go {

    public static var board: Grid { Grid(9 ✕ (9 ✕ "")) }
    public static let playerPieces = ["●", "○"]
    public static let playerColors = [Color.black, Color.white]
    public static let playerSecondaryColors = [Color.white, Color.black]

    static func positionKey(_ grid: Grid) -> String { grid.content.flatMap { $0 }.map { $0.isEmpty ? "." : $0 }.joined() }

    static func neighbors(of index: Int, in grid: Grid) -> [Int] {

        let width = grid.colRange.count
        let row = index / width
        let column = index % width

        return [(-1,0), (1,0), (0,-1), (0,1)].compactMap { direction in

            let square = (row + direction.0, column + direction.1)
            return grid.onBoard(square) ? square.0 * width + square.1 : nil

        }

    }

    static func group(at index: Int, in grid: Grid) -> Set<Int> {

        let width = grid.colRange.count
        let piece = grid[index / width,index % width]
        var visited: Set<Int> = [index]
        var queue = [index]

        while let current = queue.popLast() {

            for neighbor in neighbors(of: current, in: grid) where !visited.contains(neighbor) && grid[neighbor / width,neighbor % width] == piece {

                visited.insert(neighbor)
                queue.append(neighbor)

            }

        }

        return visited

    }

    static func hasLiberty(_ group: Set<Int>, in grid: Grid) -> Bool {

        let width = grid.colRange.count
        return group.contains { index in neighbors(of: index, in: grid).contains { grid[$0 / width,$0 % width].isEmpty } }

    }

    public static func checkCapture(_ square: Square, _ piece: Piece, _ grid: inout Grid) {

        let width = grid.colRange.count

        for neighbor in neighbors(of: square.0 * width + square.1, in: grid) {

            let other = grid[neighbor / width,neighbor % width]
            guard !other.isEmpty, other != piece else { continue }
            let stones = group(at: neighbor, in: grid)

            if !hasLiberty(stones, in: grid) {

                for stone in stones { grid[stone / width,stone % width] = "" }

            }

        }

    }

    public static func validateMove(_ square: Square, _ piece: Piece, _ grid: inout Grid, _ player: Int) throws {

        guard grid.onBoard(square), grid[square.0,square.1].isEmpty else { throw MoveError.invalidmove }
        var next = grid
        next[square.0,square.1] = playerPieces[player]
        checkCapture(square, playerPieces[player], &next)
        let stones = group(at: square.0 * grid.colRange.count + square.1, in: next)
        guard hasLiberty(stones, in: next) else { throw MoveError.invalidmove }
        grid = next

    }

    static func areaScores(_ grid: Grid, dead: Set<Int> = [], komi: Double = 6.5) -> [Double] {

        var scored = grid
        let width = grid.colRange.count

        for index in dead where scored.onBoard((index / width,index % width)) { scored[index / width,index % width] = "" }

        var scores = [0.0, komi]
        var visited: Set<Int> = []

        for row in scored.rowRange {

            for column in scored.colRange {

                let index = row * width + column
                let piece = scored[row,column]

                if let player = playerPieces.firstIndex(of: piece) {

                    scores[player] += 1
                    continue

                }

                guard !visited.contains(index) else { continue }
                let region = group(at: index, in: scored)
                visited.formUnion(region)
                var owners: Set<Int> = []

                for point in region {

                    for neighbor in neighbors(of: point, in: scored) {

                        if let player = playerPieces.firstIndex(of: scored[neighbor / width,neighbor % width]) { owners.insert(player) }

                    }

                }

                if owners.count == 1, let player = owners.first { scores[player] += Double(region.count) }

            }

        }

        return scores

    }

}
