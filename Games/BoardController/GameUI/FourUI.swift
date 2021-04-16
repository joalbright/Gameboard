//
//  FourUI.swift
//  Games
//
//  Created by Jo Albright on 4/15/21.
//  Copyright © 2021 Jo Albright. All rights reserved.
//

import UIKit
import SwiftUI

struct FourBoardUI: View {

    var body: some View {

        let p: CGFloat = 15
        
        GeometryReader { g in

            let w = (g.rect.width - p * 2) / 7
            let h = (g.rect.height - p * 2) / 7

            Color(#colorLiteral(red: 0.03473516487, green: 0.6306997018, blue: 0.827976048, alpha: 1))

            Path { path in

                path.addRect(CGRect(x: 0, y: 0, width: g.rect.width, height: h + 10))

            }.fill(Color("Background"))

            Path { path in

                path.addPath(Path(UIBezierPath(roundedRect: CGRect(x: 0, y: h, width: g.rect.width, height: 20), cornerRadius: 10).cgPath))

            }.fill(Color(#colorLiteral(red: 0.03473516487, green: 0.6306997018, blue: 0.827976048, alpha: 1)))

            ForEach(Index.count(7)) { col in

                let c = CGFloat(col.id)

                Path { path in

                    path.addPath(Path(UIBezierPath(roundedRect: CGRect(x: w * c + p + 5, y: 10, width: w - 10, height: h), cornerRadius: 10).cgPath))

                }.fill(Color("Background"))

                ForEach(Index.count(6)) { row in

                    let r = CGFloat(row.id)

                    Path { path in

                        path.addEllipse(in: CGRect(x: w * c + p, y: h * r + p + h, width: w, height: h).insetBy(dx: 5, dy: 5))

                    }.fill(Color("Background"))

                }

                Path { path in

                    path.addEllipse(in: CGRect(x: w * c + p, y: 0, width: w, height: h).insetBy(dx: 15, dy: 15))

                }.fill(Color("Accent"))

                Path { path in

                    path.addEllipse(in: CGRect(x: w * c + p, y: 0, width: w, height: h).insetBy(dx: 10, dy: 10))

                }.stroke(Color("Accent"), lineWidth: 2)

            }
            
        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct FourPiecesUI: View {

    var grid: Grid

    var body: some View {

        let p: CGFloat = 15

        GeometryReader { g in

            let w = (g.rect.width - p * 2) / 7
            let h = (g.rect.height - p * 2) / 7

            VStack(spacing: 0) {

                ForEach(grid.cols) { col in

                    HStack(spacing: 0) {

                        ForEach(col.rows) { row in

                            let player = grid.player(row.piece)

                            Text(player == -1 ? "" : "●").foregroundColor(player == 0 ? Color(#colorLiteral(red: 0.8924742354, green: 0, blue: 0.2215340148, alpha: 1)) : Color(#colorLiteral(red: 0.9469539561, green: 0.8450366779, blue: 0.02451992306, alpha: 1)))
                                .frame(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h)
                                .font(Font(UIFont.systemFont(ofSize: (w + h) / 2 - p, weight: .regular)))

                        }

                    }.padding(0)

                }

            }.padding(EdgeInsets(top: h + p, leading: p, bottom: p, trailing: p))

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct FourUI_Previews: PreviewProvider {

    static var previews: some View {

        ZStack {

            Color("Background")

            VStack {

                ZStack {

                    FourBoardUI()

                    FourPiecesUI(grid: Grid([

                        7 ✕ " ",
                        7 ✕ " ",
                        "     ◎ ".array(),
                        "     ◉ ".array(),
                        "    ◎◉ ".array(),
                        "   ◎◉◉ ".array()

                    ], playerPieces: ["◉","◎"]))

                }
                .padding(32)
                .preferredColorScheme(.dark)

                Text("Player 1")

            }


        }

    }

}
