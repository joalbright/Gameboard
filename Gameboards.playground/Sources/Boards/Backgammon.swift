import SwiftUI

public struct Backgammon {

    enum Position: Equatable {

        case bar
        case point(Int)
        case borneOff

        var point: Int? {

            guard case .point(let point) = self else { return nil }
            return point

        }

    }

    struct Move: Equatable {

        var source: Position
        var destination: Position
        var die: Int

    }

    struct State {

        var points: [Int]
        var bar: [Int]
        var borneOff: [Int]
        var dice: [Int]

        init(points: [Int] = Backgammon.initialPoints, bar: [Int] = [0,0], borneOff: [Int] = [0,0], dice: [Int] = []) {

            self.points = points
            self.bar = bar
            self.borneOff = borneOff
            self.dice = dice

        }

        var grid: Grid {

            var content = 12 ✕ (12 ✕ " ")

            for point in 1...24 {

                let value = points[point - 1]
                let piece = value > 0 ? Backgammon.playerPieces[0] : Backgammon.playerPieces[1]
                let count = min(abs(value), 6)

                guard count > 0 else { continue }

                let column = point > 12 ? point - 13 : 12 - point
                let rows = point > 12 ? 0..<count : (12 - count)..<12

                for row in rows { content[row][column] = piece }

            }

            return Grid(content, playerPieces: Backgammon.playerPieces)

        }

        mutating func roll(_ first: Int, _ second: Int) {

            guard (1...6).contains(first), (1...6).contains(second) else { return }

            dice = first == second ? 4 ✕ first : [first, second]

        }

        func checkerCount(at point: Int, for player: Int) -> Int {

            guard point.within(1..<25) else { return 0 }

            let value = points[point - 1]
            return player == 0 ? max(value, 0) : max(-value, 0)

        }

        func legalMoves(for player: Int) -> [Move] {

            let sequences = moveSequences(for: player)
            let maximumMoves = sequences.map(\.count).max() ?? 0

            guard maximumMoves > 0 else { return [] }

            var qualifyingSequences = sequences.filter { $0.count == maximumMoves }

            if dice.count == 2, dice[0] != dice[1], maximumMoves == 1 {

                let highestDie = qualifyingSequences.compactMap { $0.first?.die }.max() ?? 0
                qualifyingSequences = qualifyingSequences.filter { $0.first?.die == highestDie }

            }

            var moves: [Move] = []

            for move in qualifyingSequences.compactMap(\.first) where !moves.contains(move) { moves.append(move) }

            return moves

        }

        mutating func apply(_ move: Move, for player: Int) {

            applyUnchecked(move, for: player)

        }

        private func moveSequences(for player: Int) -> [[Move]] {

            var sequences: [[Move]] = []

            for die in Set(dice).sorted() {

                for move in rawMoves(for: player, die: die) {

                    var next = self
                    next.applyUnchecked(move, for: player)

                    for tail in next.moveSequences(for: player) { sequences.append([move] + tail) }

                }

            }

            return sequences.isEmpty ? [[]] : sequences

        }

        private func rawMoves(for player: Int, die: Int) -> [Move] {

            if bar[player] > 0 {

                let destination = player == 0 ? 25 - die : die
                guard canLand(on: destination, player: player) else { return [] }
                return [Move(source: .bar, destination: .point(destination), die: die)]

            }

            var moves: [Move] = []

            for point in 1...24 where checkerCount(at: point, for: player) > 0 {

                let destination = player == 0 ? point - die : point + die

                if destination.within(1..<25), canLand(on: destination, player: player) {

                    moves.append(Move(source: .point(point), destination: .point(destination), die: die))

                } else if canBearOff(from: point, die: die, player: player) {

                    moves.append(Move(source: .point(point), destination: .borneOff, die: die))

                }

            }

            return moves

        }

        private func canLand(on point: Int, player: Int) -> Bool {

            return checkerCount(at: point, for: 1 - player) < 2

        }

        private func canBearOff(from point: Int, die: Int, player: Int) -> Bool {

            guard allCheckersAreHome(for: player) else { return false }

            let distance = player == 0 ? point : 25 - point

            if die == distance { return true }
            guard die > distance else { return false }

            if player == 0 { return !((point + 1)...6).contains { checkerCount(at: $0, for: player) > 0 } }
            return !(19..<point).contains { checkerCount(at: $0, for: player) > 0 }

        }

        private func allCheckersAreHome(for player: Int) -> Bool {

            guard bar[player] == 0 else { return false }

            let home = player == 0 ? 1...6 : 19...24
            let checkersAtHome = home.reduce(0) { $0 + checkerCount(at: $1, for: player) }

            return checkersAtHome + borneOff[player] == 15

        }

        private mutating func applyUnchecked(_ move: Move, for player: Int) {

            guard let dieIndex = dice.firstIndex(of: move.die) else { return }

            dice.remove(at: dieIndex)

            switch move.source {
            case .bar: bar[player] -= 1
            case .point(let point): removeChecker(from: point, player: player)
            case .borneOff: return
            }

            switch move.destination {
            case .bar: return
            case .borneOff: borneOff[player] += 1
            case .point(let point):

                if checkerCount(at: point, for: 1 - player) == 1 {

                    removeChecker(from: point, player: 1 - player)
                    bar[1 - player] += 1

                }

                addChecker(to: point, player: player)

            }

        }

        private mutating func removeChecker(from point: Int, player: Int) {

            points[point - 1] += player == 0 ? -1 : 1

        }

        private mutating func addChecker(to point: Int, player: Int) {

            points[point - 1] += player == 0 ? 1 : -1

        }

    }

    static let initialPoints = [-2,0,0,0,0,5,0,3,0,0,0,-6,5,0,0,0,-3,0,-5,0,0,0,0,2]
    public static var board: Grid { return State().grid }
    public static let playerPieces = ["●","○"]
    public static let playerColors = [Color.black, Color.white]

}
