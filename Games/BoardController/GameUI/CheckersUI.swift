//
//  CheckersUI.swift
//  Games
//
//  Created by Jo Albright on 4/16/21.
//  Copyright © 2021 Jo Albright. All rights reserved.
//

import SwiftUI

struct CheckersPiecesUI: View {

    var grid: Grid

    var body: some View {

        GeometryReader { g in

            let w = g.size.width / 8
            let h = g.size.height / 8

            Color.accent

            VStack(spacing: 0) {

                ForEach(grid.cols) { col in

                    HStack(spacing: 0) {

                        ForEach(col.rows) { row in

                            let player = grid.player(row.piece) == 0
                            let di = (col.id + row.index) % 2 == 0

                            ZStack {

                                Text(grid.solid(row.piece))
                                    .foregroundColor(player ? Color(red: 0.864, green: 0.052, blue: 0.022) : Color(red: 0.577, green: 0.139, blue: 0.146))
                                    .frame(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h)
                                    .font(.system(size: (w + h) / 2 - 15, weight: .regular))

                            }
                            .background(di ? Color.accent : Color.text)

                        }

                    }

                }

            }

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct CheckersLayoutUI: View {

    var grid: Grid
    var selected: Square? = nil
    var highlights: [Square] = []
    var onSelect: (Square) -> Void = { _ in }

    var body: some View {

        ZStack {

            Color.background.ignoresSafeArea(edges: .bottom)

            VStack {

                ZStack {

                    CheckersPiecesUI(grid: grid)

                    BoardInteractionGrid(rows: 8, columns: 8, grid: grid, selected: selected, highlights: highlights, action: onSelect)

                }
                .aspectRatio(1.0, contentMode: .fit)
                .padding(32)

            }

        }
        .navigationTitle("Checkers")

    }

}

#Preview {

    NavigationStack {

        CheckersLayoutUI(grid: Grid([

            8 ✕ ("" %% "●"),
            8 ✕ ("●" %% ""),
            8 ✕ ("" %% "●"),
            8 ✕ "",
            8 ✕ "",
            8 ✕ ("○" %% ""),
            8 ✕ ("" %% "○"),
            8 ✕ ("○" %% "")

        ], playerPieces: ["●◉","○◎"]))

    }

}
