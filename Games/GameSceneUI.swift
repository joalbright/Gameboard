import SwiftUI

struct GameSceneUI<Content: View>: View {

    @Bindable var session: GameSession
    var readiness: Gameboard.BoardType.Readiness
    @ViewBuilder var content: Content
    @State private var showingResignConfirmation = false
    @State private var showingDrawConfirmation = false

    var body: some View {

        content
            .safeAreaInset(edge: .top) {

                GameRuleControls(session: session)

            }
            .safeAreaInset(edge: .bottom) {

                if let result = session.result {

                    Text(result.message)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.regularMaterial)
                        .accessibilityLabel("Game result: \(result.message)")

                }

            }
            .safeAreaInset(edge: .bottom) {

                if readiness == .ready && session.isMultiplayer {

                    HStack {
                        
                        Spacer()
                        
                        ForEach(0..<session.playerCount, id: \.self) { player in
                        
                            let isCurrentPlayer = session.playerNumber == player + 1
                            let diameter: CGFloat = isCurrentPlayer ? 50 : 40
                            
                            Text("\(player + 1)")
                                .foregroundStyle(isCurrentPlayer ? session.playerSecondaryColor : .text)
                                .background(Circle().fill(isCurrentPlayer ? session.playerColor : .gray).frame(width: diameter, height: diameter))
                                .frame(width: 40, height: 40)
                            
                        }

                        Spacer()

                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)

                }

            }
            .toolbar {

                if readiness == .ready {

                    ToolbarItem(placement: .primaryAction) {

                        Button("Reset", systemImage: "arrow.counterclockwise") {

                            session.reset()

                        }

                    }

                    if session.isMultiplayer && !session.isFinished {

                        ToolbarItem(placement: .secondaryAction) {

                            Menu("Game", systemImage: "ellipsis.circle") {

                                Button("Resign", role: .destructive) { showingResignConfirmation = true }
                                Button("Agree to a draw") { showingDrawConfirmation = true }

                            }

                        }

                    }

                }

            }
            .alert(item: eventBinding) { event in

                Alert(title: Text(event.title), message: Text(session.result?.message ?? event.message), dismissButton: .default(Text("OK")))

            }
            .confirmationDialog("Resign and award the game to the other player?", isPresented: $showingResignConfirmation, titleVisibility: .visible) {

                Button("Resign", role: .destructive, action: session.resign)

            }
            .confirmationDialog("Both players agree to end this game in a draw?", isPresented: $showingDrawConfirmation, titleVisibility: .visible) {

                Button("Agree to draw", action: session.agreeToDraw)

            }

    }

    private var eventBinding: Binding<GameSessionEvent?> {

        Binding(get: { session.event }, set: { event in

            if event == nil { session.dismissEvent() }

        })

    }

}

private struct GameRuleControls: View {

    @Bindable var session: GameSession

    var body: some View {

        VStack(spacing: 8) {

            switch session.boardType {

            case .chess:

                HStack {

                    Menu("Promote to: \(session.chessPromotion.rawValue.capitalized)") {

                        ForEach(Chess.Promotion.allCases) { promotion in

                            Button(promotion.rawValue.capitalized) { session.selectChessPromotion(promotion) }

                        }

                    }
                    .disabled(session.isFinished)

                    if session.isChessInCheck && !session.isFinished { Text("Check").foregroundStyle(.red) }
                    if session.canClaimDraw { Button("Claim draw", action: session.claimDraw) }

                    let destinations = session.claimableChessDestinations

                    if !destinations.isEmpty {

                        Menu("Claim draw with move") {

                            ForEach(Array(destinations.enumerated()), id: \.offset) { _, square in

                                Button("\(String("abcdefgh".array()[square.1]))\(8 - square.0)") { session.claimDraw(byMovingTo: square) }

                            }

                        }

                    }

                }

            case .checkers:

                if session.canClaimDraw { Button("Claim draw", action: session.claimDraw) }

            case .dots:

                Text("Player 1: \(session.dotsScores[0]) · Player 2: \(session.dotsScores[1])")

            case .doubles:

                Text("Score: \(session.doublesScore) · Target: 2048")

            case .backgammon:

                Text("Opening roll: one die per player; higher die starts.")
                    .font(.caption)

            case .go:

                goControls

            default: EmptyView()

            }

        }
        .font(.subheadline)
        .padding(.horizontal)

    }

    private var goControls: some View {

        VStack(spacing: 8) {

            Menu("Komi: \(session.goKomi, specifier: "%.1f")") {

                ForEach([0.5, 5.5, 6.5, 7.5], id: \.self) { komi in

                    Button("\(komi, specifier: "%.1f")") { session.selectGoKomi(komi) }

                }

            }
            .disabled(!session.canSetGoKomi)

            if session.isFinished {

                Text("Black: \(session.goScores[0], specifier: "%.1f") · White: \(session.goScores[1], specifier: "%.1f")")

            }

            if session.isReviewingGoScore {

                Text("Tap dead groups to mark or unmark them. Both players must accept the score.")
                    .font(.caption)
                Text("Black: \(session.goScores[0], specifier: "%.1f") · White: \(session.goScores[1], specifier: "%.1f")")

                HStack {

                    Button("Accept score (Player \(session.playerNumber))", action: session.acceptGoScore)
                    Button("Resume play", action: session.resumeGoPlay)

                }

            } else {

                Button("Pass", action: session.passGoTurn)
                    .disabled(session.isFinished)

            }

        }

    }

}

struct BoardInteractionGrid: View {

    var rows: Int
    var columns: Int
    var grid: Grid? = nil
    var selected: Square?
    var highlights: [Square]
    var action: (Square) -> Void

    var body: some View {

        VStack(spacing: 0) {

            ForEach(0..<rows, id: \.self) { row in

                HStack(spacing: 0) {

                    ForEach(0..<columns, id: \.self) { column in

                        let square = (row, column)
                        let isSelected = selected?.c == square.0 && selected?.r == square.1
                        let isHighlighted = highlights.contains(where: { $0 == square })

                        Button {

                            action(square)

                        } label: {

                            Rectangle()
                                .fill(.clear)
                                .contentShape(Rectangle())
                                .overlay {

                                    if isSelected {

                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(.tint, lineWidth: 4)
                                            .padding(2)

                                    } else if isHighlighted {

                                        Circle()
                                            .fill(.tint.opacity(0.35))
                                            .padding(8)

                                    }

                                }

                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Row \(row + 1), column \(column + 1)")
                        .accessibilityValue(grid?.accessibilityDescription(at: square) ?? "")
                        .accessibilityHint(isHighlighted ? "Legal destination" : "")
                        .accessibilityAddTraits(isSelected ? .isSelected : [])

                    }

                }

            }

        }

    }

}

private extension Grid {

    func accessibilityDescription(at square: Square) -> String {

        guard onBoard(square) else { return "" }

        let piece = self[square.c, square.r]

        switch piece {
        case "", " ": return "Empty"
        case "•": return "Covered"
        case "🂠": return "Hidden card"
        default: return piece
        }

    }

}

private extension GameSessionEvent {

    var title: String {

        switch self {
        case .gameOver, .winner, .stalemate: return "Game Over"
        case .invalidMove: return "Move Not Available"
        case .unavailable: return "Coming Soon"
        case .failure: return "Unable to Move"
        }

    }

    var message: String {

        switch self {
        case .gameOver: return "The game has ended."
        case .winner: return "Player wins."
        case .stalemate: return "The game ended in a stalemate."
        case .invalidMove: return "That move is not valid."
        case .unavailable: return "This interaction is not available yet."
        case .failure(let description): return description
        }

    }

}
