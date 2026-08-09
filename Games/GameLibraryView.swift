import Observation
import SwiftUI

@MainActor @Observable final class GameboardSceneState {

    private(set) var phase: ScenePhase = .active

    func handle(_ phase: ScenePhase) {

        self.phase = phase

    }

}

struct GameLibraryView: View {

    @Environment(\.scenePhase) private var scenePhase
    @SceneStorage("GameLibraryView.selectedGame") private var selectedGameRawValue: String?
    @State private var sceneState = GameboardSceneState()

    var body: some View {

        NavigationSplitView {

            List(Gameboard.BoardType.catalog, selection: selectedGameBinding) { game in

                NavigationLink(value: game) {

                    GameLibraryRow(game: game)

                }

            }
            .navigationTitle("Gameboard")

        } detail: {

            if let game = selectedGame {

                GameDestinationView(game: game)
                    .id(game)

            } else {

                ContentUnavailableView("Choose a Game", systemImage: "square.grid.3x3", description: Text("Select a game from the library to view its board."))

            }

        }
        .navigationSplitViewStyle(.balanced)
        .onChange(of: scenePhase, initial: true) { _, phase in

            sceneState.handle(phase)

        }

    }

    private var selectedGame: Gameboard.BoardType? {

        guard let selectedGameRawValue else { return nil }
        return Gameboard.BoardType(rawValue: selectedGameRawValue)

    }

    private var selectedGameBinding: Binding<Gameboard.BoardType?> {

        Binding(get: { selectedGame }, set: { selectedGame in

            selectedGameRawValue = selectedGame?.rawValue

        })

    }

}

private struct GameLibraryRow: View {

    var game: Gameboard.BoardType

    var body: some View {

        HStack(spacing: 12) {

            Text(game.emblem)
                .font(.title2)
                .frame(width: 32)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {

                Text(game.name)

                if game.readiness == .comingSoon {

                    Text("Coming Soon")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                }

            }

        }
        .accessibilityElement(children: .combine)

    }

}

private struct GameDestinationView: View {

    var game: Gameboard.BoardType
    @State private var session: GameSession

    init(game: Gameboard.BoardType) {

        self.game = game
        _session = State(initialValue: GameSession(game))

    }

    var body: some View {

        GameSceneUI(session: session, readiness: game.readiness) {

            destination
                .id(session.revision)

        }
            .allowsHitTesting(game.readiness == .ready)
            .overlay(alignment: .top) {

                if game.readiness == .comingSoon {

                    Label("Coming Soon", systemImage: "hammer.fill")
                        .font(.headline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(.regularMaterial, in: Capsule())
                        .padding()
                        .accessibilityLabel("\(game.name), coming soon preview")

                }

            }

    }

    @ViewBuilder private var destination: some View {

        switch game {
        case .backgammon: BackgammonLayoutUI(grid: session.grid)
        case .bombsweeper: BombsweeperLayoutUI(grid: session.grid) { square, guess in

            if guess {

                session.guess(at: square)

            } else {

                session.mark(at: square)

            }

        }
        case .checkers: CheckersLayoutUI(grid: session.grid, selected: session.selected, highlights: session.highlights, onSelect: session.selectOrMove)
        case .chess: ChessLayoutUI(grid: session.grid, selected: session.selected, highlights: session.highlights, onSelect: session.selectOrMove)
        case .dots: DotsLayoutUI(grid: session.grid, onSelect: session.move)
        case .doubles: DoublesLayoutUI(grid: session.grid) { direction in

            Task { await session.swipe(direction) }

        }
        case .four: FourLayoutUI(grid: session.grid) { column in

            Task { await session.drop(inColumn: column) }

        }
        case .go: GoLayoutUI(grid: session.grid, onSelect: session.move)
        case .mancala: MancalaLayoutUI(grid: session.grid) { square in

            Task { await session.sowMancala(from: square) }

        }
        case .memory: MemoryLayoutUI(grid: session.grid, selected: session.selected, highlights: session.highlights, onSelect: session.selectMemoryCard)
        case .pegs: PegsLayoutUI(grid: session.grid, selected: session.selected, highlights: session.highlights, onSelect: session.selectOrMove)
        case .sudoku: SudokuLayoutUI(grid: session.grid, highlights: session.highlights, onSelect: session.guess)
        case .tictactoe: TicTacToeLayoutUI(grid: session.grid, selected: session.selected, highlights: session.highlights, onSelect: session.move)
        case .words: WordsLayoutUI(grid: session.grid, rack: session.wordsRack, selectedTile: session.selectedWordTile, onSelectTile: session.chooseWordTile, onSelectSquare: session.placeSelectedWordTile, onFillRack: session.fillWordsRack)
        }

    }

}

#Preview("Game Library") {

    GameLibraryView()

}

#Preview("Ready Game") {

    NavigationStack {

        GameDestinationView(game: .words)

    }

}

#Preview("Coming Soon Board") {

    NavigationStack {

        GameDestinationView(game: .backgammon)

    }

}

#Preview("Accessibility Text") {

    GameLibraryView()
        .environment(\.dynamicTypeSize, .accessibility3)

}
