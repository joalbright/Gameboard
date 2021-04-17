//
//  PegsUI.swift
//  Games
//
//  Created by Jo Albright on 4/15/21.
//  Copyright © 2021 Jo Albright. All rights reserved.
//

import SwiftUI

struct PegsBoardUI: View {

    var body: some View {

        GeometryReader { g in

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct PegsPiecesUI: View {

    var grid: Grid

    var body: some View {

        GeometryReader { g in

//            extension Grid {
//
//                public func pegs(_ rect: CGRect, highlights: [Square], selected: Square?) -> UIView {
//
//                    let view = PegsView(frame: rect)
//
//                    view.backgroundColor = colors.background
//                    view.p = padding
//                    view.color = colors.foreground
//                    view.lineColor = colors.player2
//
//                    let w = (rect.width - padding * 2) / content.count
//                    let h = (rect.height - padding * 2) / content.count
//
//                    for (r,row) in content.enumerated() {
//
//                        for (c,item) in row.enumerated() {
//
//                            guard "\(item)" != "!" else { continue }
//
//                            let label = HintLabel(frame: CGRect(x: c * w + padding, y: r * h + padding, width: w, height: h))
//
//                            label.text = "\(item)"
//                            label.textAlignment = .center
//                            label.font = .systemFont(ofSize: (w + h) / 2 - 15, weight: .regular)
//                            label.textColor = colors.player1
//                            label.highlightColor = colors.highlight
//
//                            if let selected = selected, selected.0 == r && selected.1 == c { label.textColor = colors.selected }
//
//                            for highlight in highlights { label.highlight = label.highlight ? true : highlight.0 == r && highlight.1 == c }
//
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

struct PegsUI_Previews: PreviewProvider {

    static var previews: some View {

        ZStack {

            Color("Background").edgesIgnoringSafeArea(.bottom)

            VStack {

                ZStack {

                    PegsBoardUI()

                    PegsPiecesUI(grid: Grid([], playerPieces: ["◉","◎"]))

                }
                .padding(32)
                .preferredColorScheme(.dark)

            }

        }

    }

}

//class PegsView: UIView {
//    
//    var p: CGFloat = 20
//    var color: UIColor = .lightGray
//    var lineColor: UIColor = .black
//    
//    public override func draw(_ rect: CGRect) {
//        
//        let context = UIGraphicsGetCurrentContext()
//        
//        context?.setLineCap(.round)
//        context?.setLineJoin(.round)
//        context?.setLineWidth(p)
//
//        backgroundColor?.set()
//
//        context?.fill(rect)
//        
//        let w = (rect.width - p * 2) / 7
//        let h = (rect.height - p * 2) / 7
//        
//        color.set()
//        
//        context?.move(to: CGPoint(x: rect.width / 2, y: p / 2))
//        context?.addLine(to: CGPoint(x: rect.width - p / 2, y: rect.height / 2))
//        context?.addLine(to: CGPoint(x: rect.width / 2, y: rect.height - p / 2))
//        context?.addLine(to: CGPoint(x: p / 2, y: rect.height / 2))
//        
//        context?.fillPath()
//        
//        context?.move(to: CGPoint(x: rect.width / 2, y: p / 2))
//        context?.addLine(to: CGPoint(x: rect.width - p / 2, y: rect.height / 2))
//        context?.addLine(to: CGPoint(x: rect.width / 2, y: rect.height - p / 2))
//        context?.addLine(to: CGPoint(x: p / 2, y: rect.height / 2))
//        context?.closePath()
//        
//        context?.strokePath()
//
//        lineColor.set()
//        
//        context?.setLineWidth(6)
//        
//        let skip: [(Int,Int)] = [(0,0),(0,1),(1,0),(1,1),(5,0),(5,1),(6,0),(6,1),(0,5),(1,5),(0,6),(1,6),(5,5),(5,6),(6,5),(6,6)]
//        
//        for r in 0..<7 {
//            
//            for c in 0..<7 {
//                
//                guard !(skip.contains { $0.0 == c && $0.1 == r }) else { continue }
//                
//                context?.move(to: CGPoint(x: w * c + w / 2 + p, y: h * r + h / 2 + p))
//                context?.addLine(to: CGPoint(x: w * c + w / 2 + p, y: h * r + h / 2 + p))
//                context?.strokePath()
//                
//            }
//            
//        }
//        
//    }
//
//}
