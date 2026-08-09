//
//  MemoryUI.swift
//  Games
//
//  Created by Jo Albright on 4/16/21.
//  Copyright © 2021 Jo Albright. All rights reserved.
//

import SwiftUI

private let memoryCardVerticalOffset: CGFloat = -3

struct MemoryPiecesUI: View {

    var grid: Grid

    var body: some View {

        GeometryReader { g in

            let c = CGFloat(grid.cols.count)
            let w = g.size.width / c
            let h = g.size.height / c

            VStack(spacing: 0) {

                ForEach(grid.cols) { col in

                    HStack(spacing: 0) {

                        ForEach(col.rows) { row in

                            let player = grid.player(row.piece)

                            ZStack {

                                Text(row.piece)
                                    .foregroundColor(player == 0 ? Color(red: 0, green: 0.478, blue: 1) : row.piece.memoryColor)
                                    .frame(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h)
                                    .font(.custom("AppleSymbols", size: (w + h) / 2))
                                    .offset(y: memoryCardVerticalOffset)

                            }
                            .cornerRadius(4)

                        }

                    }

                }

            }

        }
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct MemoryLayoutUI: View {

    var grid: Grid
    var selected: Square? = nil
    var highlights: [Square] = []
    var onSelect: (Square) -> Void = { _ in }

    var body: some View {

        ZStack {

            Color.background.ignoresSafeArea(edges: .bottom)

            VStack {

                ZStack {

                    MemoryPiecesUI(grid: grid)

                    BoardInteractionGrid(rows: grid.content.count, columns: grid.content.first?.count ?? 0, grid: grid, selected: selected, highlights: highlights, action: onSelect)
                        .offset(y: memoryCardVerticalOffset)

                }
                .aspectRatio(1.0, contentMode: .fit)
                .padding(32)

            }


        }
        .navigationTitle("Memory")

    }

}

#Preview {

    NavigationStack {

        MemoryLayoutUI(grid: Grid([

            6 ✕ "🂠",
            6 ✕ "🂠",
            6 ✕ "🂠",
            "🂠🂠🃑🂠🂠🂠".array(),
            "🂠🂠🂠🂠🂠🃅".array(),
            6 ✕ "🂠",

        ], playerPieces: ["🂠"]))

    }

}

extension String {

    var memoryColor: Color {

        switch self {

        case "🂡","🂢","🂣","🂤","🂥","🂦","🂧","🂨","🂩","🂪","🂫","🂬","🂭","🂮","🃑","🃒","🃓","🃔","🃕","🃖","🃗","🃘","🃙","🃚","🃛","🃜","🃝","🃞": return Color.text
        case "🂱","🂲","🂳","🂴","🂵","🂶","🂷","🂸","🂹","🂺","🂻","🂼","🂽","🂾","🃁","🃂","🃃","🃄","🃅","🃆","🃇","🃈","🃉","🃊","🃋","🃌","🃍","🃎": return Color.red
        case "🃟": return Color.orange
        default: return Color.clear

        }

    }

}
