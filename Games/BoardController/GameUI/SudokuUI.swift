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

            Color("Text")

            ForEach(Index.count(8)) { row in

                let r = CGFloat(row.id + 1)
                let r3 = row.id % 3 == 0

                ForEach(Index.count(8)) { col in

                    let c = CGFloat(col.id + 1)
                    let c3 = col.id % 3 == 0

                    Path { path in

                        path.move(to: CGPoint(x: w * c, y: 0))
                        path.addLine(to: CGPoint(x: w * c, y: g.rect.height))

                    }.stroke(Color("Background"), lineWidth: c3 ? 3 : 1)

                    Path { path in


                        path.move(to: CGPoint(x: 0, y: h * r))
                        path.addLine(to: CGPoint(x: g.rect.width, y: h * r))

                    }.stroke(Color("Background"), lineWidth: r3 ? 3 : 1)

                }

            }

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct SudokuPiecesUI: View {

    var grid: Grid

    var body: some View {

        GeometryReader { g in

            let w = g.rect.width / 9
            let h = g.rect.height / 9


            VStack(spacing: 0) {

                ForEach(grid.cols) { col in

                    HStack(spacing: 0) {

                        ForEach(col.rows) { row in

                            Text(row.piece).foregroundColor(Color("Background"))
                                .frame(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h)
                                .font(Font(UIFont.systemFont(ofSize: (w + h) / 2 - 15, weight: .regular)))

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

    @State private var number = 0

    var grid: Grid

    var body: some View {

        ZStack {

            Color("Background").edgesIgnoringSafeArea(.bottom)

            VStack {

                ZStack {

                    SudokuBoardUI()

                    SudokuPiecesUI(grid: grid)

                }
                .padding(32)

                Picker("", selection: $number) {

                    ForEach(Index.count(9)) { index in

                        Text("\(index.id + 1)")

                    }

                }
                .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
                .pickerStyle(SegmentedPickerStyle())

            }

        }
        .navigationTitle("Sudoku")

    }

}

struct SudokuUI_Previews: PreviewProvider {

    static var previews: some View {

        NavigationView {

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
                .preferredColorScheme(.light)

        }

    }

}
