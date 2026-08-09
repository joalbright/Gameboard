import XCTest
import Observation
@testable import Games

final class GameboardCatalogTests: XCTestCase {

    func testCatalogContainsEveryBoardType() {

        XCTAssertEqual(Gameboard.BoardType.catalog, Gameboard.BoardType.allCases)
        XCTAssertEqual(Gameboard.BoardType.catalog.count, 14)

    }

    func testPlayableBoardsAreDerivedFromReadiness() {

        XCTAssertTrue(Gameboard.BoardType.playable.allSatisfy { $0.readiness == .ready })
        XCTAssertEqual(Set(Gameboard.BoardType.playable), Set(Gameboard.BoardType.allCases.filter { $0.readiness == .ready }))

    }

    func testInitialComingSoonClassification() {

        XCTAssertEqual(Gameboard.BoardType.backgammon.readiness, .ready)
        XCTAssertEqual(Gameboard.BoardType.mancala.readiness, .ready)
        XCTAssertEqual(Gameboard.BoardType.comingSoon, [])

    }

    func testReadyGameCanMakeAndResetMove() throws {

        var game = Gameboard(.tictactoe)

        try game.move(toSquare: (0, 0))

        XCTAssertEqual(game.grid[0, 0], TicTacToe.playerPieces[0])
        XCTAssertEqual(game.playerTurn, 1)

        game.reset()

        XCTAssertEqual(game.grid[0, 0], "")
        XCTAssertEqual(game.playerTurn, 1, "Reset currently preserves the active player; this records existing behavior for the migration.")

    }

    @MainActor func testSceneStateTracksLifecycle() {

        let state = GameboardSceneState()

        state.handle(.background)

        XCTAssertEqual(state.phase, .background)

    }

    func testBoardTypesRoundTripThroughSceneStorage() {

        for boardType in Gameboard.BoardType.allCases {

            XCTAssertEqual(Gameboard.BoardType(rawValue: boardType.rawValue), boardType)

        }

    }

    @MainActor func testGameSessionOwnsMutationAndValidationEvents() {

        let session = GameSession(.tictactoe)
        var observedGridChange = false

        withObservationTracking {

            _ = session.grid

        } onChange: {

            observedGridChange = true

        }

        session.move(to: (0, 0))

        XCTAssertEqual(session.grid[0, 0], TicTacToe.playerPieces[0])
        XCTAssertEqual(session.playerNumber, 2)
        XCTAssertNil(session.event)
        XCTAssertTrue(observedGridChange)

        session.move(to: (0, 0))

        XCTAssertEqual(session.event, .invalidMove(.invalidmove))

        session.dismissEvent()

        XCTAssertNil(session.event)

    }

    func testGridCellsHaveStableCoordinateIdentities() {

        let grid = Grid([["A", "B"], ["C", "D"]])
        let identities = grid.cols.flatMap { $0.rows.map(\.id) }

        XCTAssertEqual(Set(identities).count, 4)
        XCTAssertEqual(identities.first, Grid.CellID(row: 0, column: 0))
        XCTAssertEqual(identities.last, Grid.CellID(row: 1, column: 1))

    }

    func testGridCopiesHaveIndependentContent() {

        let original = Grid([["A", "B"]])
        var copy = original

        copy[0, 0] = "C"

        XCTAssertEqual(original[0, 0], "A")
        XCTAssertEqual(copy[0, 0], "C")

    }

    @MainActor func testTicTacToeSessionPublishesWinner() {

        let session = GameSession(.tictactoe)

        session.move(to: (0, 0))
        session.move(to: (1, 0))
        session.move(to: (0, 1))
        session.move(to: (1, 1))
        session.move(to: (0, 2))

        XCTAssertEqual(session.event, .winner)

        session.reset()

        XCTAssertNil(session.event)

    }

    @MainActor func testDotsCompletedSquareRetainsCurrentPlayer() {

        let session = GameSession(.dots)

        session.move(to: (0, 1))
        session.move(to: (1, 0))
        session.move(to: (1, 2))

        XCTAssertEqual(session.playerNumber, 2)

        session.move(to: (2, 1))

        XCTAssertEqual(session.grid[1, 1], Dots.playerPieces[1])
        XCTAssertEqual(session.playerNumber, 2)

    }

    @MainActor func testMancalaSowsStonesAndChangesPlayer() async {

        let session = GameSession(.mancala, mancalaMoveInterval: .zero)

        await session.sowMancala(from: (2, 0))

        XCTAssertEqual(session.grid[2, 0], "0")
        XCTAssertEqual(session.grid[3, 0], "4")
        XCTAssertEqual(session.grid[4, 0], "4")
        XCTAssertEqual(session.grid[5, 0], "4")
        XCTAssertEqual(session.playerNumber, 2)
        XCTAssertNil(session.event)

    }

    func testBackgammonInitialStateMatchesBoardLayout() {

        let state = Backgammon.State()

        XCTAssertEqual(state.checkerCount(at: 24, for: 0), 2)
        XCTAssertEqual(state.checkerCount(at: 13, for: 0), 5)
        XCTAssertEqual(state.checkerCount(at: 1, for: 1), 2)
        XCTAssertEqual(state.checkerCount(at: 12, for: 1), 5)
        XCTAssertEqual(state.grid.content, Backgammon.board.content)

    }

    func testBackgammonHitsBlotAndMovesItToBar() throws {

        var points = 24 ✕ 0
        points[7] = 1
        points[4] = -1

        var state = Backgammon.State(points: points, dice: [3])
        let move = try XCTUnwrap(state.legalMoves(for: 0).first { $0.source == .point(8) && $0.destination == .point(5) })

        state.apply(move, for: 0)

        XCTAssertEqual(state.checkerCount(at: 5, for: 0), 1)
        XCTAssertEqual(state.checkerCount(at: 5, for: 1), 0)
        XCTAssertEqual(state.bar, [0,1])

    }

    func testBackgammonRequiresBarEntryBeforeOtherMoves() {

        var points = 24 ✕ 0
        points[7] = 1

        let state = Backgammon.State(points: points, bar: [1,0], dice: [3])
        let moves = state.legalMoves(for: 0)

        XCTAssertFalse(moves.isEmpty)
        XCTAssertTrue(moves.allSatisfy { $0.source == .bar })
        XCTAssertEqual(moves.first?.destination, .point(22))

    }

    func testBackgammonBearsOffFromHomeBoard() throws {

        var points = 24 ✕ 0
        points[0] = 14
        points[1] = 1

        var state = Backgammon.State(points: points, dice: [2])
        let move = try XCTUnwrap(state.legalMoves(for: 0).first { $0.source == .point(2) && $0.destination == .borneOff })

        state.apply(move, for: 0)

        XCTAssertEqual(state.borneOff, [1,0])
        XCTAssertEqual(state.checkerCount(at: 2, for: 0), 0)

    }

    func testBackgammonDoublesProvideFourMoves() {

        var state = Backgammon.State()

        state.roll(4, 4)

        XCTAssertEqual(state.dice, [4,4,4,4])

    }

    func testBackgammonRequiresHigherDieWhenOnlyOneCanBePlayed() {

        var points = 24 ✕ 0
        points[7] = 1
        points[0] = -2

        let state = Backgammon.State(points: points, dice: [3,4])
        let moves = state.legalMoves(for: 0)

        XCTAssertEqual(moves, [Backgammon.Move(source: .point(8), destination: .point(4), die: 4)])

    }

    @MainActor func testBackgammonSessionRollsSelectsAndMoves() {

        let session = GameSession(.backgammon, backgammonRoll: { (3,4) })

        session.rollBackgammonDice()

        XCTAssertEqual(session.backgammonDice, [3,4])

        session.selectBackgammonPoint(8)

        XCTAssertEqual(session.selectedBackgammonPoint, 8)
        XCTAssertEqual(Set(session.highlightedBackgammonPoints), Set([4,5]))

        session.selectBackgammonPoint(5)

        XCTAssertEqual(session.backgammonDice, [4])
        XCTAssertEqual(session.grid[11, 7], Backgammon.playerPieces[0])

    }

    @MainActor func testMancalaStoreGrantsAnotherTurn() async {

        let session = GameSession(.mancala, mancalaMoveInterval: .zero)

        await session.sowMancala(from: (3, 0))

        XCTAssertEqual(session.grid[5, 1], "1")
        XCTAssertEqual(session.playerNumber, 1)

    }

    @MainActor func testMancalaPublishesPickupBeforePlacementIntervals() async {

        let session = GameSession(.mancala, mancalaMoveInterval: .seconds(10))
        let sow = Task { await session.sowMancala(from: (3, 0)) }

        await Task.yield()

        XCTAssertEqual(session.grid[3, 0], "0")
        XCTAssertEqual(session.grid[4, 0], "3")
        XCTAssertEqual(session.playerNumber, 1)
        XCTAssertTrue(session.isMancalaMoving)

        sow.cancel()
        await sow.value

        XCTAssertFalse(session.isMancalaMoving)

    }

    func testMancalaCapturesOppositePit() throws {

        var grid = Grid([

            ["0","0","1"],
            ["1"," ","0"],
            ["0"," ","4"],
            ["0"," ","0"],
            ["0"," ","0"],
            ["0","0","1"]

        ])

        _ = try Mancala.validateMove((1, 0), "1", &grid, 0)

        XCTAssertEqual(grid[2, 0], "0")
        XCTAssertEqual(grid[2, 2], "0")
        XCTAssertEqual(grid[5, 1], "5")

    }

    func testMancalaSweepsRemainingStonesAtGameEnd() throws {

        var grid = Grid([

            ["0","0","2"],
            ["0"," ","2"],
            ["0"," ","2"],
            ["0"," ","2"],
            ["0"," ","2"],
            ["1","0","2"]

        ])

        _ = try Mancala.validateMove((5, 0), "1", &grid, 0)

        XCTAssertTrue(Mancala.isComplete(grid))
        XCTAssertEqual(Mancala.score(for: 0, in: grid), 1)
        XCTAssertEqual(Mancala.score(for: 1, in: grid), 12)

    }

    func testDotsSegmentsMatchOpenLineCoordinates() {

        let grid = Dots.board

        for row in grid.rowRange {

            for column in grid.colRange {

                XCTAssertEqual(Dots.isSegment((row, column)), grid[row, column] == "0")

            }

        }

    }

    @MainActor func testDoublesSwipeAddsTileThenSettlesAndMerges() async {

        let session = GameSession(.doubles, testing: true, doublesMoveInterval: .zero, doublesNewTile: (0, 3))

        await session.swipe(.left)

        XCTAssertEqual(session.grid[0, 0], "4")
        XCTAssertEqual(session.grid[0, 1], " ")
        XCTAssertEqual(session.grid[0, 2], " ")
        XCTAssertEqual(session.grid[0, 3], " ")
        XCTAssertFalse(session.isDoublesMoving)

    }

    @MainActor func testDoublesPublishesNewTileBeforeMovementTicks() async {

        let session = GameSession(.doubles, testing: true, doublesMoveInterval: .seconds(10), doublesNewTile: (0, 3))
        let swipe = Task { await session.swipe(.left) }

        await Task.yield()

        XCTAssertEqual(session.grid[0, 2], "2")
        XCTAssertEqual(session.grid[0, 3], "2")
        XCTAssertTrue(session.isDoublesMoving)

        swipe.cancel()
        await swipe.value

        XCTAssertFalse(session.isDoublesMoving)

    }

    func testDoublesDoesNotLoopWhenBoardIsFull() {

        var grid = Grid(4 ✕ (4 ✕ "2"))

        XCTAssertFalse(Doubles.random(&grid))

    }

    @MainActor func testFourSessionDropsPiecesByColumn() async {

        let session = GameSession(.four, fourDropInterval: .zero)

        await session.drop(inColumn: 2)
        await session.drop(inColumn: 2)

        XCTAssertEqual(session.grid[5, 2], Four.playerPieces[0])
        XCTAssertEqual(session.grid[4, 2], Four.playerPieces[1])
        XCTAssertFalse(session.isFourDropping)

    }

    @MainActor func testFourSessionPublishesTopRowBeforePieceSettles() async {

        let session = GameSession(.four, fourDropInterval: .seconds(10))
        let drop = Task { await session.drop(inColumn: 3) }

        await Task.yield()

        XCTAssertEqual(session.grid[0, 3], Four.playerPieces[0])
        XCTAssertEqual(session.playerNumber, 1)
        XCTAssertTrue(session.isFourDropping)

        await session.drop(inColumn: 4)
        XCTAssertEqual(session.grid[0, 4], " ")

        drop.cancel()
        await drop.value

        XCTAssertFalse(session.isFourDropping)

    }

    @MainActor func testSelectionSessionPublishesAvailableMoves() {

        let session = GameSession(.checkers)

        session.selectOrMove(at: (2, 3))

        XCTAssertEqual(session.selected?.c, 2)
        XCTAssertEqual(session.selected?.r, 3)
        XCTAssertFalse(session.highlights.isEmpty)

    }

    @MainActor func testWordsSessionOwnsRackAndPlacement() {

        let session = GameSession(.words)
        let tile = try! XCTUnwrap(session.wordsRack.first { $0 != .none })

        session.chooseWordTile(tile)
        session.placeSelectedWordTile(at: (7, 7))

        XCTAssertEqual(session.grid[7, 7], tile.rawValue.uppercased())
        XCTAssertNil(session.selectedWordTile)
        XCTAssertEqual(session.wordsRack.filter { $0 == .none }.count, 1)

    }

    @MainActor func testBombsweeperAndMemoryInteractionsMutateVisibleState() {

        let bombsweeper = GameSession(.bombsweeper, testing: true)
        let memory = GameSession(.memory, testing: true)

        bombsweeper.guess(at: (0, 0))
        memory.selectMemoryCard(at: (0, 0))

        XCTAssertNotEqual(bombsweeper.grid[0, 0], "•")
        XCTAssertNotEqual(memory.grid[0, 0], "🂠")
        XCTAssertEqual(memory.selected?.c, 0)
        XCTAssertEqual(memory.selected?.r, 0)

    }

    @MainActor func testSudokuSessionAcceptsSolutionAtEveryEmptyCoordinate() throws {

        let session = GameSession(.sudoku, testing: true)
        let solution = Sudoku.staticboard

        for row in session.grid.rowRange {

            for column in session.grid.colRange where session.grid[row, column] == "" {

                let guess = solution[row, column]
                session.guess(at: (row, column), with: guess)

                XCTAssertNil(session.event, "Expected \(guess) at row \(row), column \(column) to be accepted.")
                XCTAssertEqual(session.grid[row, column], guess)

            }

        }

    }

    @MainActor func testSudokuNumberSelectionPersistsAfterGuess() throws {

        let session = GameSession(.sudoku, testing: true)
        let solution = Sudoku.staticboard
        let square = try XCTUnwrap(session.grid.rowRange.lazy.flatMap { row in session.grid.colRange.map { (row, $0) } }.first { session.grid[$0.0, $0.1] == "" })
        let number = try XCTUnwrap(Int(solution[square.0, square.1]))

        session.selectSudokuNumber(number)
        session.guess(at: square, with: "\(number)")

        XCTAssertEqual(session.selectedSudokuNumber, number)
        XCTAssertEqual(session.grid[square.0, square.1], "\(number)")

    }

    @MainActor func testDifficultyDefaultsToEasyAndRegeneratesSupportedBoards() {

        let bombsweeper = GameSession(.bombsweeper)
        let memory = GameSession(.memory)
        let sudoku = GameSession(.sudoku)

        XCTAssertEqual(bombsweeper.difficulty, .easy)
        XCTAssertEqual(memory.difficulty, .easy)
        XCTAssertEqual(sudoku.difficulty, .easy)

        bombsweeper.selectDifficulty(.hard)
        memory.selectDifficulty(.medium)
        sudoku.selectDifficulty(.hard)

        XCTAssertEqual(bombsweeper.grid.content.count, 20)
        XCTAssertEqual(bombsweeper.grid.content.first?.count, 20)
        XCTAssertEqual(memory.grid.content.count, 6)
        XCTAssertEqual(memory.grid.content.first?.count, 6)
        XCTAssertEqual(sudoku.grid.content.flatMap { $0 }.filter(\.isEmpty).count, 72)

    }

}

private extension Gameboard.BoardType {

    static var comingSoon: [Self] { allCases.filter { $0.readiness == .comingSoon } }

}
