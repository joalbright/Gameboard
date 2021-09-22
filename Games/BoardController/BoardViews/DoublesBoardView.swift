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
    
    var initialgrid: [[String]] = []

    override func swipe(_ direction: Direction) {
        
        initialgrid = board.grid.content
        swipe(direction, 0)
        
    }
    
    func swipe(_ direction: Direction, _ loop: Int, _ changed: Bool = false) {
        
        var moved: Bool = changed
        
        switch direction {
            
        case .left:
            
            for r in board.grid.colRange {
                
                for c in board.grid.rowRange {
                    
                    do {
                        
                         
                        _ = try board.move(pieceAt: (c,r), toSquare: (c,r-1))
                        
                        moved = true
                        
                    } catch {
                        
                        print(error)
                        
                    }
                    
                }
                
            }
            
        case .right:
            
            for r in board.grid.colRange {
                
                let row = board.grid.rowRange.upperBound - 1 - r
                
                print(r,row)
                
                for c in board.grid.colRange {
                    
                    do {
                       
                        _ = try board.move(pieceAt: (c,row), toSquare: (c,row+1))
                        
                        moved = true
                        
                    } catch {
                        
                        print(error)
                        
                    }
                    
                }
                
            }
            
        case .up:
            
            for c in board.grid.colRange {
                
                for r in board.grid.rowRange {
                    
                    do {
                        
                        _ = try board.move(pieceAt: (c,r), toSquare: (c-1,r))
                        
                        moved = true
                        
                    } catch {
                        
                        print(error)
                        
                    }
                    
                }
                
            }
            
        case .down:
            
            for c in board.grid.colRange {
                
                let col = board.grid.colRange.upperBound - 1 - c
                
                print(c,col)
                
                for r in board.grid.rowRange {
                    
                    do {
                    
                        _ = try board.move(pieceAt: (col,r), toSquare: (col+1,r))
                        
                        moved = true
                        
                    } catch {
                    
                        print(error)
                    
                    }
                    
                }
                
            }
            
        }
        
        updateBoard()
        
        guard loop == 3 else {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                
                self.swipe(direction, loop + 1, moved)
                
            }
            
            return
            
        }
        
        guard moved else { return }

        let _ = Doubles.random(board.grid)
        
        updateBoard()
        
    }
    
}
