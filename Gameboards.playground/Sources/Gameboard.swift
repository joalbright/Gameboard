import UIKit

enum Difficulty {
    
    case easy, medium, hard
    
    var name: String {
        
        switch self {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        }
        
    }
    
    init(_ i: Int) {
        
        switch i {
        case 1: self = .medium
        case 2: self = .hard
        default: self = .easy
        }
        
    }
    
}

public struct Gameboard {
    
    public enum BoardType: String {
        
        case backgammon, checkers, chess, connectfour, dots, go, mancala, memory, minesweeper, sudoku, tictactoe, words
        
        static var playable: [BoardType] = [.backgammon,.checkers,.chess,.connectfour,.dots,.go,.mancala,.memory,.minesweeper,.sudoku,.tictactoe, .words]
        
        public var name: String {
            
            switch self {
            case .backgammon: return "Backgammon"
            case .checkers: return "Checkers"
            case .chess: return "Chess"
            case .connectfour: return "Connect Four"
            case .dots: return "Dots"
            case .go: return "Go"
            case .mancala: return "Mancala"
            case .memory: return "Memory"
            case .minesweeper: return "Minesweeper"
            case .sudoku: return "Sudoku"
            case .tictactoe: return "Tic Tac Toe"
            case .words: return "Words"
            }
            
        }
        
        public var emblem: String {
            
            switch self {
            case .backgammon: return "⚄"
            case .checkers: return "✜"
            case .chess: return "♞"
            case .connectfour: return "◉"
            case .dots: return "⦿"
            case .go: return "●"
            case .mancala: return "✾"
            case .memory: return "🂠"
            case .minesweeper: return "⚑"
            case .sudoku: return "9"
            case .tictactoe: return "⌗"
            case .words: return "☐"
            }
            
        }
        
        var controller: UINavigationController? {
            
            guard let vc = UIStoryboard(name: "Boards", bundle: nil).instantiateViewController(withIdentifier: "\(name)Board") as? BoardViewController else { return nil }
            return UINavigationController(rootViewController: vc)
            
        }
        
    }
    
    public var boardColors = BoardColors() { didSet { grid.boardColors = boardColors } }
    
    var _type: BoardType
    
    var playerCount: Int = 2
    var playerTurn: Int = 0 { didSet { playerChange?(playerTurn + 1) } }
    var playerPieces: [Piece] = [] { didSet { grid.playerPieces = playerPieces } }
    
    var grid: Grid = Grid(1 ✕ (1 ✕ ""))
    var solution: Grid = Grid(1 ✕ (1 ✕ ""))
    
    var gridSize: Int { return grid.content.count }
    var difficulty: Difficulty = .easy { didSet { reset() } }
    
    var _size: Int?
    
    public var playerChange: ((Int) -> ())?
    
    public init(_ type: BoardType) {
        
        _type = type
        reset()
        
    }
    
    public init(_ type: BoardType, testing: Bool) {
        
        _type = type
        reset(testing)
        
    }
    
    public init(_ type: BoardType, size: Int) {
        
        _type = type
        _size = size
        reset()
        
    }
    
    mutating func changePlayer() {
        
        playerTurn = playerTurn < playerCount - 1 ? playerTurn + 1 : 0
        
    }
    
    public mutating func guess(toSquare s1: Square) throws { try validateGuess(s1) }
    
    public mutating func guess(toSquare s1: Square, withGuess g1: Guess) throws { try validateGuess(s1, g1) }
    
    public mutating func mark(toSquare s1: Square) throws { try validateMark(s1) }
    
    public mutating func move(toSquare s1: Square) throws {
        
        try validateMove(s1)
        
        changePlayer()
    
    }
    
    public mutating func move(pieceAt s1: Square, toSquare s2: Square) throws -> Piece? {
        
        let piece = try validateMove(s1,s2)
        
        changePlayer()
        
        return piece
    
    }
    
    public mutating func move(pieceAt s1: ChessSquare, toSquare s2: ChessSquare) throws -> Piece? {
        
        let cols = "abcdefgh".array()
        guard let c1 = cols.index(of: s1.0), let c2 = cols.index(of: s2.0) else { return nil }
        let r1 = 8 - s1.1, r2 = 8 - s2.1
        
        let piece = try validateMove((r1,c1), (r2,c2))
        
        changePlayer()
                
        return piece
        
    }
    
    public mutating func select(cardAt s1: Square) throws { return try validateSelection(s1) }
    
    public mutating func match(cardAt s1: Square, withCard s2: Square, reset: Bool = false) throws -> Card? { return try validateMatch(s1, s2, reset) }
    
    public mutating func reset(_ testing: Bool = false) {
        
        highlights = []
        selected = nil
        
        switch _type {
            
        case .backgammon:
            
            grid = Backgammon.board
            playerPieces = Backgammon.playerPieces
            
        case .checkers:
            
            grid = Checkers.board
            playerPieces = Checkers.playerPieces
            
        case .chess:
            
            grid = Chess.board
            playerPieces = Chess.playerPieces
            
        case .connectfour:
            
            grid = ConnectFour.board
            playerPieces = ConnectFour.playerPieces
            
            guard testing else { break }
            
            grid = ConnectFour.staticboard
            playerPieces = ConnectFour.playerPieces
            
        case .dots:
            
            grid = Dots.board
            playerPieces = Dots.playerPieces
            
            guard testing else { break }
            
            grid = Dots.staticboard
            playerPieces = Dots.playerPieces
            
        case .go:
            
            grid = Go.board
            playerPieces = Go.playerPieces
            
        case .mancala:
            
            grid = Mancala.board
            playerPieces = Mancala.playerPieces
            
            guard testing else { break }
            
            grid = Mancala.staticboard
            playerPieces = Mancala.playerPieces
            
        case .memory:
            
            solution = Memory.solution(difficulty)
            grid = Memory.puzzle(difficulty)
            playerPieces = Memory.playerPieces
            
        case .minesweeper:
            
            solution = Minesweeper.board
            grid = Minesweeper.field
            playerPieces = Minesweeper.playerPieces
            
            guard testing else { break }
            
            solution = Minesweeper.staticboard
            playerPieces = Minesweeper.playerPieces
            
        case .sudoku:
            
            solution = Sudoku.board
            grid = Sudoku.puzzle(solution, difficulty: difficulty)
            playerPieces = Sudoku.playerPieces
            
            guard testing else { break }
            
            solution = Sudoku.staticboard
            grid = Sudoku.staticpuzzle(solution)
            playerPieces = Sudoku.playerPieces
            
        case .tictactoe:
            
            grid = TicTacToe.board
            playerPieces = TicTacToe.playerPieces
            
        case .words:
            
            grid = Words.board
            playerPieces = Words.playerPieces
            
        }
        
    }
    
    public var highlights: [Square] = []
    public var selected: Square?
    
    public func visualize(_ rect: CGRect = CGRect(x: 0, y: 0, width: 200, height: 200)) -> UIView {
        
        switch _type {
            
        case .backgammon: return grid.backgammon(rect)
        case .checkers, .chess: return grid.checker(rect, highlights: highlights, selected: selected)
        case .connectfour: return grid.connectfour(rect)
        case .dots: return grid.dots(rect)
        case .go: return grid.go(rect)
        case .mancala: return grid.mancala(rect)
        case .memory: return grid.memory(rect)
        case .minesweeper: return grid.mine(rect)
        case .sudoku: return grid.sudoku(rect, highlights: highlights)
        case .tictactoe: return grid.ttt(rect)
        case .words: return grid.words(rect)
            
        }
        
    }
    
}

public struct BoardColors {
    
    public var background: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    public var foreground: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    public var player1: UIColor = .red
    public var player2: UIColor = .blue
    
    public var highlight: UIColor = .green
    public var selected: UIColor = .green
    
    public init() { }
    
}

