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
        let observedGridChange = expectation(description: "Grid mutation is observed")

        withObservationTracking {

            _ = session.grid

        } onChange: {

            observedGridChange.fulfill()

        }

        session.move(to: (0, 0))

        XCTAssertEqual(session.grid[0, 0], TicTacToe.playerPieces[0])
        XCTAssertEqual(session.playerNumber, 2)
        XCTAssertNil(session.event)
        wait(for: [observedGridChange], timeout: 1)

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

        let session = GameSession(.backgammon, backgammonRoll: { (4,3) })

        session.rollBackgammonDice()

        XCTAssertEqual(session.backgammonDice, [4,3])

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

        XCTAssertEqual(session.grid[7, 7], tile == .blank ? "A" : tile.rawValue.uppercased())
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

                if session.grid.content.flatMap({ $0 }).contains("") {

                    XCTAssertNil(session.event, "Expected \(guess) at row \(row), column \(column) to be accepted.")

                }

                XCTAssertEqual(session.grid[row, column], guess)

            }

        }

        XCTAssertEqual(session.result, .winner(player: 1))

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
        let clues = sudoku.grid.content.flatMap { $0 }.filter { !$0.isEmpty }.count
        XCTAssertGreaterThanOrEqual(clues, Difficulty.hard.sudokuClues)
        XCTAssertLessThan(clues, 81)
        XCTAssertEqual(Sudoku.solutionCount(sudoku.grid), 1)

    }

    @MainActor func testFinishedTicTacToeKeepsWinnerAndRejectsMovesUntilReset() {

        let session = GameSession(.tictactoe)
        for square: Square in [(0,0), (1,0), (0,1), (1,1), (0,2)] { session.move(to: square) }
        XCTAssertEqual(session.result, .winner(player: 1))
        XCTAssertTrue(session.isFinished)
        let board = session.grid.content
        session.dismissEvent()
        session.move(to: (2,2))
        XCTAssertEqual(session.grid.content, board)
        XCTAssertNil(session.event)
        XCTAssertEqual(session.result, .winner(player: 1))

        session.reset()
        XCTAssertNil(session.result)
        XCTAssertFalse(session.isFinished)
        session.move(to: (2,2))
        XCTAssertFalse(session.grid[2,2].isEmpty)

    }

    @MainActor func testTicTacToeDrawIsPersistent() {

        let session = GameSession(.tictactoe)
        for square: Square in [(0,0), (0,1), (0,2), (1,1), (1,0), (1,2), (2,1), (2,0), (2,2)] { session.move(to: square) }
        XCTAssertEqual(session.result, .draw)
        session.dismissEvent()
        XCTAssertEqual(session.result, .draw)

    }

    @MainActor func testFourRecordsWinningPlayerAndRejectsFurtherDrops() async {

        let session = GameSession(.four, fourDropInterval: .zero)
        for column in [0,1,0,1,0,1,0] { await session.drop(inColumn: column) }
        XCTAssertEqual(session.result, .winner(player: 1))
        XCTAssertEqual(session.playerNumber, 2)
        let board = session.grid.content
        session.dismissEvent()
        await session.drop(inColumn: 2)
        XCTAssertEqual(session.grid.content, board)
        XCTAssertNil(session.event)

    }

    @MainActor func testBombsweeperFlagsAloneCannotWin() {

        let session = GameSession(.bombsweeper)

        for row in session.grid.rowRange {

            for column in session.grid.colRange { session.mark(at: (row,column)) }

        }

        XCTAssertNil(session.result)
        XCTAssertNil(session.event)

    }

    @MainActor func testBombsweeperWinsByRevealingSafeSquaresWithoutFlaggingMines() {

        let session = GameSession(.bombsweeper, testing: true)
        let solution = Bombsweeper.staticboard

        for row in solution.rowRange {

            for column in solution.colRange where solution[row,column] != "•" && session.grid[row,column] == "•" { session.guess(at: (row,column)) }

        }

        XCTAssertEqual(session.result, .winner(player: 1))
        XCTAssertEqual(session.grid[1,0], "•")
        session.selectDifficulty(.medium)
        XCTAssertNil(session.result)
        XCTAssertFalse(session.isFinished)
        XCTAssertEqual(session.grid.content.count, 15)

    }

    @MainActor func testBombsweeperWronglyFlaggedSafeSquarePreventsVictory() {

        let session = GameSession(.bombsweeper, testing: true)
        let solution = Bombsweeper.staticboard
        session.mark(at: (0,0))

        for row in solution.rowRange {

            for column in solution.colRange where solution[row,column] != "•" && session.grid[row,column] == "•" { session.guess(at: (row,column)) }

        }

        XCTAssertNil(session.result)
        XCTAssertEqual(session.grid[0,0], "⚑")
        session.mark(at: (0,0))
        session.guess(at: (0,0))
        XCTAssertEqual(session.result, .winner(player: 1))

    }

    @MainActor func testBombsweeperLossBlocksFurtherInput() {

        let session = GameSession(.bombsweeper, testing: true)
        session.guess(at: (1,0))
        XCTAssertEqual(session.result, .loss)
        let board = session.grid.content
        session.dismissEvent()
        session.guess(at: (0,0))
        session.mark(at: (0,1))
        XCTAssertEqual(session.grid.content, board)
        XCTAssertNil(session.event)

    }

    func testBombsweeperFlaggedMineCannotBeRevealed() throws {

        let solution = Bombsweeper.staticboard
        var field = Bombsweeper.field
        try Bombsweeper.validateMark((1,0), &field, solution)
        XCTAssertThrowsError(try Bombsweeper.validateGuess((1,0), &field, solution)) { error in

            XCTAssertEqual(error as? MoveError, .invalidmove)

        }
        XCTAssertEqual(field[1,0], "⚑")

    }

    func testBombsweeperFloodFillPreservesFlaggedSafeSquares() throws {

        let solution = Bombsweeper.addBombCount(Grid([[" "," "," "], [" "," "," "], [" "," ","•"]]))
        var field = Grid(3 ✕ (3 ✕ "•"))
        try Bombsweeper.validateMark((0,1), &field, solution)
        try Bombsweeper.validateGuess((0,0), &field, solution)
        XCTAssertEqual(field[0,1], "⚑")
        XCTAssertEqual(field[1,1], "1")
        XCTAssertEqual(field[2,2], "•")

    }

    func testGeneratedSudokuPuzzlesHaveOneSolutionAtEveryDifficulty() {

        for difficulty in Difficulty.allCases {

            for _ in 0..<10 {

                let solution = Sudoku.board
                let puzzle = Sudoku.puzzle(solution, difficulty: difficulty)
                XCTAssertEqual(Sudoku.solutionCount(puzzle), 1, "\(difficulty.name) puzzle must have exactly one solution")

                for row in 0..<9 {

                    for column in 0..<9 where !puzzle[row,column].isEmpty { XCTAssertEqual(puzzle[row,column], solution[row,column]) }

                }

            }

        }

    }

    func testSudokuSolutionCounterRejectsInvalidAndDetectsAmbiguousBoards() {

        XCTAssertEqual(Sudoku.solutionCount(Sudoku.staticboard), 1)
        XCTAssertEqual(Sudoku.solutionCount(Grid(9 ✕ (9 ✕ ""))), 2)
        var invalid = Sudoku.staticboard
        invalid[0,0] = invalid[0,1]
        XCTAssertEqual(Sudoku.solutionCount(invalid), 0)

    }

    func testSudokuCluesCannotBeChangedOrMarkedAsPlayerGuesses() {

        var game = Gameboard(.sudoku, testing: true)
        let original = game.grid.content
        XCTAssertThrowsError(try game.guess(toSquare: (0,1), withGuess: game.solution[0,1]))
        XCTAssertEqual(game.grid.content, original)
        XCTAssertTrue(game.highlights.isEmpty)

    }

    func testCheckersCannotJumpOwnKing() {

        var game = Gameboard(.checkers)
        game.grid = Grid(8 ✕ (8 ✕ ""))
        game.grid[2,1] = "●"
        game.grid[3,2] = "◉"
        let original = game.grid.content
        XCTAssertThrowsError(try game.move(pieceAt: (2,1), toSquare: (4,3)))
        XCTAssertEqual(game.grid.content, original)
        XCTAssertEqual(game.playerTurn, 0)

    }

    func testCheckersMustCaptureInsteadOfMovingAnotherPiece() {

        var game = Gameboard(.checkers)
        game.grid = Grid(8 ✕ (8 ✕ ""))
        game.grid[2,1] = "●"
        game.grid[3,2] = "○"
        game.grid[2,5] = "●"
        let original = game.grid.content
        XCTAssertThrowsError(try game.move(pieceAt: (2,5), toSquare: (3,4)))
        game.showAvailable((2,5))
        XCTAssertTrue(game.highlights.isEmpty)
        XCTAssertEqual(game.grid.content, original)
        XCTAssertNoThrow(try game.move(pieceAt: (2,1), toSquare: (4,3)))

    }

    func testCheckersMultipleJumpsKeepTurnAndLockTheCapturingPiece() throws {

        var game = Gameboard(.checkers)
        game.grid = Grid(8 ✕ (8 ✕ ""))
        game.grid[1,0] = "●"
        game.grid[2,1] = "○"
        game.grid[4,3] = "○"
        game.grid[1,4] = "●"
        _ = try game.move(pieceAt: (1,0), toSquare: (3,2))
        XCTAssertEqual(game.playerTurn, 0)
        XCTAssertEqual(game.checkersContinuation?.0, 3)
        XCTAssertEqual(game.checkersContinuation?.1, 2)
        XCTAssertEqual(game.selected?.0, 3)
        XCTAssertTrue(game.highlights.contains { $0 == (5,4) })
        let afterFirstJump = game.grid.content
        XCTAssertThrowsError(try game.move(pieceAt: (1,4), toSquare: (2,5)))
        XCTAssertThrowsError(try game.move(pieceAt: (3,2), toSquare: (4,1)))
        XCTAssertEqual(game.grid.content, afterFirstJump)
        game.showAvailable((1,4))
        XCTAssertEqual(game.selected?.0, 3)
        XCTAssertEqual(game.grid.content, afterFirstJump)
        _ = try game.move(pieceAt: (3,2), toSquare: (5,4))
        XCTAssertEqual(game.playerTurn, 1)
        XCTAssertNil(game.checkersContinuation)
        XCTAssertEqual(game.grid[2,1], "")
        XCTAssertEqual(game.grid[4,3], "")

    }

    func testCheckersPromotionEndsCaptureTurnEvenWithNewKingJumpAvailable() throws {

        var game = Gameboard(.checkers)
        game.grid = Grid(8 ✕ (8 ✕ ""))
        game.grid[5,0] = "●"
        game.grid[6,1] = "○"
        game.grid[6,3] = "○"
        _ = try game.move(pieceAt: (5,0), toSquare: (7,2))
        XCTAssertEqual(game.grid[7,2], "◉")
        XCTAssertEqual(game.playerTurn, 1)
        XCTAssertNil(game.checkersContinuation)
        XCTAssertEqual(game.grid[6,3], "○")

        game.reset()
        game.grid = Grid(8 ✕ (8 ✕ ""))
        game.playerTurn = 1
        game.grid[1,2] = "○"
        _ = try game.move(pieceAt: (1,2), toSquare: (0,1))
        XCTAssertEqual(game.grid[0,1], "◎")
        XCTAssertEqual(game.playerTurn, 0)

    }

    func testChessInitialLegalMoveCountsMatchReference() throws {

        let grid = Chess.board
        let state = Chess.State()
        let moves = Chess.legalMoves(for: 0, in: grid, state: state)
        XCTAssertEqual(moves.count, 20)
        var replies = 0

        for (start, end) in moves {

            let next = try Chess.applying(start, to: end, in: grid, state: state)
            replies += Chess.legalMoves(for: 1, in: next.grid, state: next.state).count

        }

        XCTAssertEqual(replies, 400)

    }

    func testChessRejectsPinnedMovesAndAdjacentKings() {

        var grid = Grid(8 ✕ (8 ✕ ""))
        grid[0,4] = "♚"
        grid[0,5] = "♝"
        grid[0,7] = "♖"
        grid[7,4] = "♔"
        XCTAssertThrowsError(try Chess.applying((0,5), to: (1,6), in: grid, state: Chess.State()))
        grid = Grid(8 ✕ (8 ✕ ""))
        grid[0,4] = "♚"
        grid[2,4] = "♔"
        XCTAssertThrowsError(try Chess.applying((0,4), to: (1,4), in: grid, state: Chess.State()))

    }

    func testChessCastlesAndRejectsCastlingThroughCheck() throws {

        var grid = Grid(8 ✕ (8 ✕ ""))
        grid[0,4] = "♚"
        grid[0,7] = "♜"
        grid[7,4] = "♔"
        let castled = try Chess.applying((0,4), to: (0,6), in: grid, state: Chess.State())
        XCTAssertEqual(castled.grid[0,6], "♚")
        XCTAssertEqual(castled.grid[0,5], "♜")
        XCTAssertEqual(castled.grid[0,7], "")
        grid[7,5] = "♖"
        XCTAssertThrowsError(try Chess.applying((0,4), to: (0,6), in: grid, state: Chess.State()))
        grid[7,5] = ""
        var state = Chess.State()
        state.castlingRights.remove(7)
        XCTAssertThrowsError(try Chess.applying((0,4), to: (0,6), in: grid, state: state))

    }

    func testChessEnPassantCapturesAndCannotExposeKing() throws {

        var game = Gameboard(.chess)
        game.grid = Grid(8 ✕ (8 ✕ ""))
        game.grid[0,0] = "♚"
        game.grid[7,7] = "♔"
        game.grid[4,3] = "♟"
        game.grid[6,4] = "♙"
        game.playerTurn = 1
        _ = try game.move(pieceAt: (6,4), toSquare: (4,4))
        let before = game.grid.content
        game.showAvailable((4,3))
        XCTAssertEqual(game.grid.content, before)
        XCTAssertTrue(game.highlights.contains { $0 == (5,4) })
        _ = try game.move(pieceAt: (4,3), toSquare: (5,4))
        XCTAssertEqual(game.grid[4,4], "")
        XCTAssertEqual(game.grid[5,4], "♟")

        var exposed = Grid(before)
        exposed[0,0] = ""
        exposed[4,0] = "♚"
        exposed[4,7] = "♖"
        var state = Chess.State()
        state.enPassant = (5,4)
        XCTAssertThrowsError(try Chess.applying((4,3), to: (5,4), in: exposed, state: state))

    }

    func testChessSupportsAllPromotionChoices() throws {

        var grid = Grid(8 ✕ (8 ✕ ""))
        grid[0,4] = "♚"
        grid[7,4] = "♔"
        grid[6,2] = "♟"

        for promotion in Chess.Promotion.allCases {

            let move = try Chess.applying((6,2), to: (7,2), in: grid, state: Chess.State(), promotion: promotion)
            XCTAssertEqual(move.grid[7,2], promotion.piece(for: 0))
            XCTAssertEqual(move.state.halfMoves, 0)

        }

    }

    @MainActor func testChessCheckmateAndStalemateFinishSessions() {

        let mate = GameSession(.chess)
        let moves: [(Square, Square)] = [((1,5),(2,5)), ((6,4),(4,4)), ((1,6),(3,6)), ((7,3),(3,7))]
        for move in moves { mate.move(from: move.0, to: move.1) }
        XCTAssertEqual(mate.result, .winner(player: 2))

        var game = Gameboard(.chess)
        game.grid = Grid(8 ✕ (8 ✕ ""))
        game.grid[0,0] = "♚"
        game.grid[2,1] = "♔"
        game.grid[2,2] = "♕"
        game.playerTurn = 1
        let stalemate = GameSession(game: game)
        stalemate.move(from: (2,2), to: (1,2))
        XCTAssertEqual(stalemate.result, .draw)

    }

    @MainActor func testChessRepetitionClaimsAndAutomaticFivefoldDraw() {

        let cycle: [(Square, Square)] = [((0,6),(2,5)), ((7,6),(5,5)), ((2,5),(0,6)), ((5,5),(7,6))]
        let claim = GameSession(.chess)

        for _ in 0..<2 {

            for move in cycle { claim.move(from: move.0, to: move.1) }

        }

        XCTAssertTrue(claim.canClaimDraw)
        XCTAssertNil(claim.result)
        claim.claimDraw()
        XCTAssertEqual(claim.result, .draw)
        let automatic = GameSession(.chess)

        for _ in 0..<4 {

            for move in cycle { automatic.move(from: move.0, to: move.1) }

        }

        XCTAssertEqual(automatic.result, .draw)

    }

    @MainActor func testChessFiftyAndSeventyFiveMoveRules() {

        for halfMoves in [99,149] {

            var game = Gameboard(.chess)
            game.grid = Grid(8 ✕ (8 ✕ ""))
            game.grid[0,4] = "♚"
            game.grid[0,0] = "♜"
            game.grid[7,4] = "♔"
            game.chessState.halfMoves = halfMoves
            let session = GameSession(game: game)
            session.move(from: (0,0), to: (1,0))

            if halfMoves == 99 {

                XCTAssertTrue(session.canClaimDraw)
                XCTAssertNil(session.result)
                session.claimDraw()

            }

            XCTAssertEqual(session.result, .draw)

        }

    }

    func testGoSuicideIsRejectedButCapturingOutOfSuicideIsLegal() throws {

        var grid = Grid([["","○",""], ["○","","○"], ["","○",""]])
        let before = grid.content
        XCTAssertThrowsError(try Go.validateMove((1,1), "", &grid, 0))
        XCTAssertEqual(grid.content, before)
        grid = Grid([["","○"], ["○","●"]])
        try Go.validateMove((0,0), "", &grid, 0)
        XCTAssertEqual(grid[0,1], "")
        XCTAssertEqual(grid[1,0], "")
        XCTAssertEqual(grid[0,0], "●")

    }

    func testGoKoRejectsImmediateRecaptureAndAllowsAfterBoardChanges() throws {

        var game = Gameboard(.go)
        game.grid = Grid(5 ✕ (5 ✕ ""))
        for square: Square in [(1,2), (2,1), (3,2)] { game.grid[square.0,square.1] = "●" }
        for square: Square in [(2,2), (1,3), (2,4), (3,3)] { game.grid[square.0,square.1] = "○" }
        game.goPositions = [Go.positionKey(game.grid)]
        try game.move(toSquare: (2,3))
        let before = game.grid.content
        XCTAssertThrowsError(try game.move(toSquare: (2,2)))
        XCTAssertEqual(game.grid.content, before)
        XCTAssertEqual(game.playerTurn, 1)
        try game.move(toSquare: (0,0))
        try game.move(toSquare: (4,4))
        XCTAssertNoThrow(try game.move(toSquare: (2,2)))

    }

    func testGoAreaScoringKeepsMixedBorderRegionsNeutral() {

        let grid = Grid([["●","","○"], ["●","","○"]])
        XCTAssertEqual(Go.areaScores(grid, komi: 6.5), [2,8.5])
        let empty = Grid(3 ✕ (3 ✕ ""))
        XCTAssertEqual(Go.areaScores(empty, komi: 0.5), [0,0.5])

    }

    @MainActor func testGoRequiresTwoPassesAndBothScoreApprovals() {

        let session = GameSession(.go)
        session.move(to: (4,4))
        session.passGoTurn()
        XCTAssertFalse(session.isReviewingGoScore)
        session.passGoTurn()
        XCTAssertTrue(session.isReviewingGoScore)
        XCTAssertNil(session.result)
        session.acceptGoScore()
        XCTAssertNil(session.result)
        session.move(to: (4,4))
        XCTAssertEqual(session.goDeadStones.count, 1)
        session.acceptGoScore()
        XCTAssertNil(session.result, "Changing dead groups invalidates both prior approvals")
        session.acceptGoScore()
        XCTAssertEqual(session.result, .winner(player: 2))
        XCTAssertEqual(session.grid[4,4], "")

    }

    @MainActor func testGoCanResumeScoringWithoutRemovingMarkedStones() {

        let session = GameSession(.go)
        session.selectGoKomi(7.5)
        session.move(to: (4,4))
        session.selectGoKomi(0.5)
        XCTAssertEqual(session.goKomi, 7.5)
        session.passGoTurn()
        session.passGoTurn()
        session.move(to: (4,4))
        session.resumeGoPlay()
        XCTAssertFalse(session.isReviewingGoScore)
        XCTAssertTrue(session.goDeadStones.isEmpty)
        XCTAssertEqual(session.grid[4,4], "●")
        session.passGoTurn()
        XCTAssertFalse(session.isReviewingGoScore)

    }

    @MainActor func testCheckersCanClaimThreefoldRepetition() {

        var game = Gameboard(.checkers)
        game.grid = Grid(8 ✕ (8 ✕ ""))
        game.grid[0,1] = "◉"
        game.grid[7,6] = "◎"
        let session = GameSession(game: game)
        let cycle: [(Square, Square)] = [((0,1),(1,0)), ((7,6),(6,7)), ((1,0),(0,1)), ((6,7),(7,6))]

        for _ in 0..<2 {

            for move in cycle { session.move(from: move.0, to: move.1) }

        }

        XCTAssertTrue(session.canClaimDraw)
        session.claimDraw()
        XCTAssertEqual(session.result, .draw)

    }

    @MainActor func testBackgammonOpeningChoosesHigherPlayerAndRerollsTies() {

        var rolls = [(3,3), (2,5)]
        let session = GameSession(.backgammon, backgammonRoll: { rolls.removeFirst() })
        session.rollBackgammonDice()
        XCTAssertTrue(session.backgammonDice.isEmpty)
        XCTAssertTrue(session.canRollBackgammonDice)
        session.dismissEvent()
        session.rollBackgammonDice()
        XCTAssertEqual(session.playerNumber, 2)
        XCTAssertEqual(session.backgammonDice, [2,5])

    }

    @MainActor func testDotsCompletesByBoxScoresRatherThanLineCounts() {

        var game = Gameboard(.dots)

        for row in 0..<17 {

            for column in 0..<17 where game.grid[row,column] == "0" || game.grid[row,column] == " " { game.grid[row,column] = "1" }

        }

        game.grid[16,15] = "0"
        game.grid[15,15] = " "
        let session = GameSession(game: game)
        session.move(to: (16,15))
        XCTAssertEqual(session.dotsScores, [64,0])
        XCTAssertEqual(session.result, .winner(player: 1))

    }

    @MainActor func testDoublesRecognizesBlockedBoardAndTargetTile() async {

        var game = Gameboard(.doubles)
        game.grid = Grid([["2","4","8","16"], ["4","8","16","2"], ["8","16","2","4"], ["16","2","4","8"]])
        let blocked = GameSession(game: game)
        await blocked.swipe(.left)
        XCTAssertEqual(blocked.result, .loss)
        game.grid[0,0] = "1024"
        game.grid[0,1] = "1024"
        let winner = GameSession(game: game)
        await winner.swipe(.left)
        XCTAssertEqual(winner.result, .winner(player: 1))
        XCTAssertGreaterThanOrEqual(winner.doublesScore, 2048)

    }

    @MainActor func testPegsRecognizesOnePegAndBlockedLoss() {

        var game = Gameboard(.pegs)

        for row in game.grid.rowRange {

            for column in game.grid.colRange where game.grid[row,column] == "●" { game.grid[row,column] = " " }

        }

        game.grid[3,0] = "●"
        game.grid[3,1] = "●"
        let winner = GameSession(game: game)
        winner.move(from: (3,0), to: (3,2))
        XCTAssertEqual(winner.result, .winner(player: 1))
        game.grid[0,2] = "●"
        let loser = GameSession(game: game)
        loser.move(from: (3,0), to: (3,2))
        XCTAssertEqual(loser.result, .loss)

    }

    func testWordsRequiresCenterConnectedContiguousValidWords() throws {

        var game = Words.State(racks: [[.c,.a,.t], [.q]], bag: [])
        try game.stage(.c, at: (0,0))
        try game.stage(.a, at: (0,1))
        XCTAssertThrowsError(try game.evaluate(accepts: { _ in true }))
        game.recall()
        try game.stage(.c, at: (7,7))
        try game.stage(.t, at: (7,9))
        XCTAssertThrowsError(try game.evaluate(accepts: { _ in true }))
        game.recall()
        try game.stage(.c, at: (7,6))
        try game.stage(.a, at: (7,7))
        try game.stage(.t, at: (7,8))
        XCTAssertThrowsError(try game.submit(accepts: { _ in false }))
        XCTAssertEqual(game.player, 0)
        XCTAssertEqual(game.pending.count, 3)
        XCTAssertEqual(try game.evaluate(accepts: { $0 == "CAT" }).score, 6)
        try game.submit(accepts: { $0 == "CAT" })
        XCTAssertTrue(game.isComplete)
        XCTAssertEqual(game.scores, [16,-10])

    }

    func testWordsScoresCrossWordsAndUsesPremiumOnlyOnce() throws {

        let tiles = [114: Words.Tile(letter: .o, original: .o, rackIndex: 0), 115: Words.Tile(letter: .n, original: .n, rackIndex: 1)]
        var game = Words.State(racks: [[.t,.o], [.t]], bag: [.e,.e,.e,.e,.e,.e,.e], tiles: tiles)
        try game.stage(.t, at: (6,9))
        try game.stage(.o, at: (6,10))
        let first = try game.evaluate(accepts: { ["TO","ON"].contains($0) })
        XCTAssertEqual(first.words.count, 3)
        XCTAssertEqual(first.score, 9)
        try game.submit(accepts: { ["TO","ON"].contains($0) })
        XCTAssertEqual(game.player, 1)
        try game.stage(.t, at: (5,10))
        XCTAssertEqual(try game.evaluate(accepts: { $0 == "TON" }).score, 4)

    }

    func testWordsBlankHasNoValueAndRecallRestoresRack() throws {

        var game = Words.State(racks: [[.blank,.a,.t], [.q]], bag: [])
        try game.stage(.blank, at: (7,6), blank: .c)
        try game.stage(.a, at: (7,7))
        try game.stage(.t, at: (7,8))
        XCTAssertEqual(try game.evaluate(accepts: { $0 == "CAT" }).score, 2)
        XCTAssertThrowsError(try game.pass())
        game.recall()
        XCTAssertEqual(Array(game.racks[0].prefix(3)), [.blank,.a,.t])
        XCTAssertEqual(game.grid[7,7], "★")
        XCTAssertTrue(game.pending.isEmpty)

    }

    func testWordsBingoAndScorelessTurnEndRules() throws {

        var bingo = Words.State(racks: [[.a,.b,.c,.d,.e,.f,.g], [.q]], bag: [])

        let letters: [Words.Letter] = [.a,.b,.c,.d,.e,.f,.g]

        for (column, letter) in letters.enumerated() {

            try bingo.stage(letter, at: (7,column + 4))

        }

        XCTAssertEqual(try bingo.evaluate(accepts: { _ in true }).score, 54)
        var passed = Words.State(racks: [[.a], [.q]], bag: [])
        for _ in 0..<6 { try passed.pass() }
        XCTAssertTrue(passed.isComplete)
        XCTAssertEqual(passed.scores, [-1,-10])

    }

    func testWordsExchangeRequiresBagAndPreservesTileInventory() throws {

        var game = Words.State(racks: [[.q], [.a]], bag: 7 ✕ Words.Letter.e)
        try game.exchange(.q)
        XCTAssertEqual(game.player, 1)
        XCTAssertEqual(game.racks[0][0], .e)
        XCTAssertEqual(game.bag.count, 7)
        XCTAssertTrue(game.bag.contains(.q))
        var emptyBag = Words.State(racks: [[.q], [.a]], bag: [])
        XCTAssertThrowsError(try emptyBag.exchange(.q))
        XCTAssertEqual(emptyBag.racks[0][0], .q)

    }

    @MainActor func testWordsUsesIOSDictionaryForEnglishWords() {

        XCTAssertTrue(Words.isEnglishWord("CAT"))
        XCTAssertFalse(Words.isEnglishWord("QZXQZX"))
        XCTAssertFalse(Words.isEnglishWord("CAT!"))

    }

    func testCheckersDetectsPlayersWithNoPiecesOrLegalMoves() {

        var grid = Grid(8 ✕ (8 ✕ ""))
        XCTAssertFalse(Checkers.hasLegalMove(for: 0, in: grid))
        grid[7,0] = "●"
        XCTAssertFalse(Checkers.hasLegalMove(for: 0, in: grid))
        grid[7,0] = "◉"
        XCTAssertTrue(Checkers.hasLegalMove(for: 0, in: grid))

    }

    @MainActor func testCheckersFortyMoveDrawClaimWithoutRepetitionHistory() throws {

        var game = Gameboard(.checkers)
        game.grid = Grid(8 ✕ (8 ✕ ""))
        game.grid[0,1] = "◉"
        game.grid[7,6] = "◎"
        let cycle: [(Square, Square)] = [((0,1),(1,0)), ((7,6),(6,7)), ((1,0),(0,1)), ((6,7),(7,6))]

        for index in 0..<79 {

            let move = cycle[index % 4]
            _ = try game.move(pieceAt: move.0, toSquare: move.1)

        }

        XCTAssertEqual(game.checkersQuietMoves, 79)
        let session = GameSession(game: game)
        XCTAssertFalse(session.canClaimDraw)
        session.move(from: (6,7), to: (7,6))
        XCTAssertTrue(session.canClaimDraw)
        session.claimDraw()
        XCTAssertEqual(session.result, .draw)

    }

    @MainActor func testChessCanClaimDrawWithAnIntendedMove() {

        var game = Gameboard(.chess)
        game.grid = Grid(8 ✕ (8 ✕ ""))
        game.grid[0,4] = "♚"
        game.grid[0,0] = "♜"
        game.grid[7,4] = "♔"
        game.chessState.halfMoves = 99
        let session = GameSession(game: game)
        session.showAvailable(at: (0,0))
        XCTAssertFalse(session.canClaimDraw)
        XCTAssertTrue(session.claimableChessDestinations.contains { $0 == (1,0) })
        session.claimDraw(byMovingTo: (1,0))
        XCTAssertEqual(session.result, .draw)

    }

    func testChessPositionKeyUsesEffectiveRightsAndLegalEnPassantOnly() {

        let grid = Chess.board
        var first = Chess.State()
        first.castlingRights.remove(4)
        var second = first
        second.castlingRights.remove(0)
        XCTAssertEqual(Chess.positionKey(grid, player: 0, state: first), Chess.positionKey(grid, player: 0, state: second))
        second.enPassant = (2,3)
        XCTAssertEqual(Chess.positionKey(grid, player: 0, state: first), Chess.positionKey(grid, player: 0, state: second))

    }

    @MainActor func testResignationAndAgreedDrawKeepPersistentResults() {

        let resigned = GameSession(.chess)
        resigned.resign()
        XCTAssertEqual(resigned.result, .winner(player: 2))
        resigned.dismissEvent()
        resigned.move(from: (1,4), to: (3,4))
        XCTAssertEqual(resigned.grid[1,4], "♟")
        let drawn = GameSession(.go)
        drawn.agreeToDraw()
        drawn.dismissEvent()
        XCTAssertEqual(drawn.result, .draw)

    }

}

private extension Gameboard.BoardType {

    static var comingSoon: [Self] { allCases.filter { $0.readiness == .comingSoon } }

}
