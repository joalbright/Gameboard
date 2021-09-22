//
//  FourBoardView.swift
//  Games
//
//  Created by Jo Albright on 4/25/18.
//  Copyright © 2018 Jo Albright. All rights reserved.
//

import UIKit

@IBDesignable class FourBoardView : BoardView {
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.four, testing: true)
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.four)
        super.awakeFromNib()
        
    }
    
    override func selectSquare(_ square: Square) {
        
        do {
            
            try board.drop(pieceAt: square)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
                self.selectSquare((square.0 + 1,square.1))
            
            }

        } catch MoveError.invalidmove {

            checkDone()

        } catch MoveError.outofbounds {

            checkDone()

        } catch {
            
            print(error)
            
        }
        
        updateBoard()
        
    }
    
    override func coordinate(_ touch: UITouch) -> Square {
        
        let w = (frame.width - board.padding * 2) / 7
        let loc = touch.location(in: self)
        let c = Int((loc.x - board.padding) / w)
        
        return (-1,c)
        
    }

    lazy var combinations: [[Int]] = {

        var combinations: [[Int]] = []

        // Side to Side (+1)

        for i in [1,2,3,4,8,9,10,11,15,16,17,18,22,23,24,25,29,30,31,32,36,37,38,39] {

            combinations += [i.set(1, 4)]

        }

        // Up & Down (+7)

        for i in [1,8,15,2,9,16,3,10,17,4,11,18,5,12,19,6,13,20,7,14,21] {

            combinations += [i.set(7, 4)]

        }

        // Diagnol from Left (+8)

        for i in [1,8,15,2,9,16,3,10,17,4,11,18] {

            combinations += [i.set(8, 4)]

        }

        // Diagnol from Right (+6)

        for i in [4,11,18,5,12,19,6,13,20,7,14,21] {

            combinations += [i.set(6, 4)]

        }

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

        let p1: String = board.grid[indexes[0] - 1]
        let p2: String = board.grid[indexes[1] - 1]
        let p3: String = board.grid[indexes[2] - 1]
        let p4: String = board.grid[indexes[3] - 1]

        if p1 == p2, p2 == p3, p3 == p4, p1 != EmptyPiece {

            guard let index = board?.playerPieces.firstIndex(of: p1) else { return (nil,false) }

            return (index + 1,true)

        }

        return (nil,false)

    }
    
}
