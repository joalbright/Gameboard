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

                    }.stroke(Color.text, style: StrokeStyle(lineWidth: 6, lineCap: .round))

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

            Color.background.ignoresSafeArea(edges: .bottom)

            VStack {

                ZStack {

                    DotsPiecesUI(grid: grid)

                    DotsInteractionGrid(grid: grid, action: onSelect)

                }
                .aspectRatio(1.0, contentMode: .fit)
                .padding(32)

            }

        }
        .navigationTitle("Dots")

    }

}

private struct DotsInteractionGrid: View {

    var grid: Grid
    var action: (Square) -> Void

    var body: some View {

        GeometryReader { geometry in

            let width = geometry.size.width / 17
            let height = geometry.size.height / 17

            ForEach(0..<17, id: \.self) { row in

                ForEach(0..<17, id: \.self) { column in

                    if Dots.isSegment((row, column)) {

                        Button {

                            action((row, column))

                        } label: {

                            Rectangle()
                                .fill(.clear)
                                .contentShape(Rectangle())
                                .frame(width: width, height: height)

                        }
                        .buttonStyle(.plain)
                        .position(x: width * (CGFloat(column) + 0.5), y: height * (CGFloat(row) + 0.5))
                        .accessibilityLabel("\(row.isMultiple(of: 2) ? "Horizontal" : "Vertical") line, row \(row + 1), column \(column + 1)")
                        .accessibilityValue(grid[row, column] == "0" ? "Open" : "Claimed")

                    }

                }

            }

        }

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
                            let playerColor = cell.piece == "1" ? Dots.playerColors[0] : Dots.playerColors[1]

                            ZStack {

                                if row.id % 2 == 0, cell.index % 2 == 0 {

                                    Circle()
                                        .fill(Color.text)
                                        .frame(width: min(width, height) * 0.20)

                                } else if owned, row.id % 2 == 1, cell.index % 2 == 1 {

                                    RoundedRectangle(cornerRadius: min(width, height) * 0.10)
                                        .fill(playerColor)
                                        .frame(width: width * 1.5, height: height * 1.5)

                                } else if owned {

                                    Rectangle()
                                        .fill(Color.text)
                                        .frame(width: cell.index % 2 == 0 ? height * 0.2 : width * 2, height: row.id % 2 == 0 ? width * 0.2 : height * 2)

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

#Preview {

    NavigationStack {

        DotsLayoutUI(grid: Grid([

            "●1●2●2●0●0●1●0●2●".array(),
            "22121 0 1 0 0 2 0".array(),
            "●2●2●0●1●0●2●0●0●".array(),
            "22121 0 0 2 0 1 0".array(),
            "●2●2●0●2●0●0●1●0●".array(),
            "2 0 0 1 0 2 0 0 1".array(),
            "●0●2●0●0●1●0●2●0●".array(),
            "0 1 0 2 0 0 1 0 2".array(),
            "●0●0●1●0●2●0●0●1●".array(),
            "0 2 0 0 1 0 2 0 0".array(),
            "●1●0●2●0●0●0●0●0●".array(),
            "0 0 0 0 0 0 0 0 0".array(),
            "●0●0●0●0●0●0●0●0●".array(),
            "0 0 0 0 0 0 0 0 0".array(),
            "●0●0●0●0●0●0●0●0●".array(),
            "0 0 0 0 0 0 0 0 0".array(),
            "●0●0●0●0●0●0●0●0●".array()

        ], playerPieces: Dots.playerPieces))

    }

}
