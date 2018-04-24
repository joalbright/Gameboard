//
//  WordsBoardView.swift
//  Games
//
//  Created by Jo Albright on 4/23/18.
//  Copyright © 2018 Jo Albright. All rights reserved.
//

import UIKit

@IBDesignable class WordsBoardView : BoardView {
    
    var bag: [String] = []
    var rack: [String] = [] { didSet { updateRack() } }
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.words)
        bag = Words.Letter.bag
        fillRack()
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.words)
        bag = Words.Letter.bag
        fillRack()
        super.awakeFromNib()
        
    }
    
    override func selectSquare(_ square: Square) {
        
        //        do {
        //
        //            try board.guess(toSquare: square, withGuess: sudokuNumber)
        //
        //        } catch {
        //
        //            print(error)
        //
        //        }
        
        updateBoard()
        
    }
    
    func fillRack() {
        
        let tiles = 7 - rack.count
        
        print(rack.count,tiles,bag.count)
        
        rack += bag.prefix(tiles)
        bag.removeFirst(tiles)
        
        print(rack.count,bag.count)
        
    }
    
    func updateRack() {
        
        
        
    }
    
}

class WordsBoardViewController: BoardViewController {
    
}
