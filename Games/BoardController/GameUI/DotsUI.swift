//
//  DotsUI.swift
//  Games
//
//  Created by Jo Albright on 4/15/21.
//  Copyright © 2021 Jo Albright. All rights reserved.
//

import SwiftUI

struct DotsBoardUI: View {

    var body: some View {

        let p: CGFloat = 10

        GeometryReader { g in
            
            let w = (g.rect.width - p * 2) / 8
            let h = (g.rect.height - p * 2) / 8

            ForEach(Index.count(9)) { row in

                let r = CGFloat(row.id)

                ForEach(Index.count(9)) { col in

                    Path { path in

                        let c = CGFloat(col.id)

                        path.move(to: CGPoint(x: w * c + p, y: h * r + p))
                        path.addLine(to: CGPoint(x: w * c + p, y: h * r + p))

                    }.stroke(Color("Text"), style: StrokeStyle(lineWidth: 6, lineCap: .round))

                }

            }

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)


    }

}

struct DotsLayoutUI: View {

    var grid: Grid

    var body: some View {

        ZStack {

            Color("Background").edgesIgnoringSafeArea(.bottom)

            VStack {

                DotsBoardUI().padding(32)

                Text("Game Logic : Coming Soon").opacity(0.3)

            }

        }
        .navigationTitle("Dots")

    }

}

struct DotsUI_Previews: PreviewProvider {

    static var previews: some View {

        NavigationView {

            DotsLayoutUI(grid: Grid([]))

        }
        .preferredColorScheme(.dark)

    }

}

//class DotsLineView: UIView {
//
//    public var playerColor: UIColor = .white
//    public var lineColor: UIColor = .black
//
//    override func draw(_ rect: CGRect) {
//
//        let context = UIGraphicsGetCurrentContext()
//
//        context?.setLineCap(.round)
//        context?.setLineJoin(.round)
//        context?.setLineWidth(1)
//
//        lineColor.set()
//
//        let h: Bool = rect.width > rect.height
//        let p: CGFloat = 2
//        let d: CGFloat = h ? rect.height - p * 2 : rect.width - p * 2
//
//        context?.strokeEllipse(in: CGRect(x: p, y: p, width: d, height: d))
//        context?.strokeEllipse(in: CGRect(x: rect.width - (d + p), y: rect.height - (d + p), width: d, height: d))
//
//        let x = h ? d + 7 : d / 2 + p
//        let y = h ? d / 2 + p : d + 7
//
//        context?.setLineWidth(2)
//        context?.setLineDash(phase: 0, lengths: [0,4])
//
//        context?.move(to: CGPoint(x: x, y: y))
//        context?.addLine(to: CGPoint(x: rect.width - x, y: rect.height - y))
//
//        context?.strokePath()
//
//    }
//
//}
//
//class DotsSquareView: UIView {
//
//    public var playerColor: UIColor = .white
//
//    override func draw(_ rect: CGRect) {
//
//        let context = UIGraphicsGetCurrentContext()
//
//        playerColor.set()
//
//        context?.fillEllipse(in: rect.insetBy(dx: 5, dy: 5))
//
//    }
//
//}
