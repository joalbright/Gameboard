import SwiftUI

public struct Checkers {
    
    public enum PieceType: String {
        
        case none = ""
        case checker1 = "●"
        case checker2 = "○"
        
        case king1 = "◉"
        case king2 = "◎"
        
    }
    
    public static var board: Grid {
        
        return Grid([
            
            ["", "●", "", "●", "", "●", "", "●"],
            ["●", "", "●", "", "●", "", "●", ""],
            ["", "●", "", "●", "", "●", "", "●"],
            ["", "", "", "", "", "", "", ""],
            ["", "", "", "", "", "", "", ""],
            ["○", "", "○", "", "○", "", "○", ""],
            ["", "○", "", "○", "", "○", "", "○"],
            ["○", "", "○", "", "○", "", "○", ""]
            
        ])
        
    }
    
    public static let playerPieces = ["●◉","○◎"]
    public static let playerColors = [Color(red: 0.864, green: 0.052, blue: 0.022), Color(red: 0.577, green: 0.139, blue: 0.146)]
    public static let playerSecondaryColors = [Color.white, Color.white]
    
    public static func validateJump(_ s1: Square, _ s2: Square, _ p1: Piece, _ p2: Piece, _ grid: inout Grid, _ hint: Bool = false) -> Bool {

        guard grid.onBoard(s1, s2) else { return false }
        
        let m1 = s2.0 - s1.0
        let m2 = s2.1 - s1.1
        
        let e1 = s1.0 + m1 / 2
        let e2 = s1.1 + m2 / 2
        
        
        switch PieceType(rawValue: p1) ?? .none {
            
        case .checker1:
            
            guard m1 == 2 && abs(m2) == 2 else { return false }
            
        case .checker2:
            
            guard m1 == -2 && abs(m2) == 2 else { return false }
            
        case .king1, .king2:
            
            guard abs(m1) == 2 && abs(m2) == 2 else { return false }
            
        case .none: return false
            
        }
        
        let piece1 = grid[s1.0,s1.1]
        let piece2 = grid[e1,e2]
        guard let player = owner(of: piece1), owner(of: piece2) == 1 - player, p2.isEmpty else { return false }
        
        guard !hint else { return true }
        
        grid[e1,e2] = "" // remove other player piece
        
        return true
        
    }
    
    public static func validateMove(_ s1: Square, _ s2: Square, _ p1: Piece, _ p2: Piece, _ grid: inout Grid, _ hint: Bool = false) throws -> Piece? {
        
        guard p2.isEmpty, legalDestinations(from: s1, in: grid).contains(where: { $0 == s2 }) else { throw MoveError.invalidmove }
        guard !hint else { return nil }

        var captured: Piece?

        if abs(s2.0 - s1.0) == 2 {

            let midpoint = ((s1.0 + s2.0) / 2, (s1.1 + s2.1) / 2)
            captured = grid[midpoint.0,midpoint.1]
            grid[midpoint.0,midpoint.1] = ""

        }

        let promotesFirst = p1 == PieceType.checker1.rawValue && s2.0 == 7
        let promotesSecond = p1 == PieceType.checker2.rawValue && s2.0 == 0
        var piece = p1
        if promotesFirst { piece = PieceType.king1.rawValue }
        if promotesSecond { piece = PieceType.king2.rawValue }
        grid[s2.0,s2.1] = piece
        grid[s1.0,s1.1] = ""

        return captured
        
    }

    static func owner(of piece: Piece) -> Int? {

        guard !piece.isEmpty else { return nil }
        return playerPieces.firstIndex { $0.contains(piece) }

    }

    static func captures(from square: Square, in grid: Grid) -> [Square] {

        guard grid.onBoard(square), let player = owner(of: grid[square.0,square.1]) else { return [] }

        return directions(for: grid[square.0,square.1]).compactMap { direction in

            let middle = (square.0 + direction.0, square.1 + direction.1)
            let end = (square.0 + direction.0 * 2, square.1 + direction.1 * 2)
            guard grid.onBoard(end), grid[end.0,end.1].isEmpty else { return nil }
            guard owner(of: grid[middle.0,middle.1]) == 1 - player else { return nil }
            return end

        }

    }

    static func hasCapture(for player: Int, in grid: Grid) -> Bool {

        return grid.rowRange.contains { row in

            grid.colRange.contains { column in owner(of: grid[row,column]) == player && !captures(from: (row,column), in: grid).isEmpty }

        }

    }

    static func legalDestinations(from square: Square, in grid: Grid) -> [Square] {

        guard grid.onBoard(square), let player = owner(of: grid[square.0,square.1]) else { return [] }
        if hasCapture(for: player, in: grid) { return captures(from: square, in: grid) }

        return directions(for: grid[square.0,square.1]).compactMap { direction in

            let end = (square.0 + direction.0, square.1 + direction.1)
            guard grid.onBoard(end), grid[end.0,end.1].isEmpty else { return nil }
            return end

        }

    }

    static func hasLegalMove(for player: Int, in grid: Grid) -> Bool {

        return grid.rowRange.contains { row in

            grid.colRange.contains { column in owner(of: grid[row,column]) == player && !legalDestinations(from: (row,column), in: grid).isEmpty }

        }

    }

    private static func directions(for piece: Piece) -> [Square] {

        switch PieceType(rawValue: piece) {

        case .checker1: return [(1,-1), (1,1)]
        case .checker2: return [(-1,-1), (-1,1)]
        case .king1, .king2: return [(-1,-1), (-1,1), (1,-1), (1,1)]
        default: return []

        }

    }
    
}
