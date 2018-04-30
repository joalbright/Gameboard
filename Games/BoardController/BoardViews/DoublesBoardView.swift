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
        
        initialgrid = board.grid.content as? [[String]] ?? []
        swipe(direction, 0)
        
    }
    
    func swipe(_ direction: Direction, _ loop: Int, _ changed: Bool = false, _ doubles: [[Bool]] = 4 ✕ (4 ✕ false)) {
        
        var moved: Bool = changed
        var doubles: [[Bool]] = doubles
        
        switch direction {
            
        case .left:
            
            for r in board.grid.colRange {
                
                for c in board.grid.rowRange {
                    
//                    guard !doubles[c][r] else { continue }
                    
                    // move from (c,r) to (c,r-1)
                    
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
                    
//                    guard !doubles[c][r] else { continue }
                    
                    // move from (c,row) to (c,row+1)
                    
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
                    
//                    guard !doubles[c][r] else { continue }
                    
                    // move from (c,r) to (c-1,r)
                    
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
                    
//                    guard !doubles[c][r] else { continue }
                    
                    // move from (col,r) to (col+1,r)
                    
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
                
                self.swipe(direction, loop + 1, moved, doubles)
                
            }
            
            return
            
        }
        
        guard moved else { return }

        let _ = Doubles.random(board.grid)
        
        updateBoard()
        
    }
    
}
