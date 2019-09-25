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

//    override func coordinate(_ touch: UITouch) -> Square {
//
//        let p = 10
//        let w = (frame.width - p * 2) / (board.gridSize - 1)
//        let h = (frame.height - p * 2) / (board.gridSize - 1)
//
//        let loc = touch.location(in: self)
//
//        let c = Int((loc.x - (w / 2)) / w)
//        let r = Int((loc.y - (w / 2)) / h)
//
//        return (r,c)
//
//    }

}
