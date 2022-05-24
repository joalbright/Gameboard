//
//  CheckersBoardView.swift
//  Games
//
//  Created by Jo Albright on 4/25/18.
//  Copyright © 2018 Jo Albright. All rights reserved.
//

import UIKit
import SwiftUI

@IBDesignable class CheckersBoardView : BoardView {
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.checkers)
        board.showAvailable((2,3))
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.checkers)
        super.awakeFromNib()
        
    }
    
    override func selectSquare(_ square: Square) {
        
        if let selected = board.selected {
            
            do {
                
                _ = try board.move(pieceAt: selected, toSquare: square)
                
                board.selected = nil
                board.highlights = []
                
            } catch {
                
                print(error)
                
                board.showAvailable(square)
                
            }
            
        } else {
            
            board.showAvailable(square)
            
        }
        
        updateBoard()
        
    }
    
}

struct CheckersPreview: PreviewProvider {

    static var previews: some View {

        VStack {

            Spacer()

            NewBoardView(boardType: .checkers) {

                $0.bgColor = .accent
                $0.fgColor = .offset
                $0.updateBoard()

            }
            .aspectRatio(1, contentMode: .fit)

            Spacer()

        }
        .padding(32)

    }

}
