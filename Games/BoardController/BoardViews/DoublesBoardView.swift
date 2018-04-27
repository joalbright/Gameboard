//
//  DoublesBoardView.swift
//  Games
//
//  Created by Jo Albright on 4/27/18.
//  Copyright © 2018 Jo Albright. All rights reserved.
//

import UIKit

class DoublesBoardView: BoardView {
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.doubles, testing: true)
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.doubles)
        super.awakeFromNib()
        
    }

}
