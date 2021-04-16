//
//  GoUI.swift
//  Games
//
//  Created by Jo Albright on 4/15/21.
//  Copyright © 2021 Jo Albright. All rights reserved.
//

import UIKit
import SwiftUI

struct GoBoardUI: View {

    var body: some View {

        let p: CGFloat = 25

        GeometryReader { g in

            let w = (g.rect.width - p * 2) / 8
            let h = (g.rect.height - p * 2) / 8

            Color(#colorLiteral(red: 0.6296006944, green: 0.5495509649, blue: 0.3840564236, alpha: 1))

            ForEach(Index.count(9)) { row in

                let r = CGFloat(row.id)

                ForEach(Index.count(9)) { col in

                    let c = CGFloat(col.id)

                    Path { path in

                        path.move(to: CGPoint(x: w * c + p, y: p))
                        path.addLine(to: CGPoint(x: w * c + p, y: g.rect.height - p))
                        path.move(to: CGPoint(x: p, y: h * r + p))
                        path.addLine(to: CGPoint(x: g.rect.width - p, y: h * r + p))

                    }.stroke(Color(#colorLiteral(red: 0.1505630314, green: 0.1505537778, blue: 0.1505591571, alpha: 1)), lineWidth: 1)

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

            VStack(spacing: 0) {

                ForEach(grid.cols) { col in

                    HStack(spacing: 0) {

                        ForEach(col.rows) { row in

                            let player = grid.player(row.piece)

                            Text(player == -1 ? "" : "●").foregroundColor(player == 0 ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)) : Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                                .frame(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h)
                                .font(Font(UIFont.systemFont(ofSize: (w + h) / 2, weight: .thin)))

                        }

                    }.padding(0)

                }

            }.padding(5)

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct GoUI_Previews: PreviewProvider {

    static var previews: some View {

        ZStack {

            Color("Background")

            VStack {

                ZStack {

                    GoBoardUI()

                    GoPiecesUI(grid: Grid([

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
                .padding(32)
                .preferredColorScheme(.dark)

                Text("Game Logic : Coming Soon").opacity(0.3)

            }

        }

    }

}
