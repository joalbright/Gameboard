import SwiftUI

public struct Chess {
    
    public enum PieceType: String {
        
        case none = ""
        
        case rook1 = "♜"
        case knight1 = "♞"
        case bishop1 = "♝"
        case queen1 = "♛"
        case king1 = "♚"
        case pawn1 = "♟"
        
        case rook2 = "♖"
        case knight2 = "♘"
        case bishop2 = "♗"
        case queen2 = "♕"
        case king2 = "♔"
        case pawn2 = "♙"
        
    }
    
    public static var board: Grid {
        
        return Grid([
            
            "♜♞♝♛♚♝♞♜".array(),
            8 ✕ "♟",
            8 ✕ "",
            8 ✕ "",
            8 ✕ "",
            8 ✕ "",
            8 ✕ "♙",
            "♖♘♗♕♔♗♘♖".array()
            
        ])
        
    }
    
    public static let playerPieces = ["♜♞♝♛♚♝♞♜♟","♖♘♗♕♔♗♘♖♙"]
    public static let playerColors = [Color.white, Color.black]
    public static let playerSecondaryColors = [Color.black, Color.white]
    
    enum Promotion: String, CaseIterable, Identifiable {

        case queen, rook, bishop, knight

        var id: Self { self }

        func piece(for player: Int) -> Piece {

            let pieces = player == 0 ? ["♛", "♜", "♝", "♞"] : ["♕", "♖", "♗", "♘"]
            return pieces[Self.allCases.firstIndex(of: self)!]

        }

    }

    struct State {

        var castlingRights: Set<Int> = [0, 4, 7, 56, 60, 63]
        var enPassant: Square?
        var halfMoves = 0

    }

    static func owner(of piece: Piece) -> Int? {

        guard !piece.isEmpty else { return nil }
        return playerPieces.firstIndex { $0.contains(piece) }

    }

    static func isPawn(_ piece: Piece) -> Bool { ["♟", "♙"].contains(piece) }
    static func isKing(_ piece: Piece) -> Bool { ["♚", "♔"].contains(piece) }

    public static func validateEmptyPath(_ start: Square, _ end: Square, _ grid: Grid) throws {

        guard grid.onBoard(start, end), start != end else { throw MoveError.invalidmove }
        let row = end.0 - start.0
        let column = end.1 - start.1
        guard row == 0 || column == 0 || abs(row) == abs(column) else { throw MoveError.invalidmove }
        let dr = row.signum()
        let dc = column.signum()
        var square = (start.0 + dr, start.1 + dc)

        while square != end {

            guard grid[square.0,square.1].isEmpty else { throw MoveError.blockedmove }
            square = (square.0 + dr, square.1 + dc)

        }

    }

    static func isAttacked(_ target: Square, by player: Int, in grid: Grid) -> Bool {

        for row in grid.rowRange {

            for column in grid.colRange where owner(of: grid[row,column]) == player {

                let piece = grid[row,column]
                let dr = target.0 - row
                let dc = target.1 - column

                switch PieceType(rawValue: piece) {

                case .pawn1, .pawn2:
                    if dr == (player == 0 ? 1 : -1), abs(dc) == 1 { return true }

                case .knight1, .knight2:
                    if abs(dr) * abs(dc) == 2 { return true }

                case .king1, .king2:
                    if max(abs(dr), abs(dc)) == 1 { return true }

                case .rook1, .rook2:
                    if (dr == 0 || dc == 0), (try? validateEmptyPath((row,column), target, grid)) != nil { return true }

                case .bishop1, .bishop2:
                    if abs(dr) == abs(dc), (try? validateEmptyPath((row,column), target, grid)) != nil { return true }

                case .queen1, .queen2:
                    if (dr == 0 || dc == 0 || abs(dr) == abs(dc)), (try? validateEmptyPath((row,column), target, grid)) != nil { return true }

                default: break

                }

            }

        }

        return false

    }

    static func isInCheck(_ player: Int, in grid: Grid) -> Bool {

        let king = player == 0 ? "♚" : "♔"

        for row in grid.rowRange {

            for column in grid.colRange where grid[row,column] == king { return isAttacked((row,column), by: 1 - player, in: grid) }

        }

        return true

    }

    static func applying(_ start: Square, to end: Square, in grid: Grid, state: State, promotion: Promotion = .queen) throws -> (grid: Grid, state: State, captured: Piece?) {

        guard grid.onBoard(start, end), start != end, let player = owner(of: grid[start.0,start.1]) else { throw MoveError.invalidmove }
        let piece = grid[start.0,start.1]
        let target = grid[end.0,end.1]
        guard owner(of: target) != player, !isKing(target) else { throw MoveError.friendlyfire }
        let dr = end.0 - start.0
        let dc = end.1 - start.1
        var next = grid
        var nextState = state
        var captured = target.isEmpty ? nil : target

        switch PieceType(rawValue: piece) {

        case .pawn1, .pawn2:

            let direction = player == 0 ? 1 : -1
            let home = player == 0 ? 1 : 6

            if dc == 0 {

                guard target.isEmpty, dr == direction || (start.0 == home && dr == direction * 2) else { throw MoveError.invalidmove }
                try validateEmptyPath(start, end, grid)

            } else {

                guard abs(dc) == 1, dr == direction else { throw MoveError.invalidmove }

                if target.isEmpty {

                    let victim = (start.0, end.1)
                    guard let enPassant = state.enPassant, enPassant == end, grid[victim.0,victim.1] == (player == 0 ? "♙" : "♟") else { throw MoveError.invalidmove }
                    captured = grid[victim.0,victim.1]
                    next[victim.0,victim.1] = ""

                }

            }

        case .knight1, .knight2:

            guard abs(dr) * abs(dc) == 2 else { throw MoveError.invalidmove }

        case .bishop1, .bishop2:

            guard abs(dr) == abs(dc) else { throw MoveError.invalidmove }
            try validateEmptyPath(start, end, grid)

        case .rook1, .rook2:

            guard dr == 0 || dc == 0 else { throw MoveError.invalidmove }
            try validateEmptyPath(start, end, grid)

        case .queen1, .queen2:

            try validateEmptyPath(start, end, grid)

        case .king1, .king2:

            if dr == 0, abs(dc) == 2 {

                let home = player == 0 ? 0 : 7
                let rookColumn = dc > 0 ? 7 : 0
                let rook = player == 0 ? "♜" : "♖"
                guard start == (home,4), state.castlingRights.contains(home * 8 + 4), state.castlingRights.contains(home * 8 + rookColumn) else { throw MoveError.invalidmove }
                guard grid[home,rookColumn] == rook, target.isEmpty, !isInCheck(player, in: grid) else { throw MoveError.invalidmove }
                try validateEmptyPath(start, (home,rookColumn), grid)
                var transit = grid
                transit[start.0,start.1] = ""
                transit[home,4 + dc.signum()] = piece
                guard !isInCheck(player, in: transit) else { throw MoveError.invalidmove }
                next[home,rookColumn] = ""
                next[home,4 + dc.signum()] = rook
                nextState.castlingRights.remove(home * 8 + rookColumn)

            } else {

                guard max(abs(dr), abs(dc)) == 1 else { throw MoveError.invalidmove }

            }

        default: throw MoveError.incorrectpiece

        }

        next[start.0,start.1] = ""
        next[end.0,end.1] = piece
        if isPawn(piece), end.0 == (player == 0 ? 7 : 0) { next[end.0,end.1] = promotion.piece(for: player) }
        guard !isInCheck(player, in: next) else { throw MoveError.invalidmove }
        nextState.castlingRights.remove(start.0 * 8 + start.1)
        nextState.castlingRights.remove(end.0 * 8 + end.1)
        nextState.enPassant = nil
        if isPawn(piece), abs(dr) == 2 { nextState.enPassant = (start.0 + dr / 2, start.1) }
        nextState.halfMoves = isPawn(piece) || captured != nil ? 0 : state.halfMoves + 1
        return (next, nextState, captured)

    }

    static func legalMoves(for player: Int, in grid: Grid, state: State) -> [(Square, Square)] {

        var moves: [(Square, Square)] = []

        for row in grid.rowRange {

            for column in grid.colRange where owner(of: grid[row,column]) == player {

                for targetRow in grid.rowRange {

                    for targetColumn in grid.colRange {

                        let start = (row,column)
                        let end = (targetRow,targetColumn)
                        if (try? applying(start, to: end, in: grid, state: state)) != nil { moves.append((start,end)) }

                    }

                }

            }

        }

        return moves

    }

    static func positionKey(_ grid: Grid, player: Int, state: State) -> String {

        let rights = [0,7,56,63].filter { corner in

            let king = corner < 8 ? 4 : 60
            return state.castlingRights.contains(king) && state.castlingRights.contains(corner)

        }
        var key = grid.content.flatMap { $0 }.map { $0.isEmpty ? "." : $0 }.joined() + ":\(player):\(rights)"

        if let target = state.enPassant {

            let sourceRow = target.0 + (player == 0 ? -1 : 1)

            for column in [target.1 - 1, target.1 + 1] {

                let source = (sourceRow,column)

                if grid.onBoard(source), owner(of: grid[source.0,source.1]) == player, isPawn(grid[source.0,source.1]), (try? applying(source, to: target, in: grid, state: state)) != nil {

                    key += ":\(target.0),\(target.1)"
                    break

                }

            }

        }

        return key

    }

    static func hasInsufficientMaterial(_ grid: Grid) -> Bool {

        var minorSquares: [(Piece, Int)] = []

        for row in grid.rowRange {

            for column in grid.colRange {

                let piece = grid[row,column]
                if piece.isEmpty || isKing(piece) { continue }
                guard ["♝","♗","♞","♘"].contains(piece) else { return false }
                minorSquares.append((piece, (row + column) % 2))

            }

        }

        if minorSquares.count <= 1 { return true }
        return minorSquares.allSatisfy { ["♝","♗"].contains($0.0) } && Set(minorSquares.map { $0.1 }).count == 1

    }

    public static func validateMove(_ start: Square, _ end: Square, _ piece: Piece, _ target: Piece, _ grid: inout Grid, _ hint: Bool = false) throws -> Piece? {

        let move = try applying(start, to: end, in: grid, state: State())
        if !hint { grid = move.grid }
        return move.captured

    }

}

// Coordinates

public let A8 = ("a",8), A7 = ("a",7), A6 = ("a",6), A5 = ("a",5), A4 = ("a",4), A3 = ("a",3), A2 = ("a",2), A1 = ("a",1)
public let B8 = ("b",8), B7 = ("b",7), B6 = ("b",6), B5 = ("b",5), B4 = ("b",4), B3 = ("b",3), B2 = ("b",2), B1 = ("b",1)
public let C8 = ("c",8), C7 = ("c",7), C6 = ("c",6), C5 = ("c",5), C4 = ("c",4), C3 = ("c",3), C2 = ("c",2), C1 = ("c",1)
public let D8 = ("d",8), D7 = ("d",7), D6 = ("d",6), D5 = ("d",5), D4 = ("d",4), D3 = ("d",3), D2 = ("d",2), D1 = ("d",1)
public let E8 = ("e",8), E7 = ("e",7), E6 = ("e",6), E5 = ("e",5), E4 = ("e",4), E3 = ("e",3), E2 = ("e",2), E1 = ("e",1)
public let F8 = ("f",8), F7 = ("f",7), F6 = ("f",6), F5 = ("f",5), F4 = ("f",4), F3 = ("f",3), F2 = ("f",2), F1 = ("f",1)
public let G8 = ("g",8), G7 = ("g",7), G6 = ("g",6), G5 = ("g",5), G4 = ("g",4), G3 = ("g",3), G2 = ("g",2), G1 = ("g",1)
public let H8 = ("h",8), H7 = ("h",7), H6 = ("h",6), H5 = ("h",5), H4 = ("h",4), H3 = ("h",3), H2 = ("h",2), H1 = ("h",1)
