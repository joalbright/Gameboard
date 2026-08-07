import SwiftUI
import Observation

enum GameSwipeDirection {

    case up
    case down
    case left
    case right

}

enum GameSessionEvent: Equatable, Identifiable {

    case gameOver
    case winner
    case stalemate
    case invalidMove(MoveError)
    case unavailable
    case failure(String)

    var id: String {

        switch self {
        case .gameOver: return "gameOver"
        case .winner: return "winner"
        case .stalemate: return "stalemate"
        case .invalidMove(let error): return "invalidMove.\(error)"
        case .unavailable: return "unavailable"
        case .failure(let description): return "failure.\(description)"
        }

    }

}

@MainActor @Observable final class GameSession {

    private var game: Gameboard
    private(set) var revision = 0
    private var memoryTurn = 0
    private var memoryPairPending = false
    private var wordsBag: [Words.Letter] = []
    private var fourDropID = 0
    private let fourDropInterval: Duration

    private(set) var event: GameSessionEvent?
    private(set) var wordsRack: [Words.Letter] = []
    private(set) var selectedWordTile: Words.Letter?
    private(set) var isFourDropping = false

    var boardType: Gameboard.BoardType { return game._type }
    var playerNumber: Int {

        _ = revision
        return game.playerTurn + 1

    }
    var playerColor: Color {

        _ = revision
        return game.playerColors[game.playerTurn]

    }
    var playerCount: Int {

        _ = revision
        return game.playerCount

    }
    var isMultiplayer: Bool {

        _ = revision
        return game.playerCount > 1

    }
    var grid: Grid {

        _ = revision
        return game.grid

    }
    var highlights: [Square] {

        _ = revision
        return game.highlights

    }
    var selected: Square? {

        _ = revision
        return game.selected

    }

    init(_ boardType: Gameboard.BoardType, testing: Bool = false, fourDropInterval: Duration = .milliseconds(90)) {

        game = Gameboard(boardType, testing: testing)
        self.fourDropInterval = fourDropInterval

        if boardType == .words { resetWords() }

    }

    func dismissEvent() {

        event = nil

    }

    func reset(testing: Bool = false) {

        game.reset(testing)
        event = nil
        fourDropID += 1
        isFourDropping = false
        memoryTurn += 1
        memoryPairPending = false
        if boardType == .words { resetWords() }
        revision += 1

    }

    func showAvailable(at square: Square) {

        game.showAvailable(square)
        revision += 1

    }

    func selectOrMove(at square: Square) {

        defer { revision += 1 }

        guard let selected = game.selected else {

            game.showAvailable(square)
            event = nil
            return

        }

        do {

            _ = try game.move(pieceAt: selected, toSquare: square)
            game.selected = nil
            game.highlights = []
            event = nil

        } catch {

            game.showAvailable(square)
            event = nil

        }

    }

    func drop(inColumn column: Int) async {

        guard boardType == .four, !isFourDropping else { return }
        guard column.within(game.grid.colRange), let firstRow = game.grid.rowRange.first else { return }
        guard game.grid[firstRow, column] as? String == " " else { return }

        fourDropID += 1
        let dropID = fourDropID
        let piece = game.playerPieces[game.playerTurn]
        var row = firstRow

        isFourDropping = true
        defer {

            if dropID == fourDropID { isFourDropping = false }

        }
        event = nil
        game.grid[row, column] = piece
        revision += 1

        while row + 1 < game.grid.rowRange.endIndex, game.grid[row + 1, column] as? String == " " {

            try? await Task.sleep(for: fourDropInterval)

            guard !Task.isCancelled, dropID == fourDropID else { return }

            game.grid[row, column] = " "
            row += 1
            game.grid[row, column] = piece
            revision += 1

        }

        guard dropID == fourDropID else { return }

        game.changePlayer()
        checkFourCompletion()
        revision += 1

    }

    func selectMemoryCard(at square: Square) {

        guard !memoryPairPending else { return }

        if let selected = game.selected {

            do {

                _ = try game.match(cardAt: square, withCard: selected)
                finishMemoryTurn(first: selected, second: square)

            } catch MemoryError.badmatch {

                finishMemoryTurn(first: selected, second: square)

            } catch {

                handle(error)

            }

        } else {

            do {

                try game.select(cardAt: square)
                game.selected = square
                event = nil

            } catch {

                handle(error)

            }

        }

        revision += 1

    }

    func swipe(_ direction: GameSwipeDirection) {

        guard boardType == .doubles else { return }

        var moved = false

        for _ in 0..<4 {

            moved = moveDoubles(direction) || moved

        }

        guard moved else { return }

        _ = Doubles.random(game.grid)
        event = nil
        revision += 1

    }

    func chooseWordTile(_ tile: Words.Letter) {

        guard tile != .none else { return }

        selectedWordTile = selectedWordTile == tile ? nil : tile

    }

    func placeSelectedWordTile(at square: Square) {

        guard let tile = selectedWordTile else { return }

        perform { try $0.place(tile: tile, at: square) }

        guard event == nil, let index = wordsRack.firstIndex(of: tile) else { return }

        wordsRack[index] = .none
        selectedWordTile = nil

    }

    func fillWordsRack() {

        wordsRack.removeAll { $0 == .none }

        let tileCount = min(7 - wordsRack.count, wordsBag.count)

        guard tileCount > 0 else { return }

        wordsRack += wordsBag.prefix(tileCount)
        wordsBag.removeFirst(tileCount)

    }

    func drop(at square: Square) {

        perform { try $0.drop(pieceAt: square) }

    }

    func place(_ tile: Words.Letter, at square: Square) {

        perform { try $0.place(tile: tile, at: square) }

    }

    func guess(at square: Square) {

        perform { try $0.guess(toSquare: square) }
        checkBombsweeperCompletion()

    }

    func guess(at square: Square, with guess: Guess) {

        perform { try $0.guess(toSquare: square, withGuess: guess) }

    }

    func mark(at square: Square) {

        perform { try $0.mark(toSquare: square) }
        checkBombsweeperCompletion()

    }

    func move(to square: Square) {

        perform { try $0.move(toSquare: square) }
        if boardType == .tictactoe { checkTicTacToeCompletion() }
        if boardType == .bombsweeper { checkBombsweeperCompletion() }

    }

    @discardableResult func move(from start: Square, to end: Square) -> Piece? {

        return perform { try $0.move(pieceAt: start, toSquare: end) } ?? nil

    }

    func select(at square: Square) {

        perform { try $0.select(cardAt: square) }

    }

    @discardableResult func match(_ first: Square, with second: Square, reset: Bool = false) -> Card? {

        return perform { try $0.match(cardAt: first, withCard: second, reset: reset) } ?? nil

    }

    private func perform<T>(_ action: (inout Gameboard) throws -> T) -> T? {

        defer { revision += 1 }

        do {

            let result = try action(&game)
            event = nil
            return result

        } catch {

            handle(error)

        }

        return nil

    }

    private func handle(_ error: Error) {

        if let status = error as? GameStatus {

            switch status {
            case .gameover: event = .gameOver
            case .winner: event = .winner
            case .stalemate: event = .stalemate
            }

        } else if let moveError = error as? MoveError {

            event = .invalidMove(moveError)

        } else if error is FunctionalityError {

            event = .unavailable

        } else {

            event = .failure(String(describing: error))

        }

    }

    private func finishMemoryTurn(first: Square, second: Square) {

        game.highlights = [first, second]
        game.selected = nil
        memoryPairPending = true
        event = nil

        let turn = memoryTurn

        Task { @MainActor in

            try? await Task.sleep(for: .milliseconds(600))

            guard turn == memoryTurn else { return }

            _ = try? game.match(cardAt: first, withCard: second, reset: true)
            game.highlights = []
            memoryPairPending = false

            let remainingCards = game.grid.content.flatMap { $0 }.compactMap { $0 as? String }.filter { !$0.isEmpty }.count
            if remainingCards == 0 { event = .winner }

            revision += 1

        }

    }

    private func moveDoubles(_ direction: GameSwipeDirection) -> Bool {

        var moved = false
        let rows = Array(game.grid.rowRange)
        let columns = Array(game.grid.colRange)

        switch direction {
        case .left:

            for row in rows {

                for column in columns { moved = moveDoubles(from: (row, column), to: (row, column - 1)) || moved }

            }

        case .right:

            for row in rows {

                for column in columns.reversed() { moved = moveDoubles(from: (row, column), to: (row, column + 1)) || moved }

            }

        case .up:

            for row in rows {

                for column in columns { moved = moveDoubles(from: (row, column), to: (row - 1, column)) || moved }

            }

        case .down:

            for row in rows.reversed() {

                for column in columns { moved = moveDoubles(from: (row, column), to: (row + 1, column)) || moved }

            }

        }

        return moved

    }

    private func moveDoubles(from start: Square, to end: Square) -> Bool {

        do {

            _ = try game.validateMove(start, end)
            return true

        } catch {

            return false

        }

    }

    private func resetWords() {

        wordsBag = Words.Letter.bag
        wordsRack = []
        selectedWordTile = nil
        fillWordsRack()

    }

    private func checkTicTacToeCompletion() {

        let combinations = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
        checkCompletion(combinations: combinations, emptyPiece: "")

    }

    private func checkFourCompletion() {

        var combinations: [[Int]] = []

        for row in 0..<6 {

            for column in 0...3 { combinations.append((0..<4).map { row * 7 + column + $0 }) }

        }

        for row in 0...2 {

            for column in 0..<7 { combinations.append((0..<4).map { (row + $0) * 7 + column }) }
            for column in 0...3 { combinations.append((0..<4).map { (row + $0) * 7 + column + $0 }) }
            for column in 3..<7 { combinations.append((0..<4).map { (row + $0) * 7 + column - $0 }) }

        }

        checkCompletion(combinations: combinations, emptyPiece: " ")

    }

    private func checkCompletion(combinations: [[Int]], emptyPiece: String) {

        let pieces = game.grid.content.flatMap { $0 }.compactMap { $0 as? String }

        for combination in combinations {

            let line = combination.map { pieces[$0] }
            guard let first = line.first, first != emptyPiece, line.allSatisfy({ $0 == first }) else { continue }
            event = .winner
            return

        }

        if !pieces.contains(emptyPiece) { event = .stalemate }

    }

    private func checkBombsweeperCompletion() {

        let pieces = game.grid.content.flatMap { $0 }.compactMap { $0 as? String }

        if pieces.contains("✘") {

            event = .gameOver

        } else if !pieces.contains("•") {

            event = .winner

        }

    }

}
