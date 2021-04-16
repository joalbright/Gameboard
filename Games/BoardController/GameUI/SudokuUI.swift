//
//  SudokuUI.swift
//  Games
//
//  Created by Jo Albright on 4/15/21.
//  Copyright © 2021 Jo Albright. All rights reserved.
//

import UIKit
import SwiftUI

struct SudokuBoardUI: View {

    var body: some View {

        GeometryReader { g in

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct SudokuPiecesUI: View {

    var grid: Grid

    var body: some View {

        GeometryReader { g in

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct SudokuUI_Previews: PreviewProvider {

    static var previews: some View {

        ZStack {

            Color("Background")

            VStack {

                ZStack {

                    SudokuBoardUI()

                    SudokuPiecesUI(grid: Grid([], playerPieces: ["◉","◎"]))

                }
                .padding(32)
                .preferredColorScheme(.dark)

                Text("Player 1")

            }


        }

    }

}

public class SudokuView: UIView {
    
    var lineColor: UIColor = .black
    
    public override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineCap(.round)
        context?.setLineJoin(.round)
        
        lineColor.set()
        
        let w9 = rect.width / 9
        let h9 = rect.height / 9
        
        for row in 1...8 {
            
            for col in 1...8 {
                
                context?.setLineWidth(col % 3 == 0 ? 3 : 1)

                context?.move(to: CGPoint(x: w9 * col, y: 0))
                context?.addLine(to: CGPoint(x: w9 * col, y: rect.height))
                context?.strokePath()
                
                context?.setLineWidth(row % 3 == 0 ? 3 : 1)

                context?.move(to: CGPoint(x: 0, y: h9 * row))
                context?.addLine(to: CGPoint(x: rect.width, y: h9 * row))
                context?.strokePath()
                
            }
            
        }
        
    }
    
}
