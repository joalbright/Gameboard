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

            Color(#colorLiteral(red: 0.6139756944, green: 0.5195682041, blue: 0.3670352386, alpha: 1))

            VStack(spacing: 0) {

                ForEach(grid.cols) { col in

                    HStack(spacing: 0) {

                        ForEach(col.rows) { row in

                            let player = grid.player(row.piece) == 0
                            let di = (col.id + row.id) % 2 == 0

                            ZStack {

                                Text(grid.solid(row.piece))
                                    .foregroundColor(player ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)) : Color(#colorLiteral(red: 0.1978587963, green: 0.1978587963, blue: 0.1978587963, alpha: 1)))
                                    .frame(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h)
                                    .font(Font(UIFont(name: "Apple Symbols", size: (w + h) / 2 - 10)!))

                            }
                            .background(di ? Color(#colorLiteral(red: 0.6139756944, green: 0.5195682041, blue: 0.3670352386, alpha: 1)) : Color(#colorLiteral(red: 0.5299479167, green: 0.4510110251, blue: 0.3234737067, alpha: 1)))

                        }

                    }

                }

            }

            //                label.highlightColor = colors.highlight
            //
            //                if let selected = selected, selected.0 == r && selected.1 == c { label.textColor = colors.selected }
            //                for highlight in highlights { label.highlight = label.highlight ? true : highlight.0 == r && highlight.1 == c }

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

    var body: some View {

        ZStack {

            Color("Background").edgesIgnoringSafeArea(.bottom)

            VStack {

                ZStack {

                    ChessCoordinatesUI {

                        ChessPiecesUI(grid: grid)

                    }

                }

            }

        }
        .navigationTitle("Chess")

    }

}

struct ChessUI_Previews: PreviewProvider {

    static var previews: some View {

        NavigationView {

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
