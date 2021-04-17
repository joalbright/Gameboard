//
//  BackgammonUI.swift
//  Games
//
//  Created by Jo Albright on 4/15/21.
//  Copyright © 2021 Jo Albright. All rights reserved.
//

import SwiftUI

struct BackgammonBoardUI: View {

    var body: some View {

        let p: CGFloat = 15
        
        GeometryReader { g in

            let vG: CGFloat = 20
            let hG: CGFloat = 50
            
            Color(#colorLiteral(red: 0.4039215686, green: 0.3331669212, blue: 0.1912525604, alpha: 1))

            Path { path in

                path.addPath(Path(UIBezierPath(roundedRect: g.rect.insetBy(dx: p, dy: p), cornerRadius: 0).cgPath))

            }.fill(Color(#colorLiteral(red: 0.7155671296, green: 0.6420300176, blue: 0.5232170534, alpha: 1)))

            Path { path in

                path.addRect(CGRect(x: g.rect.midX - vG / 2, y: 0, width: vG, height: g.rect.height))

            }.fill(Color(#colorLiteral(red: 0.4039215686, green: 0.3331669212, blue: 0.1912525604, alpha: 1)))

            let w = (g.rect.width - p * 2 - vG) / 12
            let h = (g.rect.height - p * 2 - hG) / 10

            ForEach(Index.count(12)) { index in

                let i = CGFloat(index.id)
                let x: CGFloat = index.id > 5 ? 35 : 15
                let eo = index.id % 2 == 0

                Path { path in

                    path.move(to: CGPoint(x: w * i + x, y: 15))
                    path.addLine(to: CGPoint(x: w * i + x + w, y: 15))
                    path.addLine(to: CGPoint(x: w * i + x + w / 2, y: h * 5 + 15))
                    path.closeSubpath()

                }.fill(Color((eo ? #colorLiteral(red: 0.7155671296, green: 0.6420300176, blue: 0.5232170534, alpha: 1) : #colorLiteral(red: 0.4039215686, green: 0.3331669212, blue: 0.1912525604, alpha: 1)))).blendMode(.multiply).opacity(0.5)

                Path { path in

                    path.move(to: CGPoint(x: w * i + x, y: g.rect.height - 15))
                    path.addLine(to: CGPoint(x: w * i + x + w, y: g.rect.height - 15))
                    path.addLine(to: CGPoint(x: w * i + x + w / 2, y: h * 5 + 65))
                    path.closeSubpath()

                }.fill(Color((eo ? #colorLiteral(red: 0.4039215686, green: 0.3331669212, blue: 0.1912525604, alpha: 1) : #colorLiteral(red: 0.7155671296, green: 0.6420300176, blue: 0.5232170534, alpha: 1)))).blendMode(.multiply).opacity(0.5)

            }

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct BackgammonPiecesUI: View {

    var grid: Grid

    var body: some View {

        GeometryReader { g in

            let w = (g.rect.width - 50) / 12
            let h = (g.rect.height - 134) / 10

            VStack(spacing: 0) {

                ForEach(grid.cols) { col in

                    if col.id == 5 { Text("").frame(minWidth: g.rect.width - 50, maxWidth: g.rect.width - 50, minHeight: 100, maxHeight: 100) }

                    HStack(spacing: 0) {

                        ForEach(col.rows) { row in

                            if row.id == 6 { Text("").frame(minWidth: 20, maxWidth: 20, minHeight: h, maxHeight: h) }

                            let player = grid.player(row.piece) == 0

                            Text(grid.solid(row.piece)).foregroundColor(player ? Color(#colorLiteral(red: 0.1978587963, green: 0.1978587963, blue: 0.1978587963, alpha: 1)) : Color(#colorLiteral(red: 1, green: 0.9999699852, blue: 0.9999699852, alpha: 1)))
                                .frame(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h)
                                .font(Font(UIFont.systemFont(ofSize: (w + h) / 2, weight: .regular)))

                        }

                    }.padding(0)

                }

            }.padding(EdgeInsets(top: 17, leading: 15, bottom: 17, trailing: 15))

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct BackgammonUI_Previews: PreviewProvider {

    static var previews: some View {

        ZStack {

            Color("Background").edgesIgnoringSafeArea(.bottom)

            VStack {

                ZStack {

                    BackgammonBoardUI()

                    BackgammonPiecesUI(grid: Grid([

                        "●   ○ ○    ●".array(),
                        "●   ○ ○    ●".array(),
                        "●   ○ ○     ".array(),
                        "●     ○     ".array(),
                        "●     ○     ".array(),
                        "○     ●     ".array(),
                        "○     ●     ".array(),
                        "○   ● ●     ".array(),
                        "○   ● ●    ○".array(),
                        "○   ● ●    ○".array()

                    ], playerPieces: ["●","○"]))

                }
                .padding(32)
                .preferredColorScheme(.dark)

                Text("Game Logic : Coming Soon").opacity(0.3)

            }

        }

    }

}
