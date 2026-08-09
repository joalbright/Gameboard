import SwiftUI

struct GameSceneUI<Content: View>: View {

    @Bindable var session: GameSession
    var readiness: Gameboard.BoardType.Readiness
    @ViewBuilder var content: Content

    var body: some View {

        content
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

                }

            }
            .alert(item: eventBinding) { event in

                Alert(title: Text(event.title), message: Text(event.message), dismissButton: .default(Text("OK")))

            }

    }

    private var eventBinding: Binding<GameSessionEvent?> {

        Binding(get: { session.event }, set: { event in

            if event == nil { session.dismissEvent() }

        })

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
