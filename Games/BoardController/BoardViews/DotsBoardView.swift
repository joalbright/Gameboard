//
//  DotsBoardView.swift
//  Games
//
//  Created by Jo Albright on 4/25/18.
//  Copyright © 2018 Jo Albright. All rights reserved.
//

import UIKit

@IBDesignable class DotsBoardView : BoardView {
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.dots, testing: true)
        _ = try? board.move(toSquare: (3,6))
        _ = try? board.move(toSquare: (2,5))
        _ = try? board.move(toSquare: (2,7))
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.dots, testing: true)
        super.awakeFromNib()
        
    }
    
    override func selectSquare(_ square: Square) {
        
        do {

            try board.move(toSquare: square)

        } catch {

            print(error)

        }
        
        updateBoard()
        
    }

}
