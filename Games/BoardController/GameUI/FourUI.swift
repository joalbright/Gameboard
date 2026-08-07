//
//  FourUI.swift
//  Games
//
//  Created by Jo Albright on 4/15/21.
//  Copyright © 2021 Jo Albright. All rights reserved.
//

import SwiftUI

struct FourBoardUI: View {

    var body: some View {

        let p: CGFloat = 15
        
        GeometryReader { g in

            let w = (g.size.width - p * 2) / 7
            let h = (g.size.height - p * 2) / 7

            Path { path in

                path.addRoundedRect(in: CGRect(x: 0, y: h, width: g.size.width, height: g.size.height - h), cornerSize: CGSize(width: 10, height: 10))

            }.fill(Color(red: 0.035, green: 0.631, blue: 0.828))

            ForEach(Index.count(7)) { col in

                let c = CGFloat(col.id)

                Path { path in

                    path.addRoundedRect(in: CGRect(x: w * c + p + 5, y: 10, width: w - 10, height: h), cornerSize: CGSize(width: 10, height: 10))

                }.fill(Color("Background"))

                ForEach(Index.count(6)) { row in

                    let r = CGFloat(row.id)

                    Path { path in

                        path.addEllipse(in: CGRect(x: w * c + p, y: h * r + p + h, width: w, height: h).insetBy(dx: 5, dy: 5))

                    }.fill(Color("Background"))

                }

                Path { path in

                    path.addEllipse(in: CGRect(x: w * c + p, y: 0, width: w, height: h).insetBy(dx: 10, dy: 10))

                }.fill(Color("Accent"))

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

                            let player = grid.player(row.piece) == 0

                            Text(grid.solid(row.piece)).foregroundColor(player ? Color(red: 0.892, green: 0, blue: 0.222) : Color(red: 0.947, green: 0.845, blue: 0.025))
                                .frame(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h)
                                .font(.system(size: (w + h) / 2 - 4, weight: .regular))

                        }

                    }.padding(0)

                }

            }.padding(EdgeInsets(top: h + p, leading: p, bottom: p, trailing: p))

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct FourLayoutUI: View {

    var grid: Grid
    var onSelectColumn: (Int) -> Void = { _ in }

    var body: some View {

        ZStack {

            Color("Background").ignoresSafeArea(edges: .bottom)

            VStack {

                ZStack {

                    FourBoardUI()

                    FourPiecesUI(grid: grid)

                    BoardInteractionGrid(rows: 1, columns: 7, selected: nil, highlights: []) { square in

                        onSelectColumn(square.r)

                    }

                }
                .padding(32)

            }

        }
        .navigationTitle("Four")

    }

}

struct FourUI_Previews: PreviewProvider {

    static var previews: some View {

        NavigationStack {

            FourLayoutUI(grid: Grid([

                7 ✕ " ",
                7 ✕ " ",
                "     ○ ".array(),
                "     ● ".array(),
                "    ○● ".array(),
                "   ○●● ".array()

            ], playerPieces: ["●","○"]))

        }
        .preferredColorScheme(.dark)

    }

}
