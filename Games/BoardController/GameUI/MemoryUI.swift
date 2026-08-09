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

            VStack(spacing: 0) {

                ForEach(grid.cols) { col in

                    HStack(spacing: 0) {

                        ForEach(col.rows) { row in

                            let player = grid.player(row.piece)

                            ZStack {

                                Text(row.piece)
                                    .foregroundColor(player == 0 ? Color(red: 0, green: 0.478, blue: 1) : row.piece.memoryColor)
                                    .frame(minWidth: w, maxWidth: w, minHeight: w, maxHeight: w)
                                    .font(.custom("AppleSymbols", size: w))
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
    var difficulty: Difficulty = .easy
    var onDifficultySelect: (Difficulty) -> Void = { _ in }
    var onSelect: (Square) -> Void = { _ in }

    var body: some View {

        ZStack {

            Color.background.ignoresSafeArea(edges: .bottom)

            VStack {

                DifficultyMenu(difficulty: difficulty, onSelect: onDifficultySelect)

                Spacer()

                ZStack {

                    MemoryPiecesUI(grid: grid)

                    BoardInteractionGrid(rows: grid.content.count, columns: grid.content.first?.count ?? 0, grid: grid, selected: nil, highlights: [], action: onSelect)
                        .offset(y: memoryCardVerticalOffset)

                }
                .aspectRatio(1.0, contentMode: .fit)
                
                HStack {
                    
                    Spacer()
                        
                    if grid.cols.count > 4 {
                        
                        let squares = if let selected { [selected] } else { highlights }
                        
                        ForEach(0..<squares.count, id:\.self) { i in
                            
                            let square = squares[i]
                            let piece = grid.cols[square.c].rows[square.r].piece
                            
                            Text(piece)
                                .foregroundColor(piece.memoryColor)
                                .font(.custom("AppleSymbols", size: 90))
                            
                        }
                        
                    }
                        
                    Spacer()
                    
                }
                .frame(height: 100)

                Spacer()

            }
            .padding(32)


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

        ], playerPieces: ["🂠"]), highlights: [(3,2),(4,5)])

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
