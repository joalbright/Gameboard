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

            Color("Accent")

            VStack(spacing: 0) {

                ForEach(grid.cols) { col in

                    HStack(spacing: 0) {

                        ForEach(col.rows) { row in

                            let player = grid.player(row.piece) == 0
                            let di = (col.id + row.id) % 2 == 0

                            ZStack {

                                Text(grid.solid(row.piece))
                                    .foregroundColor(player ? Color(#colorLiteral(red: 0.8636881113, green: 0.0521483086, blue: 0.02170978114, alpha: 1)) : Color(#colorLiteral(red: 0.5774884259, green: 0.1385148753, blue: 0.1458311012, alpha: 1)))
                                    .frame(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h)
                                    .font(Font(UIFont.systemFont(ofSize: (w + h) / 2 - 15, weight: .regular)))

                            }
                            .background(di ? Color("Accent") : Color("Text"))

                        }

                    }

                }

            }

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct CheckersUI_Previews: PreviewProvider {

    static var previews: some View {

        ZStack {

            Color("Background").edgesIgnoringSafeArea(.bottom)

            VStack {

                ZStack {

                    CheckersPiecesUI(grid: Grid([

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
                .padding(32)
                .preferredColorScheme(.dark)

            }

        }

    }

}

//extension Grid {
//
//    public func checker(_ rect: CGRect, highlights: [Square], selected: Square?) -> UIView {
//
//        let view = UIView(frame: rect)
//
//
//        return view
//
//    }
//
//}
