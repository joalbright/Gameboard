//
//  TicTacToeBoardView.swift
//  Games
//
//  Created by Jo Albright on 4/25/18.
//  Copyright © 2018 Jo Albright. All rights reserved.
//

import UIKit

@IBDesignable class TicTacToeBoardView : BoardView {
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.tictactoe)
        _ = try? board.move(toSquare: (1,1))
        _ = try? board.move(toSquare: (0,1))
        _ = try? board.move(toSquare: (1,0))
        _ = try? board.move(toSquare: (1,2))
        _ = try? board.move(toSquare: (2,0))
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.tictactoe)
        super.awakeFromNib()
        
    }
    
    override func selectSquare(_ square: Square) {
        
        do {
            
            try board.move(toSquare: square)
            
        } catch {
            
            print(error)
            
        }
        
        updateBoard()
        checkDone()
        
    }

    lazy var combinations: [[Int]] = {

        var combinations: [[Int]] = []

        // Side to Side (+1)

        for i in [1,4,7] {

            combinations += [i.set(1, 3)]

        }

        // Up & Down (+3)

        for i in [1,2,3] {

            combinations += [i.set(3, 3)]

        }

        // Diagonals

        combinations += [

            1.set(4, 3),
            3.set(2, 3)

        ]

        return combinations

    }()

    override func checkDone() {

        for set in combinations {

            let (winner,gameover) = checkWin(indexes: set)

            guard gameover else { continue }

            if let w = winner {

                board?.showAlert?("Game Over", "Player \(w) Wins")

            } else {

                board?.showAlert?("Game Over", "Stalemate")

            }

            return

        }

    }

    private func checkWin(indexes: [Int]) -> (Int?,Bool) {

        let piece1: Any = board.grid[indexes[0] - 1]
        let piece2: Any = board.grid[indexes[1] - 1]
        let piece3: Any = board.grid[indexes[2] - 1]

        if let p1 = piece1 as? String, let p2 = piece2 as? String, let p3 = piece3 as? String {

            if p1 == p2, p2 == p3, p1 != "" {

                guard let index = board?.playerPieces.firstIndex(of: p1) else { return (nil,false) }

                return (index + 1,true)

            }

        }

        return (nil,false)

    }
    
}
