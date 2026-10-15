//
//  Pegs.swift
//  Games
//
//  Created by Jo Albright on 4/25/18.
//  Copyright © 2018 Jo Albright. All rights reserved.
//

import Foundation

class Pegs: NSObject {
    
    public static var board: Grid {
        
        return Grid([
        
            "!!●●●!!".array(),
            "!!●●●!!".array(),
            "●●●●●●●".array(),
            "●●● ●●●".array(),
            "●●●●●●●".array(),
            "!!●●●!!".array(),
            "!!●●●!!".array()
            
        ])
        
    }
    
    public static let playerPieces = ["●"]

    static func hasLegalMove(_ grid: Grid) -> Bool {

        for row in grid.rowRange {

            for column in grid.colRange where grid[row,column] == "●" {

                for direction: Square in [(-2,0), (2,0), (0,-2), (0,2)] {

                    let end = (row + direction.0, column + direction.1)
                    guard grid.onBoard(end) else { continue }
                    if grid[end.0,end.1] == " ", grid[row + direction.0 / 2,column + direction.1 / 2] == "●" { return true }

                }

            }

        }

        return false

    }
    
    public static func validateMove(_ s1: Square, _ s2: Square, _ p1: Piece, _ p2: Piece, _ grid: inout Grid, _ hint: Bool = false) throws -> Piece? {
        
        let m1 = s2.0 - s1.0
        let m2 = s2.1 - s1.1
        
        guard p1 == "●" && p2 == " " else { throw MoveError.invalidmove }
        
        guard (abs(m1) == 2 && abs(m2) == 0) || (abs(m1) == 0 && abs(m2) == 2) else { throw MoveError.invalidmove }
        
        let e1 = s1.0 + m1 / 2
        let e2 = s1.1 + m2 / 2
        
        let piece = grid[e1,e2]
        
        guard piece == "●" else { throw MoveError.invalidmove }
        
        guard !hint else { return nil }
        
        grid[s2.0,s2.1] = p1
        grid[s1.0,s1.1] = " " // remove initial piece
        grid[e1,e2] = " " // remove jumped piece
        
        return piece
        
    }

}
