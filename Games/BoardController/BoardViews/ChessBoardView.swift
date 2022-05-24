//
//  ChessBoardView.swift
//  Games
//
//  Created by Jo Albright on 4/25/18.
//  Copyright © 2018 Jo Albright. All rights reserved.
//

import UIKit
import SwiftUI

@IBDesignable class ChessBoardView : BoardView {
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.chess)
        board.showAvailable(C7)
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.chess)
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

struct ChessPreview: PreviewProvider {

    static var previews: some View {

        VStack {

            Spacer()

            NewBoardView(boardType: .chess) {

                $0.bgColor = .accent
                $0.fgColor = .offset
                $0.player1Color = .black
                $0.player2Color = .white
                $0.updateBoard()

            }
            .aspectRatio(1, contentMode: .fit)

            Spacer()

        }
        .padding(32)

    }

}
