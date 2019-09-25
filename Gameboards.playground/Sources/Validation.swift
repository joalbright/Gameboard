import UIKit

public enum MoveError: Error {
    
    /// Good try. Need a hint?
    case incorrectguess
    /// Seriously??? There is no reason to go off the board.
    case outofbounds
    /// Piece cannot move to that square
    case invalidmove
    /// Cannot take out your own piece
    case friendlyfire
    /// Another piece is in the way
    case blockedmove
    /// Piece is not of the current player
    case notyourturn
    /// Ummm... I think you may be lost
    case noplayer
    /// What type of game are you playing???
    case incorrectpiece
    /// Validation is unfinished... not letting you cheat.
    case validationfailed
    
}

public enum GameStatus: Error {
    
    /// Ouch. Why don't you try again?
    case gameover
    /// You win! Don't let it go to your head.
    case winner
    /// This is awkward.
    case stalemate
    
}

public enum FunctionalityError: Error {
    
    /// Can't do this... maybe a future feature if you bug me enough.
    case unavailable
    
}

extension Gameboard {
    
    func validateNotFriendlyFire(_ p1: Piece, _ p2: Piece) throws -> Bool {
        
        var _player1: Int?
        var _player2: Int?
        
        for (p,pieces) in playerPieces.enumerated() {
            
            if pieces.contains(p1) { _player1 = p }
            if pieces.contains(p2) { _player2 = p }
            
        }
        
        guard let player1 = _player1 else { throw MoveError.noplayer }
        
        if let player2 = _player2 {
            
            guard player1 != player2 else { throw MoveError.friendlyfire }
            
        }
        
        return true
        
    }
    
    func validatePlayer(_ piece: Piece) -> Bool {
        
        guard playerPieces.count > 0 else { return true }
        return playerPieces[playerTurn].contains(piece)
        
    }
    
    // moves, guesses, etc
    
    mutating func validate(_ t1: Words.Letter, _ s1: Square) throws {
        
        guard grid.onBoard(s1) else { throw MoveError.outofbounds }
        
        switch _type {
            
        case .words: try Words.validate(t1, s1, grid)
        default: throw MoveError.incorrectpiece
            
        }
        
    }
    
    mutating func validateGuess(_ s1: Square) throws {
        
        guard grid.onBoard(s1) else { throw MoveError.outofbounds }
        
        switch _type {
            
        case .bombsweeper: try Bombsweeper.validateGuess(s1, grid, solution)
        default: throw MoveError.incorrectpiece
            
        }
        
    }
    
    mutating func validateGuess(_ s1: Square, _ g1: Guess) throws {
        
        guard grid.onBoard(s1) else { throw MoveError.outofbounds }
        
        switch _type {
            
        case .sudoku: try Sudoku.validateGuess(s1, g1, grid, solution)
        default: throw MoveError.incorrectpiece
            
        }
        
        highlights.append(s1)
        
    }
    
    mutating func validateSelection(_ s1: Square) throws {
        
        guard grid.onBoard(s1) else { throw MoveError.outofbounds }
        
        guard let c1 = solution[s1.0,s1.1] as? Card else { throw MoveError.incorrectpiece }
        
        switch _type {
            
        case .memory: return try Memory.validateSelection(s1, c1, grid)
        default: throw MoveError.incorrectpiece
            
        }
        
    }
    
    mutating func validateMatch(_ s1: Square, _ s2: Square, _ reset: Bool = false) throws -> Card? {
        
        guard grid.onBoard(s1, s2) else { throw MoveError.outofbounds }
        
        guard let c1 = solution[s1.0,s1.1] as? Card else { throw MoveError.incorrectpiece }
        guard let c2 = solution[s2.0,s2.1] as? Card else { throw MoveError.incorrectpiece }
        
        switch _type {
            
        case .memory: return try Memory.validateMatch(s1, s2, c1, c2, grid, reset)
        default: throw MoveError.incorrectpiece
            
        }
        
    }
    
    mutating func validateDrop(_ s1: Square) throws {
        
        
        guard grid.onBoard((s1.0 + 1,s1.1)) else { throw MoveError.outofbounds }
        
        var p1 = playerPieces[playerTurn]
        
        if grid.onBoard(s1) { p1 = grid[s1.0][s1.1] as? Piece ?? p1 }
        
        if s1.0 == 0 { changePlayer() }
        
        switch _type {
            
        case .four: try Four.validateDrop(s1, p1, grid)
        default: throw MoveError.incorrectpiece
            
        }
        
    }
    
    mutating func validateMark(_ s1: Square) throws {
        
        guard grid.onBoard(s1) else { throw MoveError.outofbounds }
        
        switch _type {
            
        case .bombsweeper: try Bombsweeper.validateMark(s1, grid, solution)
        default: throw MoveError.incorrectpiece
            
        }
        
    }
    
    mutating func validateMove(_ s1: Square) throws {
        
        guard grid.onBoard(s1) else { throw MoveError.outofbounds }
        
        guard let p1 = grid[s1.0,s1.1] as? Piece else { throw MoveError.incorrectpiece }
        
        switch _type {
            
        case .go: try Go.validateMove(s1, p1, grid, playerTurn)
        case .tictactoe: try TicTacToe.validateMove(s1, p1, grid, playerTurn)
        case .dots: try Dots.validateMove(s1, p1, grid, playerTurn)
        default: throw MoveError.incorrectpiece
            
        }
        
    }
    
    mutating func validateMove(_ s1: Square, _ s2: Square, _ hint: Bool = false) throws -> Piece? {
        
        guard grid.onBoard(s1, s2) else { throw MoveError.outofbounds }
        
        guard let p1 = grid[s1.0,s1.1] as? Piece else { throw MoveError.incorrectpiece }
        guard let p2 = grid[s2.0,s2.1] as? Piece else { throw MoveError.incorrectpiece }
        
        guard validatePlayer(p1) else { throw MoveError.notyourturn }
        
        if playerCount > 1 { _ = try validateNotFriendlyFire(p1, p2) }
        
        switch _type {
            
        case .checkers: return try Checkers.validateMove(s1, s2, p1, p2, grid, hint)
        case .chess: return try Chess.validateMove(s1, s2, p1, p2, grid, hint)
        case .doubles: return try Doubles.validateMove(s1, s2, p1, p2, grid)
        case .pegs: return try Pegs.validateMove(s1, s2, p1, p2, grid, hint)
        default: throw MoveError.incorrectpiece
            
        }
        
    }
    
}
