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
            
//            extension Grid {
//
//                public func memory(_ rect: CGRect) -> UIView {
//
//                    let view = UIView(frame: rect)
//
//                    view.backgroundColor = colors.background
//
//                    view.layer.cornerRadius = 10
//                    view.layer.masksToBounds = true
//
//                    let w = (rect.width - content.count + 1) / content.count
//                    let h = (rect.height - content.count + 1) / content.count
//
//                    for (r,row) in content.enumerated() {
//
//                        for (c,item) in row.enumerated() {
//
//                            let label = UILabel(frame: CGRect(x: c * w + c, y: r * h + r, width: w, height: h))
//                            let piece = "\(item)"
//
//                            label.text = piece
//                            label.textAlignment = .center
//                            label.font = .systemFont(ofSize: (w + h) / 2 - 10, weight: .regular)
//                            label.textColor = player(piece) == 0 ? colors.player1 : piece.memoryColor
//
//                            view.addSubview(label)
//
//                        }
//
//                    }
//
//                    return view
//
//                }
//
//            }

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct MemoryUI_Previews: PreviewProvider {

    static var previews: some View {

        ZStack {

            Color("Background").edgesIgnoringSafeArea(.bottom)

            VStack {

                ZStack {

                    MemoryPiecesUI(grid: Grid([[]], playerPieces: ["◉","◎"]))

                }
                .padding(32)
                .preferredColorScheme(.dark)

                Text("Game Logic : Coming Soon").opacity(0.3)

            }


        }

    }

}
