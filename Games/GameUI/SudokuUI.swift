//
//  SudokuUI.swift
//  Games
//
//  Created by Jo Albright on 4/15/21.
//  Copyright © 2021 Jo Albright. All rights reserved.
//

import SwiftUI

struct SudokuBoardUI: View {

    var body: some View {

        GeometryReader { g in

            let w = g.rect.width / 9
            let h = g.rect.height / 9

            Color.text

            ForEach(1..<9, id: \.self) { index in

                let offset = CGFloat(index)
                let major = index % 3 == 0

                Path { path in

                    path.move(to: CGPoint(x: w * offset, y: 0))
                    path.addLine(to: CGPoint(x: w * offset, y: g.rect.height))

                }.stroke(Color.background, lineWidth: major ? 3 : 1)

                Path { path in

                    path.move(to: CGPoint(x: 0, y: h * offset))
                    path.addLine(to: CGPoint(x: g.rect.width, y: h * offset))

                }.stroke(Color.background, lineWidth: major ? 3 : 1)

            }

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct SudokuPiecesUI: View {

    var grid: Grid
    var highlights: [Square] = []

    var body: some View {

        GeometryReader { g in

            let w = g.rect.width / 9
            let h = g.rect.height / 9
            
            VStack(spacing: 0) {

                ForEach(grid.cols) { col in

                    HStack(spacing: 0) {

                        ForEach(col.rows) { row in
                            
                            let square = (col.id, row.index)
                            let isHighlighted = highlights.contains(where: { $0 == square })
                            
                            Text(row.piece).foregroundColor(isHighlighted ? Color.blue : Color.background)
                                .frame(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h)
                                .font(.system(size: (w + h) / 2 - 15, weight: .regular))

                        }

                    }.padding(0)

                }

            }.padding(0)

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct SudokuLayoutUI: View {

    var grid: Grid
    var highlights: [Square] = []
    var difficulty: Difficulty = .easy
    var selectedNumber = 1
    var onDifficultySelect: (Difficulty) -> Void = { _ in }
    var onNumberSelect: (Int) -> Void = { _ in }
    var onSelect: (Square, String) -> Void = { _,_ in }

    var body: some View {

        ZStack {

            Color.background.ignoresSafeArea(edges: .bottom)

            VStack {

                DifficultyMenu(difficulty: difficulty, onSelect: onDifficultySelect)

                Spacer()
                
                ZStack {

                    SudokuBoardUI()

                    SudokuPiecesUI(grid: grid, highlights: highlights)

                    BoardInteractionGrid(rows: 9, columns: 9, grid: grid, selected: nil, highlights: []) { square in

                        onSelect(square, "\(selectedNumber)")

                    }

                }
                .aspectRatio(1.0, contentMode: .fit)
                .padding(.vertical, 32)

                Spacer()
                
                Picker("", selection: Binding(get: { selectedNumber }, set: onNumberSelect)) {

                    ForEach(1...9, id: \.self) { number in

                        Text("\(number)").tag(number)

                    }

                }
                .frame(maxWidth: 400)
                .pickerStyle(.segmented)
                .accessibilityLabel("Number")

            }
            .padding(32)

        }
        .navigationTitle("Sudoku")

    }

}

#Preview {

    NavigationStack {

        SudokuLayoutUI(grid: Grid([

            "   4    9".array(),
            "4     1  ".array(),
            " 8       ".array(),
            "     7   ".array(),
            "5       4".array(),
            "    3    ".array(),
            "         ".array(),
            "6        ".array(),
            "       7 ".array()

        ], playerPieces: ["123456789"]))

    }

}
