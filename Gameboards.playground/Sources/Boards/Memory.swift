import UIKit

enum MemoryError: Error {
    
    case badmatch
    case nocard
    case samecard
    
}

extension Difficulty {
    
    var memoryDeck: String {
        
        switch self {
        case .easy: return "🂡🂭🂮🂱🂽🂾🃁🃍🃎🃑🃝🃞🃟"
        case .medium: return "🂡🂫🂬🂭🂮🂱🂻🂼🂽🂾🃁🃋🃌🃍🃎🃑🃛🃜🃝🃞🃟"
        case .hard: return "🂡🂢🂣🂤🂥🂦🂧🂨🂩🂪🂫🂬🂭🂮🂱🂲🂳🂴🂵🂶🂷🂸🂹🂺🂻🂼🂽🂾🃁🃂🃃🃄🃅🃆🃇🃈🃉🃊🃋🃌🃍🃎🃑🃒🃓🃔🃕🃖🃗🃘🃙🃚🃛🃜🃝🃞🃟"
        }
        
    }
    
    var memoryDeckPairs: [String] {
        
        return Array(memoryDeck.randomize().prefix(memoryCount.unique))
        
    }
    
    var memoryDeckRandomized: [String] {
        
        return (memoryDeckPairs * memoryCount.pairs).randomize().randomize()
        
    }
    
    var memoryCount: (unique: Int, pairs: Int) {
        
        switch self {
        case .easy: return (4,4)
        case .medium: return (18,2)
        case .hard: return (32,2)
        }
        
    }
    
    var memoryBoard: Grid {
        
        switch self {
        case .easy: return Grid(4 ✕ (4 ✕ "🂠"))
        case .medium: return Grid(6 ✕ (6 ✕ "🂠"))
        case .hard: return Grid(8 ✕ (8 ✕ "🂠"))
        }
        
    }
    
}

extension String {
    
    var memoryColor: UIColor {
        
        switch self {
            
        case "🂡","🂢","🂣","🂤","🂥","🂦","🂧","🂨","🂩","🂪","🂫","🂬","🂭","🂮","🃑","🃒","🃓","🃔","🃕","🃖","🃗","🃘","🃙","🃚","🃛","🃜","🃝","🃞": return .black
        case "🂱","🂲","🂳","🂴","🂵","🂶","🂷","🂸","🂹","🂺","🂻","🂼","🂽","🂾","🃁","🃂","🃃","🃄","🃅","🃆","🃇","🃈","🃉","🃊","🃋","🃌","🃍","🃎": return .red
        case "🃟": return .orange
        default: return .clear
            
        }
        
    }
    
}

public struct Memory {
    
    public static let playerPieces = ["🂠"]

    static func solution(_ difficulty: Difficulty) -> Grid {
        
        let grid = difficulty.memoryBoard
        let deck = difficulty.memoryDeckRandomized
        
        for r in grid.rowRange {
            
            for c in grid.colRange {
                
                grid[c,r] = deck[c+r*4]
                
            }
            
        }
        
        return grid
        
    }
    
    static func puzzle(_ difficulty: Difficulty) -> Grid {
        
        return difficulty.memoryBoard
        
    }
    
    public static func validateSelection(_ s1: Square, _ c1: Card, _ grid: Grid) throws {
        
        guard let card = grid[s1.0,s1.1] as? Card, card != "" else { throw MoveError.invalidmove }
        
        grid[s1.0,s1.1] = c1
        
    }

    public static func validateMatch(_ s1: Square, _ s2: Square, _ c1: Card, _ c2: Card, _ grid: Grid, _ reset: Bool = false) throws -> Card? {
        
        if reset {
        
            let card = c1 == c2 ? "" : "🂠"
            
            grid[s1.0][s1.1] = card
            grid[s2.0][s2.1] = card
            
        } else {
            
            guard let card = grid[s1.0,s1.1] as? Card, card != "" else { throw MemoryError.nocard }
            
            grid[s1.0,s1.1] = c1
            
        }
        
        guard s1 != s2 else { throw MemoryError.samecard }
        guard c1 == c2 else { throw MemoryError.badmatch }
        
        return c1
        
    }
    
}

extension Grid {
    
    public func memory(_ rect: CGRect) -> UIView {
        
        let view = UIView(frame: rect)
        
        view.backgroundColor = colors.background
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let w = (rect.width - content.count + 1) / content.count
        let h = (rect.height - content.count + 1) / content.count
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {
                
                let label = UILabel(frame: CGRect(x: c * w + c, y: r * h + r, width: w, height: h))
                let piece = "\(item)"
                
                label.text = piece
                label.textAlignment = .center
                label.font = .systemFont(ofSize: (w + h) / 2 - 10, weight: .regular)
                label.textColor = player(piece) == 0 ? colors.player1 : piece.memoryColor
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
}
