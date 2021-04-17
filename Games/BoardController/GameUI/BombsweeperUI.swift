//
//  BombsweeperUI.swift
//  Games
//
//  Created by Jo Albright on 4/16/21.
//  Copyright © 2021 Jo Albright. All rights reserved.
//

import SwiftUI

struct BombsweeperPiecesUI: View {

    var grid: Grid

    var body: some View {

        GeometryReader { g in

            let c = CGFloat(grid.cols.count)
            let w = (g.size.width - c + 1) / c
            let h = (g.size.height - c + 1) / c

            VStack(spacing: 1) {

                ForEach(grid.cols) { col in

                    HStack(spacing: 1) {

                        ForEach(col.rows) { row in

                            let player = grid.player(row.piece)

                            ZStack {

                                let color = row.piece == "•" ? Color("Accent") : player == 1 ? Color.white : player == 0 ? Color(#colorLiteral(red: 0.9960965514, green: 0.7409956477, blue: 0, alpha: 1)) : Color("Text")

                                Text(row.piece)
                                    .foregroundColor(color)
                                    .frame(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h)
                                    .font(Font(UIFont.systemFont(ofSize: (w + h) / 2 - 10, weight: .regular)))

                            }
                            .background(row.piece == "•" ? Color("Accent") : player == 1 ? Color(#colorLiteral(red: 0.7460197806, green: 0.1847642958, blue: 0.1849055439, alpha: 1)) : Color("Background"))

                        }

                    }

                }

            }

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct BombsweeperLayoutUI: View {

    @State private var piece = 0

    var grid: Grid

    var body: some View {

        ZStack {

            Color("Background").edgesIgnoringSafeArea(.bottom)

            VStack {

                ZStack {

                    BombsweeperPiecesUI(grid: grid)

                }
                .padding(32)

                Picker("", selection: $piece) {

                    ForEach(Value<String>.array("●⚑".array())) { item in

                        Text(item.value).tag(item.id)

                    }

                }
                .frame(width: 140, height: 40, alignment: .center)
                .pickerStyle(SegmentedPickerStyle())

            }

        }
        .navigationTitle("Bombsweeper")

    }

}

struct BombsweeperUI_Previews: PreviewProvider {

    static var previews: some View {

        NavigationView {

            BombsweeperLayoutUI(grid: Grid([

                "•••••••1  ".array(),
                "••••••⚑1  ".array(),
                "••••••2   ".array(),
                "•••••••111".array(),
                "••✘•••••••".array(),
                "••••••••••".array(),
                "••••••••••".array(),
                "13⚑•••••••".array(),
                "  2⚑••••••".array(),
                "  2⚑••••••".array()

            ], playerPieces: ["⚑","✘"]))
                .preferredColorScheme(.dark)

        }

    }

}
