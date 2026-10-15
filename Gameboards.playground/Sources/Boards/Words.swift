import Foundation
import UIKit

public struct Words {
    
    public enum PieceType: String {
        
        static var all: [PieceType] { return [.start,.doubleword,.doubleletter,.tripleword,.tripleletter] }
        static var names: [String] { return all.map { $0.rawValue } }
        
        case empty = " "
        case start = "★"
        case doubleword = "DW"
        case tripleword = "TW"
        case doubleletter = "DL"
        case tripleletter = "TL"
        
    }
    
    public enum Letter: String {
        
        static var all: [Letter] { return [.a,.b,.c,.d,.e,.f,.g,.h,.i,.j,.k,.l,.m,.n,.o,.p,.q,.r,.s,.t,.u,.v,.w,.x,.y,.z,.blank,.none] }
        
        static var bag: [Letter] {

            return all.reduce([]) { $0 + Array(repeating: $1, count: $1.count) }.randomize().randomize()

        }

        case a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,blank = "_",none = " "
        
        var count: Int {
            
            switch self {
            case .none: return 0
            case .j, .k, .q, .x, .z: return 1
            case .blank, .b, .c, .f, .m, .p, .v, .w, .y: return 2
            case .g: return 3
            case .h, .l, .u: return 4
            case .d, .n, .s: return 5
            case .r: return 6
            case .t: return 7
            case .i, .o: return 8
            case .a: return 9
            case .e: return 13
            }
            
        }
        
        var point: Int {
            
            switch self {
            case .blank, .none: return 0
            case .a, .e, .i, .o, .r, .s, .t: return 1
            case .d, .l, .n, .u: return 2
            case .g, .h, .y: return 3
            case .b, .c, .f, .m, .p, .w: return 4
            case .k, .v: return 5
            case .x: return 8
            case .j, .q, .z: return 10
            }
            
        }
        
    }
    
    public static var board: Grid {
        
        let grid = Grid([
        
            [" "," "," ","TW"," "," ","TL"," ","TL"," "," ","TW"," "," "," "],
            [" "," ","DL"," "," ","DW"," "," "," ","DW"," "," ","DL"," "," "],
            [" ","DL"," "," ","DL"," "," "," "," "," ","DL"," "," ","DL"," "],
            ["TW"," "," ","TL"," "," "," ","DW"," "," "," ","TL"," "," ","TW"],
            [" "," ","DL"," "," "," ","DL"," ","DL"," "," "," ","DL"," "," "],
            [" ","DW"," "," "," ","TL"," "," "," ","TL"," "," "," ","DW"," "],
            ["TL"," "," "," ","DL"," "," "," "," "," ","DL"," "," "," ","TL"],
            [" "," "," ","DW"," "," "," ","★"," "," "," ","DW"," "," "," "],
            ["TL"," "," "," ","DL"," "," "," "," "," ","DL"," "," "," ","TL"],
            [" ","DW"," "," "," ","TL"," "," "," ","TL"," "," "," ","DW"," "],
            [" "," ","DL"," "," "," ","DL"," ","DL"," "," "," ","DL"," "," "],
            ["TW"," "," ","TL"," "," "," ","DW"," "," "," ","TL"," "," ","TW"],
            [" ","DL"," "," ","DL"," "," "," "," "," ","DL"," "," ","DL"," "],
            [" "," ","DL"," "," ","DW"," "," "," ","DW"," "," ","DL"," "," "],
            [" "," "," ","TW"," "," ","TL"," ","TL"," "," ","TW"," "," "," "]
        
        ])
        
        return grid
        
    }
    
    public static let playerPieces = ["ABCDEFGHIJKLMNOPQRSTUVWXYZ_"]

    struct RuleError: LocalizedError {

        var errorDescription: String?

        init(_ message: String) {

            errorDescription = message

        }

    }

    @MainActor static func isEnglishWord(_ word: String) -> Bool {

        guard word.count >= 2, word.allSatisfy({ $0.isASCII && $0.isLetter }) else { return false }
        let languages = UITextChecker.availableLanguages
        guard let language = languages.first(where: { $0 == "en_US" }) ?? languages.first(where: { $0.hasPrefix("en") }) else { return false }
        let text = word.lowercased()
        let range = NSRange(location: 0, length: text.utf16.count)
        return UITextChecker().rangeOfMisspelledWord(in: text, range: range, startingAt: 0, wrap: false, language: language).location == NSNotFound

    }

    struct Tile {

        var letter: Letter
        var original: Letter
        var rackIndex: Int

        var value: Int { original.point }

    }

    struct State {

        private(set) var tiles: [Int: Tile]
        private(set) var pending: [Int: Tile] = [:]
        private(set) var racks: [[Letter]]
        private(set) var bag: [Letter]
        private(set) var scores: [Int]
        private(set) var player: Int
        private(set) var scorelessTurns = 0
        private(set) var isComplete = false
        private(set) var lastWords: [String] = []

        init(racks: [[Letter]]? = nil, bag: [Letter] = Letter.bag, tiles: [Int: Tile] = [:], scores: [Int] = [0,0], player: Int = 0) {

            self.tiles = tiles
            self.racks = racks ?? [[],[]]
            self.bag = bag
            self.scores = scores
            self.player = player

            for owner in 0..<2 {

                self.racks[owner] = Array(self.racks[owner].prefix(7))
                self.racks[owner] += Array(repeating: .none, count: 7 - self.racks[owner].count)
                if racks == nil { refill(owner) }

            }

        }

        var grid: Grid {

            var grid = Words.board
            grid.playerPieces = Words.playerPieces

            for (index, tile) in tiles.merging(pending, uniquingKeysWith: { _, new in new }) { grid[index / 15,index % 15] = tile.letter.rawValue.uppercased() }
            return grid

        }

        mutating func stage(_ letter: Letter, at square: Square, blank: Letter = .a) throws {

            guard !isComplete, square.0.within(0..<15), square.1.within(0..<15) else { throw RuleError("That square is unavailable.") }
            let index = square.0 * 15 + square.1
            guard tiles[index] == nil, pending[index] == nil, letter != .none, let slot = racks[player].firstIndex(of: letter) else { throw RuleError("Choose an available tile and an empty square.") }
            guard blank != .none, blank != .blank else { throw RuleError("Choose a letter for the blank tile.") }
            pending[index] = Tile(letter: letter == .blank ? blank : letter, original: letter, rackIndex: slot)
            racks[player][slot] = .none

        }

        mutating func removePending(at square: Square) {

            let index = square.0 * 15 + square.1
            guard let tile = pending.removeValue(forKey: index) else { return }
            racks[player][tile.rackIndex] = tile.original

        }

        mutating func recall() {

            for tile in pending.values { racks[player][tile.rackIndex] = tile.original }
            pending = [:]

        }

        func evaluate(accepts: (String) -> Bool) throws -> (score: Int, words: [String]) {

            guard !pending.isEmpty else { throw RuleError("Place tiles before submitting a word.") }
            let placed = pending.keys.sorted()
            let rows = Set(placed.map { $0 / 15 })
            let columns = Set(placed.map { $0 % 15 })
            guard rows.count == 1 || columns.count == 1 else { throw RuleError("New tiles must be in one row or column.") }
            let all = tiles.merging(pending, uniquingKeysWith: { _, new in new })

            if let first = placed.first, let last = placed.last {

                let step = rows.count == 1 ? 1 : 15
                guard stride(from: first, through: last, by: step).allSatisfy({ all[$0] != nil }) else { throw RuleError("There is a gap in the word.") }

            }

            if tiles.isEmpty {

                guard pending[112] != nil else { throw RuleError("The first word must cover the center star.") }

            } else {

                let connected = placed.contains { index in neighbors(of: index).contains { tiles[$0] != nil } }
                guard connected else { throw RuleError("The word must connect to a tile already on the board.") }

            }

            var lines: Set<[Int]> = []

            for index in placed {

                for direction: Square in [(0,1), (1,0)] {

                    let line = wordLine(at: index, direction: direction, tiles: all)
                    if line.count > 1 { lines.insert(line) }

                }

            }

            guard !lines.isEmpty else { throw RuleError("A word must contain at least two letters.") }
            var total = pending.count == 7 ? 35 : 0
            var words: [String] = []

            for line in lines.sorted(by: { $0.lexicographicallyPrecedes($1) }) {

                let word = line.compactMap { all[$0]?.letter.rawValue }.joined().uppercased()
                guard accepts(word) else { throw RuleError("\(word) is not in the English dictionary.") }
                words.append(word)
                var points = 0
                var wordMultiplier = 1

                for index in line {

                    guard let tile = all[index] else { continue }
                    var multiplier = 1

                    if pending[index] != nil {

                        switch PieceType(rawValue: Words.board[index / 15,index % 15]) {

                        case .doubleletter: multiplier = 2
                        case .tripleletter: multiplier = 3
                        case .doubleword: wordMultiplier *= 2
                        case .tripleword: wordMultiplier *= 3
                        default: break

                        }

                    }

                    points += tile.value * multiplier

                }

                total += points * wordMultiplier

            }

            return (total, words)

        }

        @discardableResult mutating func submit(accepts: (String) -> Bool) throws -> Int {

            guard !isComplete else { throw RuleError("This game has ended.") }
            let turn = try evaluate(accepts: accepts)
            scores[player] += turn.score
            lastWords = turn.words
            tiles.merge(pending, uniquingKeysWith: { _, new in new })
            pending = [:]
            scorelessTurns = turn.score == 0 ? scorelessTurns + 1 : 0
            refill(player)
            finishTurn()
            return turn.score

        }

        mutating func pass() throws {

            guard !isComplete, pending.isEmpty else { throw RuleError("Recall your tiles before passing.") }
            scorelessTurns += 1
            finishTurn()

        }

        mutating func exchange(_ letter: Letter) throws {

            guard !isComplete, pending.isEmpty, bag.count >= 7, letter != .none, let index = racks[player].firstIndex(of: letter) else { throw RuleError("Recall your tiles and choose a tile to exchange. At least seven tiles must remain in the bag.") }
            racks[player][index] = bag.removeFirst()
            bag.append(letter)
            bag.shuffle()
            scorelessTurns += 1
            finishTurn()

        }

        private mutating func refill(_ owner: Int) {

            for index in racks[owner].indices where racks[owner][index] == .none && !bag.isEmpty { racks[owner][index] = bag.removeFirst() }

        }

        private mutating func finishTurn() {

            let wentOut = bag.isEmpty && racks[player].allSatisfy { $0 == .none }

            if wentOut || scorelessTurns >= 6 {

                let remaining = racks.map { $0.reduce(0) { $0 + $1.point } }
                for owner in 0..<2 { scores[owner] -= remaining[owner] }
                if wentOut { scores[player] += remaining[1 - player] }
                isComplete = true

            } else {

                player = 1 - player

            }

        }

        private func neighbors(of index: Int) -> [Int] {

            return [(-1,0), (1,0), (0,-1), (0,1)].compactMap { direction in

                let row = index / 15 + direction.0
                let column = index % 15 + direction.1
                return row.within(0..<15) && column.within(0..<15) ? row * 15 + column : nil

            }

        }

        private func wordLine(at index: Int, direction: Square, tiles: [Int: Tile]) -> [Int] {

            let step = direction.0 * 15 + direction.1
            var start = index

            while neighbors(of: start).contains(start - step), tiles[start - step] != nil { start -= step }
            var line: [Int] = []
            var next = start

            while tiles[next] != nil {

                line.append(next)
                guard neighbors(of: next).contains(next + step) else { break }
                next += step

            }

            return line

        }

    }
    
    public static func validate(_ tile: Letter, _ s1: Square, _ grid: inout Grid) throws {
        
        let spot = grid[s1.0,s1.1]
        guard PieceType(rawValue: spot) != nil else { throw MoveError.invalidmove }
        
        grid[s1.0,s1.1] = tile.rawValue.uppercased()
        
    }

}
