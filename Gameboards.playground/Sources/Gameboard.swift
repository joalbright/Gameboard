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
        
        case backgammon, bombsweeper, checkers, chess, dots, doubles, four, go, mancala, memory, pegs, sudoku, tictactoe, words
        
        static var playable: [BoardType] = [.backgammon,.bombsweeper,.checkers,.chess,.dots,.doubles,.four,.go,.memory,.pegs,.sudoku,.tictactoe, .words]
        
        public var name: String {
            
            switch self {
            case .backgammon: return "Backgammon"
            case .bombsweeper: return "Bombsweeper"
            case .checkers: return "Checkers"
            case .chess: return "Chess"
            case .dots: return "Dots"
            case .doubles: return "Doubles"
            case .four: return "Four"
            case .go: return "Go"
            case .mancala: return "Mancala"
            case .memory: return "Memory"
            case .pegs: return "Pegs"
            case .sudoku: return "Sudoku"
            case .tictactoe: return "Tic Tac Toe"
            case .words: return "Words"
            }
            
        }
        
        public var emblem: String {
            
            switch self {
            case .backgammon: return "⚄"
            case .bombsweeper: return "⚑"
            case .checkers: return "●"
            case .chess: return "♞"
            case .dots: return "⦿"
            case .doubles: return "⚭"
            case .four: return "◉"
            case .go: return "●"
            case .mancala: return "✾"
            case .memory: return "🂠"
            case .pegs: return "✜"
            case .sudoku: return "9"
            case .tictactoe: return "⌗"
            case .words: return "☐"
            }
            
        }
        
        var controller: UINavigationController? {
            
            guard let vc = UIStoryboard(name: name.replacingOccurrences(of: " ", with: ""), bundle: nil).instantiateInitialViewController() as? BoardViewController else { return nil }
            return UINavigationController(rootViewController: vc)
            
        }
        
    }
    
    public var padding: CGFloat = 0 { didSet { grid.padding = padding } }
    public var colors = BoardColors() { didSet { grid.colors = colors } }
    
    var _type: BoardType
    
    var playerCount: Int = 2
    var playerTurn: Int = 0 { didSet { playerChange?(playerTurn + 1) } }
    var playerPieces: [Piece] = [] {

        didSet {

            grid.playerPieces = playerPieces
            playerCount = playerPieces.count
            
        }

    }
    
    var grid: Grid = Grid(1 ✕ (1 ✕ ""))
    var solution: Grid = Grid(1 ✕ (1 ✕ ""))
    
    var gridSize: Int { return grid.content.count }
    var difficulty: Difficulty = .easy { didSet { reset() } }
    
    var _size: Int?
    
    public var playerChange: ((Int) -> Void)?
    public var showAlert: ((String, String) -> Void)?
    
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
    
    public mutating func showAvailable(_ s1: Square) {
        
        highlights = []
        
        switch _type {
            
        case .chess, .checkers, .pegs:
            
            selected = nil
            
            for r in grid.rowRange {
                
                for c in grid.colRange {
                    
                    guard let _ = try? validateMove(s1, (r,c), true) else { continue }
                    selected = s1
                    highlights.append((r,c))
                    
                }
                
            }
            
        default: break
            
        }
        
    }
    
    public mutating func showAvailable(_ s1: ChessSquare) {
        
        let cols: [String] = "abcdefgh".map { "\($0)" }
        guard let c1 = cols.firstIndex(of: s1.0) else { return }
        let r1 = 8 - s1.1
        
        showAvailable((r1,c1))
        
    }
    
    public mutating func drop(pieceAt s1: Square) throws { try validateDrop(s1) }
    
    public mutating func place(tile t1: Words.Letter, at s1: Square) throws { try validate(t1, s1)  }
    
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
        guard let c1 = cols.firstIndex(of: s1.0), let c2 = cols.firstIndex(of: s2.0) else { return nil }
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
            
        case .bombsweeper:
            
            solution = Bombsweeper.board
            grid = Bombsweeper.field
            playerPieces = Bombsweeper.playerPieces
            
            guard testing else { break }
            
            solution = Bombsweeper.staticboard
            playerPieces = Bombsweeper.playerPieces
            
        case .checkers:
            
            grid = Checkers.board
            playerPieces = Checkers.playerPieces
            
        case .chess:
            
            grid = Chess.board
            playerPieces = Chess.playerPieces
            
        case .dots:
            
            grid = Dots.board
            playerPieces = Dots.playerPieces
            
            guard testing else { break }
            
            grid = Dots.staticboard
            playerPieces = Dots.playerPieces
            
        case .doubles:
            
            grid = Doubles.board
            playerPieces = Doubles.playerPieces
            
            let _ = Doubles.random(grid)
            let _ = Doubles.random(grid)
            
            guard testing else { break }
            
            grid = Doubles.staticboard
            playerPieces = Doubles.playerPieces
            
        case .four:
            
            grid = Four.board
            playerPieces = Four.playerPieces
            
            guard testing else { break }
            
            grid = Four.staticboard
            playerPieces = Four.playerPieces
            
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
            
        case .pegs:
            
            grid = Pegs.board
            playerPieces = Pegs.playerPieces
            
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
        case .bombsweeper: return grid.bomb(rect)
        case .checkers, .chess: return grid.checker(rect, highlights: highlights, selected: selected)
        case .four: return grid.four(rect)
        case .dots: return grid.dots(rect)
        case .doubles: return grid.doubles(rect)
        case .go: return grid.go(rect)
        case .mancala: return grid.mancala(rect)
        case .memory: return grid.memory(rect)
        case .pegs: return grid.pegs(rect, highlights: highlights, selected: selected)
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

