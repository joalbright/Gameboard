//
//  DotsUI.swift
//  Games
//
//  Created by Jo Albright on 4/15/21.
//  Copyright © 2021 Jo Albright. All rights reserved.
//

import SwiftUI

struct DotsBoardUI: View {

    var body: some View {

        let p: CGFloat = 10

        GeometryReader { g in
            
            let w = (g.rect.width - p * 2) / 8
            let h = (g.rect.height - p * 2) / 8

            ForEach(Index.count(9)) { row in

                let r = CGFloat(row.id)

                ForEach(Index.count(9)) { col in

                    Path { path in

                        let c = CGFloat(col.id)

                        path.move(to: CGPoint(x: w * c + p, y: h * r + p))
                        path.addLine(to: CGPoint(x: w * c + p, y: h * r + p))

                    }.stroke(Color("Text"), style: StrokeStyle(lineWidth: 6, lineCap: .round))

                }

            }

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)


    }

}

struct DotsLayoutUI: View {

    var grid: Grid
    var onSelect: (Square) -> Void = { _ in }

    var body: some View {

        ZStack {

            Color("Background").ignoresSafeArea(edges: .bottom)

            VStack {

                ZStack {

                    DotsPiecesUI(grid: grid)

                    BoardInteractionGrid(rows: 17, columns: 17, grid: grid, selected: nil, highlights: [], action: onSelect)

                }
                .padding(32)

            }

        }
        .navigationTitle("Dots")

    }

}

private struct DotsPiecesUI: View {

    var grid: Grid

    var body: some View {

        GeometryReader { geometry in

            let width = geometry.size.width / 17
            let height = geometry.size.height / 17

            VStack(spacing: 0) {

                ForEach(grid.cols) { row in

                    HStack(spacing: 0) {

                        ForEach(row.rows) { cell in

                            let owned = ["1", "2"].contains(cell.piece)
                            let playerColor = cell.piece == "1" ? Color.cyan : Color.pink

                            ZStack {

                                if row.id % 2 == 0, cell.index % 2 == 0 {

                                    Circle()
                                        .fill(Color("Text"))
                                        .frame(width: min(width, height) * 0.55)

                                } else if owned, row.id % 2 == 1, cell.index % 2 == 1 {

                                    Rectangle()
                                        .fill(playerColor.opacity(0.25))

                                } else if owned {

                                    Rectangle()
                                        .fill(playerColor)
                                        .frame(width: cell.index % 2 == 0 ? 3 : width, height: row.id % 2 == 0 ? 3 : height)

                                }

                            }
                            .frame(width: width, height: height)

                        }

                    }

                }

            }

        }
        .aspectRatio(1, contentMode: .fit)

    }

}

struct DotsUI_Previews: PreviewProvider {

    static var previews: some View {

        NavigationStack {

            DotsLayoutUI(grid: Grid([]))

        }
        .preferredColorScheme(.dark)

    }

}

