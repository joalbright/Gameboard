//
//  MancalaUI.swift
//  Games
//
//  Created by Jo Albright on 4/15/21.
//  Copyright © 2021 Jo Albright. All rights reserved.
//

import SwiftUI

struct MancalaBoardUI: View {

    var body: some View {

        GeometryReader { g in

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct MancalaPiecesUI: View {

    var grid: Grid

    var body: some View {

        GeometryReader { g in

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct MancalaLayoutUI: View {

    var grid: Grid

    var body: some View {

        ZStack {

            Color("Background").ignoresSafeArea(edges: .bottom)

            VStack {

                ZStack {

                    MancalaBoardUI()

                    MancalaPiecesUI(grid: grid)

                }
                .padding(32)

            }


        }
        .navigationTitle("Mancala")

    }

}

struct MancalaUI_Previews: PreviewProvider {

    static var previews: some View {

        NavigationStack {

            MancalaLayoutUI(grid: Grid([[]], playerPieces: ["◉","◎"]))

        }
        .preferredColorScheme(.dark)

    }

}
