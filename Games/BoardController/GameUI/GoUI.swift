//
//  GoUI.swift
//  Games
//
//  Created by Jo Albright on 4/15/21.
//  Copyright © 2021 Jo Albright. All rights reserved.
//

import SwiftUI

struct GoBoardUI: View {

    var body: some View {

        let p: CGFloat = 25

        GeometryReader { g in

            let w = (g.rect.width - p * 2) / 8
            let h = (g.rect.height - p * 2) / 8

            Color(red: 0.630, green: 0.550, blue: 0.384)

            ForEach(Index.count(9)) { row in

                let r = CGFloat(row.id)

                ForEach(Index.count(9)) { col in

                    let c = CGFloat(col.id)

                    Path { path in

                        path.move(to: CGPoint(x: w * c + p, y: p))
                        path.addLine(to: CGPoint(x: w * c + p, y: g.rect.height - p))
                        path.move(to: CGPoint(x: p, y: h * r + p))
                        path.addLine(to: CGPoint(x: g.rect.width - p, y: h * r + p))

                    }.stroke(Color(white: 0.151), lineWidth: 1)

                }

            }

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct GoPiecesUI: View {

    var grid: Grid

    var body: some View {

        let p: CGFloat = 25

        GeometryReader { g in

            let w = (g.rect.width - p * 2) / 8
            let h = (g.rect.height - p * 2) / 8

            ForEach(grid.cols) { row in

                ForEach(row.rows) { column in

                    let player = grid.player(column.piece)

                    if player >= 0 {

                        Text("●")
                            .foregroundColor(player == 0 ? .white : .black)
                            .font(.system(size: min(w, h), weight: .thin))
                            .position(x: p + w * CGFloat(column.index), y: p + h * CGFloat(row.id))

                    }

                }

            }

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

private struct GoInteractionGrid: View {

    var grid: Grid
    var action: (Square) -> Void

    var body: some View {

        let inset: CGFloat = 25

        GeometryReader { geometry in

            let width = (geometry.size.width - inset * 2) / 8
            let height = (geometry.size.height - inset * 2) / 8

            ForEach(0..<9, id: \.self) { row in

                ForEach(0..<9, id: \.self) { column in

                    Button {

                        action((row, column))

                    } label: {

                        Rectangle()
                            .fill(.clear)
                            .contentShape(Rectangle())
                            .frame(width: width, height: height)

                    }
                    .buttonStyle(.plain)
                    .position(x: inset + width * CGFloat(column), y: inset + height * CGFloat(row))
                    .accessibilityLabel("Row \(row + 1), column \(column + 1)")
                    .accessibilityValue(grid[row, column] as? String ?? "")

                }

            }

        }

    }

}

struct GoLayoutUI: View {

    var grid: Grid
    var selected: Square? = nil
    var highlights: [Square] = []
    var onSelect: (Square) -> Void = { _ in }

    var body: some View {

        ZStack {

            Color.background.ignoresSafeArea(edges: .bottom)

            VStack {

                ZStack {

                    GoBoardUI()

                    GoPiecesUI(grid: grid)

                    GoInteractionGrid(grid: grid, action: onSelect)

                }
                .aspectRatio(1.0, contentMode: .fit)
                .padding(32)

            }

        }
        .navigationTitle("Go")

    }

}

#Preview {

    NavigationStack {

        GoLayoutUI(grid: Grid([

            9 ✕ " ",
            9 ✕ " ",
            [" "," ","●","●"," "," "," "," "," "],
            [" "," ","○"," "," "," "," "," "," "],
            [" ","●","○","●"," "," "," "," "," "],
            [" "," "," ","●","○"," "," "," "," "],
            [" "," "," ","○"," "," "," "," "," "],
            9 ✕ "",
            9 ✕ ""

        ], playerPieces: ["●","○"]))

    }

}
