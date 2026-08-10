//
//  TicTacToeUI.swift
//  Games
//
//  Created by Jo Albright on 4/15/21.
//  Copyright © 2021 Jo Albright. All rights reserved.
//

import SwiftUI

struct TicTacToeBoardUI: View {

    var body: some View {

        let p: CGFloat = 10

        GeometryReader { g in

            let w = (g.rect.width - p * 2) / 3
            let h = (g.rect.height - p * 2) / 3

            ForEach(Index.range(0...1)) { index in

                let i = CGFloat(index.id + 1)

                Path { path in

                    path.move(to: CGPoint(x: w * i + p, y: p))
                    path.addLine(to: CGPoint(x: w * i + p, y: g.rect.height - p))

                    path.move(to: CGPoint(x: p, y: h * i + p))
                    path.addLine(to: CGPoint(x: g.rect.width - p, y: h * i + p))

                }.stroke(Color.accent, style: StrokeStyle(lineWidth: 2, lineCap: .round))

            }

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct TicTacToePiecesUI: View {

    var grid: Grid = Grid(3 ✕ (3 ✕ ""))

    var body: some View {

        let p: CGFloat = 10

        GeometryReader { g in

            let w = (g.rect.width - p * 2) / 3
            let h = (g.rect.height - p * 2) / 3

            VStack(spacing: 0) {

                ForEach(grid.cols) { col in

                    HStack(spacing: 0) {

                        ForEach(col.rows) { row in

                            let player = grid.player(row.piece) == 0

                            Text(row.piece).foregroundColor(player ? TicTacToe.playerColors[0] : TicTacToe.playerColors[1])
                                .frame(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h)
                                .font(.system(size: (w + h) / 2 - p, weight: .thin))

                        }

                    }.padding(0)

                }

            }.padding(p)

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct TicTacToeLayoutUI: View {

    var grid: Grid
    var selected: Square? = nil
    var highlights: [Square] = []
    var onSelect: (Square) -> Void = { _ in }

    var body: some View {

        ZStack {

            Color.background.ignoresSafeArea(edges: .bottom)

            VStack {

                ZStack {

                    TicTacToeBoardUI()

                    TicTacToePiecesUI(grid: grid)

                    BoardInteractionGrid(rows: 3, columns: 3, grid: grid, selected: selected, highlights: highlights, action: onSelect)

                }
                .padding(32)

            }

        }
        .navigationTitle("TicTacToe")

    }

}

#Preview {

    NavigationStack {

        TicTacToeLayoutUI(grid: Grid([

            [" ", " ", " "],
            ["✕", "○", "○"],
            [" ", " ", "✕"]

        ], playerPieces: ["○","✕"]))

    }

}
