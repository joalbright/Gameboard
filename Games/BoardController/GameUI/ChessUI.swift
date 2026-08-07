//
//  ChessUI.swift
//  Games
//
//  Created by Jo Albright on 4/16/21.
//  Copyright © 2021 Jo Albright. All rights reserved.
//

import SwiftUI

struct ChessPiecesUI: View {

    var grid: Grid

    var body: some View {

        GeometryReader { g in

            let w = g.size.width / 8
            let h = g.size.height / 8

            Color(red: 0.614, green: 0.520, blue: 0.367)

            VStack(spacing: 0) {

                ForEach(grid.cols) { col in

                    HStack(spacing: 0) {

                        ForEach(col.rows) { row in

                            let player = grid.player(row.piece) == 0
                            let di = (col.id + row.index) % 2 == 0

                            ZStack {

                                Text(grid.solid(row.piece))
                                    .foregroundColor(player ? .white : Color(white: 0.198))
                                    .frame(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h)
                                    .font(.system(size: (w + h) / 2 - 10))

                            }
                            .background(di ? Color(red: 0.614, green: 0.520, blue: 0.367) : Color(red: 0.530, green: 0.451, blue: 0.323))

                        }

                    }

                }

            }
        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct ChessCoordinatesUI<Content>: View where Content : View {

    let content: Content

    var body: some View {

        GeometryReader { g in

            let w = (g.size.width - 64) / 8
            let h = (g.size.height - 64) / 8

            ZStack {

                VStack(spacing: 0) {

                    Letters(w: w)

                    HStack(spacing: 0) {

                        Numbers(h: h)

                        ForEach(Index.count(8)) { letter in

                            Rectangle().fill(Color.clear).frame(width: w, height: g.size.height - 64)

                        }

                        Numbers(h: h)

                    }

                    Letters(w: w)

                }

            }

            content.padding(32)

        }
        .aspectRatio(1.0, contentMode: .fit)

    }

    init(@ViewBuilder content: () -> Content) {

        self.content = content()

    }

    struct Letters: View {

        var w: CGFloat
        let p: CGFloat = 32

        var body: some View {

            HStack(spacing: 0) {

                Rectangle().fill(Color.clear).frame(width: p, height: p)

                ForEach(Value<String>.array("ABCDEFGH".array())) { letter in

                    Text(letter.value)
                        .foregroundColor(Color("Accent"))
                        .frame(minWidth: w, maxWidth: w, minHeight: p, maxHeight: p)

                }

                Rectangle().fill(Color.clear).frame(width: p, height: p)

            }

        }

    }

    struct Numbers: View {

        var h: CGFloat
        let p: CGFloat = 32

        var body: some View {

            VStack(spacing: 0) {

                ForEach(Value<String>.array("12345678".array())) { letter in

                    Text(letter.value)
                        .foregroundColor(Color("Accent"))
                        .frame(minWidth: p, maxWidth: p, minHeight: h, maxHeight: h)

                }

            }

        }

    }

}

struct ChessLayoutUI: View {

    var grid: Grid
    var selected: Square? = nil
    var highlights: [Square] = []
    var onSelect: (Square) -> Void = { _ in }

    var body: some View {

        ZStack {

            Color("Background").ignoresSafeArea(edges: .bottom)

            VStack {

                ZStack {

                    ChessCoordinatesUI {

                        ChessPiecesUI(grid: grid)

                        BoardInteractionGrid(rows: 8, columns: 8, grid: grid, selected: selected, highlights: highlights, action: onSelect)

                    }

                }

            }

        }
        .navigationTitle("Chess")

    }

}

struct ChessUI_Previews: PreviewProvider {

    static var previews: some View {

        NavigationStack {

            ChessLayoutUI(grid: Grid([

                "♜♞♝♛♚♝♞♜".array(),
                8 ✕ "♟",
                8 ✕ "",
                8 ✕ "",
                8 ✕ "",
                8 ✕ "",
                8 ✕ "♙",
                "♖♘♗♕♔♗♘♖".array()

            ], playerPieces: ["♜♞♝♛♚♝♞♜♟","♖♘♗♕♔♗♘♖♙"]))

        }
        .preferredColorScheme(.dark)

    }

}
