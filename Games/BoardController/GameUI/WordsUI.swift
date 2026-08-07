//
//  WordsUI.swift
//  Games
//
//  Created by Jo Albright on 4/15/21.
//  Copyright © 2021 Jo Albright. All rights reserved.
//

import SwiftUI

struct WordsBoardUI: View {

    var body: some View {

        GeometryReader { g in

            RoundedRectangle(cornerRadius: 10)
                .fill(Color("Text").opacity(0.2))

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct WordsPiecesUI: View {

    var grid: Grid

    var body: some View {

        GeometryReader { g in

            let width = g.size.width / 15
            let height = g.size.height / 15

            VStack(spacing: 1) {

                ForEach(grid.cols) { row in

                    HStack(spacing: 1) {

                        ForEach(row.rows) { cell in

                            Text(cell.piece)
                                .font(.system(size: min(width, height) * 0.38, weight: .bold))
                                .foregroundStyle(.white)
                                .minimumScaleFactor(0.5)
                                .frame(width: width - 1, height: height - 1)
                                .background(cell.piece.wordSquareColor, in: RoundedRectangle(cornerRadius: 3))

                        }

                    }

                }

            }

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct WordsLayoutUI: View {

    var grid: Grid
    var rack: [Words.Letter] = []
    var selectedTile: Words.Letter? = nil
    var onSelectTile: (Words.Letter) -> Void = { _ in }
    var onSelectSquare: (Square) -> Void = { _ in }
    var onFillRack: () -> Void = { }

    var body: some View {

        ZStack {

            Color("Background").ignoresSafeArea(edges: .bottom)

            VStack {

                ZStack {

                    WordsBoardUI()

                    WordsPiecesUI(grid: grid)

                    BoardInteractionGrid(rows: 15, columns: 15, grid: grid, selected: nil, highlights: [], action: onSelectSquare)

                }
                .padding(32)

                HStack(spacing: 6) {

                    ForEach(Value<Words.Letter>.array(rack)) { item in

                        Button {

                            onSelectTile(item.value)

                        } label: {

                            VStack(spacing: 0) {

                                Text(item.value == .blank ? "_" : item.value.rawValue.uppercased())
                                    .font(.headline)

                                Text("\(item.value.point)")
                                    .font(.caption2)

                            }
                            .frame(maxWidth: .infinity, minHeight: 48)
                            .background(selectedTile == item.value ? Color.accentColor : Color("Text").opacity(0.2), in: RoundedRectangle(cornerRadius: 8))

                        }
                        .buttonStyle(.plain)
                        .disabled(item.value == .none)

                    }

                }
                .padding(.horizontal, 32)

                Button("Fill Rack", systemImage: "rectangle.stack.badge.plus", action: onFillRack)

            }

        }
        .navigationTitle("Words")

    }

}

private extension String {

    var wordSquareColor: Color {

        switch Words.PieceType(rawValue: self) {
        case .start: return Color(red: 0.46, green: 0.18, blue: 0.49)
        case .doubleletter: return Color(red: 0.01, green: 0.52, blue: 0.89)
        case .tripleletter: return Color(red: 0.20, green: 0.72, blue: 0.38)
        case .doubleword: return Color(red: 0.80, green: 0, blue: 0.27)
        case .tripleword: return Color(red: 0.97, green: 0.60, blue: 0.27)
        case .empty, .none: return Color("Text").opacity(0.16)
        }

    }

}

struct WordsUI_Previews: PreviewProvider {

    static var previews: some View {

        NavigationStack {

            WordsLayoutUI(grid: Grid(Words.board.content, playerPieces: ["◉","◎"]))

        }
        .preferredColorScheme(.dark)

    }

}

