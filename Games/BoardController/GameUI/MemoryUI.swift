//
//  MemoryUI.swift
//  Games
//
//  Created by Jo Albright on 4/16/21.
//  Copyright © 2021 Jo Albright. All rights reserved.
//

import SwiftUI

struct MemoryPiecesUI: View {

    var grid: Grid

    var body: some View {

        GeometryReader { g in

            let c = CGFloat(grid.cols.count)
            let w = g.size.width / c
            let h = g.size.height / c

            VStack(spacing: 16 / c) {

                ForEach(grid.cols) { col in

                    HStack(spacing: 0) {

                        ForEach(col.rows) { row in

                            let player = grid.player(row.piece)

                            ZStack {

                                Text(row.piece)
                                    .foregroundColor(player == 0 ? Color(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)) : row.piece.memoryColor)
                                    .frame(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h)
                                    .font(Font(UIFont.systemFont(ofSize: (w + h) / 2, weight: .heavy)))

                            }
                            .cornerRadius(4)

                        }

                    }

                }

            }

        }
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct MemoryLayoutUI: View {

    var grid: Grid

    var body: some View {

        ZStack {

            Color("Background").edgesIgnoringSafeArea(.bottom)

            VStack {

                ZStack {

                    MemoryPiecesUI(grid: grid)

                }
                .padding(32)

            }


        }
        .navigationTitle("Memory")

    }

}

struct MemoryUI_Previews: PreviewProvider {

    static var previews: some View {

        NavigationView {

            MemoryLayoutUI(grid: Grid([

                6 ✕ "🂠",
                6 ✕ "🂠",
                6 ✕ "🂠",
                "🂠🂠🃑🂠🂠🂠".array(),
                "🂠🂠🂠🂠🂠🃅".array(),
                6 ✕ "🂠",

            ], playerPieces: ["🂠"]))

        }
        .preferredColorScheme(.dark)

    }

}

extension String {

    var memoryColor: Color {

        switch self {

        case "🂡","🂢","🂣","🂤","🂥","🂦","🂧","🂨","🂩","🂪","🂫","🂬","🂭","🂮","🃑","🃒","🃓","🃔","🃕","🃖","🃗","🃘","🃙","🃚","🃛","🃜","🃝","🃞": return Color("Text")
        case "🂱","🂲","🂳","🂴","🂵","🂶","🂷","🂸","🂹","🂺","🂻","🂼","🂽","🂾","🃁","🃂","🃃","🃄","🃅","🃆","🃇","🃈","🃉","🃊","🃋","🃌","🃍","🃎": return Color.red
        case "🃟": return Color.orange
        default: return Color.clear

        }

    }

}
