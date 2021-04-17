//
//  DoublesUI.swift
//  Games
//
//  Created by Jo Albright on 4/16/21.
//  Copyright © 2021 Jo Albright. All rights reserved.
//

import SwiftUI

struct DoublesPiecesUI: View {

    var grid: Grid

    var body: some View {

        GeometryReader { g in

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct DoublesUI_Previews: PreviewProvider {

    static var previews: some View {

        ZStack {

            Color("Background").edgesIgnoringSafeArea(.bottom)

            VStack {

                ZStack {

                    DoublesPiecesUI(grid: Grid([[]], playerPieces: ["◉","◎"]))

                }
                .padding(32)
                .preferredColorScheme(.dark)

            }

        }

    }

}


//extension Grid {
//
//    public func doubles(_ rect: CGRect) -> UIView {
//
//        let view = UIView(frame: rect)
//
//        view.backgroundColor = colors.background
//        view.layer.cornerRadius = 10
//        view.layer.masksToBounds = true
//
//        let w = (rect.width - padding * 2) / 4
//        let h = (rect.height - padding * 2) / 4
//
//        for (r,row) in content.enumerated() {
//
//            for (c,item) in row.enumerated() {
//
//                let label = UILabel(frame: CGRect(x: c * w + padding, y: r * h + padding, width: w, height: h).insetBy(dx: 2, dy: 2))
//                let piece = "\(item)"
//
//                label.backgroundColor = piece == " " ? colors.foreground : piece.doublesColor
//                label.text = piece
//                label.textAlignment = .center
//                label.font = .systemFont(ofSize: (w + h) / 4 - 5, weight: .heavy)
//                label.textColor = colors.player1
//                label.adjustsFontSizeToFitWidth = true
//                label.layer.cornerRadius = 10
//                label.layer.masksToBounds = true
//
//                view.addSubview(label)
//
//            }
//
//        }
//
//        return view
//
//    }
//
//}
