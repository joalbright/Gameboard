import XCTest
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

        XCTAssertEqual(Gameboard.BoardType.backgammon.readiness, .comingSoon)
        XCTAssertEqual(Gameboard.BoardType.mancala.readiness, .comingSoon)
        XCTAssertEqual(Gameboard.BoardType.comingSoon, [.backgammon, .mancala])

    }

    func testReadyGameCanMakeAndResetMove() throws {

        var game = Gameboard(.tictactoe)

        try game.move(toSquare: (0, 0))

        XCTAssertEqual(game.grid[0, 0] as? String, TicTacToe.playerPieces[0])
        XCTAssertEqual(game.playerTurn, 1)

        game.reset()

        XCTAssertEqual(game.grid[0, 0] as? String, "")
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
        let initialRevision = session.revision

        session.move(to: (0, 0))

        XCTAssertEqual(session.grid[0, 0] as? String, TicTacToe.playerPieces[0])
        XCTAssertEqual(session.playerNumber, 2)
        XCTAssertNil(session.event)
        XCTAssertGreaterThan(session.revision, initialRevision)

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

    @MainActor func testFourSessionDropsPiecesByColumn() async {

        let session = GameSession(.four, fourDropInterval: .zero)

        await session.drop(inColumn: 2)
        await session.drop(inColumn: 2)

        XCTAssertEqual(session.grid[5, 2] as? String, Four.playerPieces[0])
        XCTAssertEqual(session.grid[4, 2] as? String, Four.playerPieces[1])
        XCTAssertFalse(session.isFourDropping)

    }

    @MainActor func testFourSessionPublishesTopRowBeforePieceSettles() async {

        let session = GameSession(.four, fourDropInterval: .seconds(10))
        let drop = Task { await session.drop(inColumn: 3) }

        await Task.yield()

        XCTAssertEqual(session.grid[0, 3] as? String, Four.playerPieces[0])
        XCTAssertEqual(session.playerNumber, 1)
        XCTAssertTrue(session.isFourDropping)

        await session.drop(inColumn: 4)
        XCTAssertEqual(session.grid[0, 4] as? String, " ")

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

        XCTAssertEqual(session.grid[7, 7] as? String, tile.rawValue.uppercased())
        XCTAssertNil(session.selectedWordTile)
        XCTAssertEqual(session.wordsRack.filter { $0 == .none }.count, 1)

    }

    @MainActor func testBombsweeperAndMemoryInteractionsMutateVisibleState() {

        let bombsweeper = GameSession(.bombsweeper, testing: true)
        let memory = GameSession(.memory, testing: true)

        bombsweeper.guess(at: (0, 0))
        memory.selectMemoryCard(at: (0, 0))

        XCTAssertNotEqual(bombsweeper.grid[0, 0] as? String, "•")
        XCTAssertNotEqual(memory.grid[0, 0] as? String, "🂠")
        XCTAssertEqual(memory.selected?.c, 0)
        XCTAssertEqual(memory.selected?.r, 0)

    }

    @MainActor func testSudokuSessionAcceptsSolutionAtEveryEmptyCoordinate() throws {

        let session = GameSession(.sudoku, testing: true)
        let solution = Sudoku.staticboard

        for row in session.grid.rowRange {

            for column in session.grid.colRange where session.grid[row, column] as? String == "" {

                let guess = try XCTUnwrap(solution[row, column] as? String)
                session.guess(at: (row, column), with: guess)

                XCTAssertNil(session.event, "Expected \(guess) at row \(row), column \(column) to be accepted.")
                XCTAssertEqual(session.grid[row, column] as? String, guess)

            }

        }

    }

}

private extension Gameboard.BoardType {

    static var comingSoon: [Self] { allCases.filter { $0.readiness == .comingSoon } }

}
