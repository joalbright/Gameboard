import UIKit

public class Grid {
    
    public var content: [[Any]]
    
    public var rowRange: CountableRange<Int> { return 0..<content.count }
    public var colRange: CountableRange<Int> { return content.count > 0 ? 0..<content[0].count : 0..<0 }
    
    public var boardColors = BoardColors()
    public var playerPieces: [Piece] = []
    
    public init(_ content: [[Any]]) {
        
        self.content = content
        
    }
    
    public func backgammon(_ rect: CGRect) -> UIView {
        
        let view = BackgammonView(frame: rect)
        
        let w = (rect.width - 50) / 12
        let h = (rect.height - 110) / 10
        
        view.backgroundColor = boardColors.background
        view.backgroundColor2 = boardColors.foreground
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {
                
                let y = r > 4 ? 95 : 15
                let x = c > 5 ? 35 : 15
                
                let label = UILabel(frame: CGRect(x: c * w + x, y: r * h + y, width: w, height: h))
                var piece = "\(item)"
                
                label.textColor = player(piece) == 0 ? boardColors.player1 : boardColors.player2
                
                if player(piece) == 1 {
                    
                    if let index = playerPieces[1].array().index(of: piece) { piece = playerPieces[0].array()[index] }
                    
                }
                
                label.text = piece
                label.textAlignment = .center
                label.font = .systemFont(ofSize: (w + h) / 2, weight: .regular)
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
    public func checker(_ rect: CGRect, highlights: [Square], selected: Square?) -> UIView {
        
        let view = UIView(frame: rect)
        
        let w = rect.width / content.count
        let h = rect.height / content.count
        
        view.backgroundColor = boardColors.background
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {
                
                let label = HintLabel(frame: CGRect(x: c * w, y: r * h, width: w, height: h))
                var piece = "\(item)"
                
                label.backgroundColor = (c + r) % 2 == 0 ? boardColors.background : boardColors.foreground
                label.textColor = player(piece) == 0 ? boardColors.player1 : boardColors.player2
                label.highlightColor = boardColors.highlight
                
                if player(piece) == 1 {
                    
                    if let index = playerPieces[1].array().index(of: piece) { piece = playerPieces[0].array()[index] }
                    
                }
                
                if let selected = selected, selected.0 == r && selected.1 == c { label.textColor = boardColors.selected }
                for highlight in highlights { label.highlight = label.highlight ? true : highlight.0 == r && highlight.1 == c }
                
                label.text = piece
                label.textAlignment = .center
                label.font = .systemFont(ofSize: (w + h) / 2 - 10, weight: .thin)
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
    public func connectfour(_ rect: CGRect) -> UIView {
        
        let view = ConnectFourView(frame: rect)
        
        let p = 15
        let w = (rect.width - p * 2) / 7
        let h = (rect.height - p * 2) / 7
        
        view.backgroundColor = boardColors.background
        
        view.p = 15
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {
                
                let label = HintLabel(frame: CGRect(x: c * w + p, y: r * h + p + h, width: w, height: h))
                var piece = "\(item)"
                
                label.textColor = player(piece) == 0 ? boardColors.player1 : boardColors.player2
                label.highlightColor = boardColors.highlight
                
                if player(piece) == 1 {
                    
                    if let index = playerPieces[1].array().index(of: piece) { piece = playerPieces[0].array()[index] }
                    
                }
                
                label.text = piece
                label.textAlignment = .center
                label.font = .systemFont(ofSize: (w + h) / 2 - 10, weight: .regular)
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
    public func dots(_ rect: CGRect) -> UIView {
        
        let view = DotsView(frame: rect)
        
        view.p = 10
        view.backgroundColor = boardColors.background
        view.lineColor = boardColors.foreground
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let p = 10
        let w = (rect.width - p * 2) / 8
        let h = (rect.height - p * 2) / 8
        
        let sp: [(CGFloat,CGFloat)] = [(-1,0),(0,-1),(1,0),(0,1)]
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {
                
                var sides = "\(item)".array()
                let owner = sides.removeLast()
                
                for (s,side) in sides.enumerated() {
                    
                    guard side != "0" else { continue }
                    
                    let (dx,dy) = sp[s]
                    
                    let width = dx == 0 ? w + 14 : 14
                    let height = dy == 0 ? h + 14 : 14
                    let x = c * w + p + w / 2 + (dx * w / 2)
                    let y = r * h + p + w / 2 + (dy * h / 2)
                    
                    let lineView = DotsLineView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                    
                    lineView.backgroundColor = .clear
                    lineView.center = CGPoint(x: x, y: y)
                    lineView.playerColor = side == "1" ? boardColors.player1 : boardColors.player2
                    lineView.lineColor = boardColors.foreground
                    
                    view.addSubview(lineView)
                    
                }
                
                guard owner != "0" else { continue }
                
                let dotView = DotsSquareView(frame: CGRect(x: c * w + p, y: r * h + p, width: w, height: h).insetBy(dx: 5, dy: 5))
                
                dotView.backgroundColor = .clear
                dotView.playerColor = owner == "1" ? boardColors.player1 : boardColors.player2
                
                view.addSubview(dotView)
                
            }
            
        }
        
        return view
        
    }
    
    public func go(_ rect: CGRect) -> UIView {
        
        let view = GoView(frame: rect)
        
        view.p = 30
        view.backgroundColor = boardColors.background
        view.lineColor = boardColors.foreground
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let p = 30
        let w = (rect.width - p * 2) / 8
        let h = (rect.height - p * 2) / 8
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {
            
                let label = UILabel(frame: CGRect(x: c * w + p - w / 2, y: r * h + p - h / 2, width: w, height: h))
                var piece = "\(item)"
                
                label.textColor = player(piece) == 0 ? boardColors.player1 : boardColors.player2
                
                if player(piece) == 1 {
                    
                    if let index = playerPieces[1].array().index(of: piece) { piece = playerPieces[0].array()[index] }
                    
                }
                
                label.text = piece
                label.textAlignment = .center
                label.font = .systemFont(ofSize: (w + h) / 2, weight: .thin)
                
                view.addSubview(label)

                
            }
            
        }
        
        return view
        
    }
    
    public func mancala(_ rect: CGRect) -> UIView {
        
        let view = MancalaView(frame: rect)
        
        let p = 15
        let w = (rect.width - p * 2) / 6
        let h = (rect.height - p * 2) / 6
        
        view.holeColor = boardColors.foreground
        view.backgroundColor = boardColors.background
        
        view.p = 15
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        
        for (r,row) in content.enumerated() {
            
            guard r > 3 || r < 2 else { continue }
            
            for (c,item) in row.enumerated() {
                
                let label = MancalaSpotView(frame: CGRect(x: c * w + p, y: r * h + p, width: w, height: h))
                
                label.stones = Int("\(item)") ?? 0
                label.textColor = boardColors.foreground
                label.textAlignment = .center
                label.font = .systemFont(ofSize: (w + h) / 4 - 10, weight: .heavy)
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
    public func matrix(_ rect: CGRect) -> UIView {
        
        let view = MatrixView(frame: rect)
        
        view.p = 15
        view.backgroundColor = boardColors.background
        view.lineColor = boardColors.foreground
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let p = 20
        let w = (rect.width - p * 2) / content.count
        let h = (rect.height - p * 2) / content.count
        
        for (c,col) in content.enumerated() {
            
            for (r,item) in col.enumerated() {
                
                let label = UILabel(frame: CGRect(x: c * w + p, y: r * h + p, width: w, height: h))
                
                label.text = "\(item)"
                label.textAlignment = .center
                label.font = .systemFont(ofSize: (w + h) / 2 - 10, weight: .thin)
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
    public func memory(_ rect: CGRect) -> UIView {
        
        let view = UIView(frame: rect)
        
        view.backgroundColor = boardColors.background
        
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
                label.textColor = player(piece) == 0 ? boardColors.player1 : piece.memoryColor
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
    public func mine(_ rect: CGRect) -> UIView {
        
        let view = UIView(frame: rect)
        
        view.backgroundColor = boardColors.background
        
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
                
                label.textColor = player(piece) == 0 ? boardColors.player1 : boardColors.player2
                label.backgroundColor = player(piece) == 1 ? boardColors.selected : boardColors.background
                
                if piece == "•" {
                    
                    label.textColor = boardColors.foreground
                    label.backgroundColor = boardColors.foreground
                
                }
                
                if let num = Int("\(item)"), num > 0 { label.textColor = boardColors.highlight }
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
    public func sudoku(_ rect: CGRect, highlights: [Square]) -> UIView {
        
        let view = SudokuView(frame: rect)
        
        view.backgroundColor = boardColors.background
        view.lineColor = boardColors.foreground
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let w = rect.width / content.count
        let h = rect.height / content.count
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {
                
                let label = UILabel(frame: CGRect(x: c * w, y: r * h, width: w, height: h))
                
                label.text = "\(item)"
                label.textAlignment = .center
                label.font = .systemFont(ofSize: (w + h) / 2 - 15, weight: .regular)
                label.textColor = boardColors.foreground
                
                for highlight in highlights {
                    
                    guard highlight.0 == r && highlight.1 == c else { continue }
                    label.textColor = boardColors.highlight
                    label.backgroundColor = boardColors.foreground
                    
                }
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
    public func ttt(_ rect: CGRect) -> UIView {
        
        let view = TicTacToeView(frame: rect)
        
        view.p = 20
        view.backgroundColor = boardColors.background
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let p = 20
        let w = (rect.width - p * 2) / content.count
        let h = (rect.height - p * 2) / content.count
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {
                
                let label = UILabel(frame: CGRect(x: c * w + p, y: r * h + p, width: w, height: h))
                let piece = "\(item)"
                
                label.text = piece
                label.textAlignment = .center
                label.font = .systemFont(ofSize: (w + h) / 2 - 10, weight: .thin)
                label.textColor = player(piece) == 0 ? boardColors.player1 : boardColors.player2
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
    public func words(_ rect: CGRect) -> UIView {
        
        let view = WordsView(frame: rect)
        
        view.p = 2
        view.backgroundColor = boardColors.background
        view.lineColor = boardColors.foreground
        
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        
        let p = 2
        let w = (rect.width - p * 2) / content.count
        let h = (rect.height - p * 2) / content.count
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {
                
                let label = UILabel(frame: CGRect(x: c * w + p, y: r * h + p, width: w, height: h).insetBy(dx: 1, dy: 1))
                let piece = Words.PieceType(rawValue: "\(item)")
                
                label.text = "\(item)"
                label.textAlignment = .center
                label.font = .systemFont(ofSize: (w + h) / ("\(item)".count > 1 ? 3 : 2) - 5, weight: .black)
                label.textColor = piece?.textColor ?? boardColors.player1
                label.backgroundColor = piece?.backgroundColor ?? boardColors.player2
                label.layer.cornerRadius = 4
                label.layer.masksToBounds = true
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
    public func onBoard(_ s1: Square, _ s2: Square) -> Bool {
        
        return s1.0.within(rowRange) && s1.1.within(colRange) && s2.0.within(rowRange) && s2.1.within(colRange)
        
    }
    
    public func onBoard(_ s1: Square) -> Bool {
        
        return s1.0.within(rowRange) && s1.1.within(colRange)
        
    }
    
    public subscript(c: Int, r: Int) -> Any {
        
        get { return content[c][r] }
        set { content[c][r] = newValue }
        
    }
    
    public subscript(c: Int) -> [Any] {
        
        get { return content[c] }
        set { content[c] = newValue }
        
    }
    
    func player(_ piece: Piece) -> Int {
        
        for (p,player) in playerPieces.enumerated() {
            
            if player.contains(piece) { return p }
            
        }
        
        return -1
        
    }
    
}

class HintLabel: UILabel {
    
    var highlight: Bool = false { didSet { setNeedsDisplay() } }
    var highlightColor: UIColor = .red
    
    override func drawText(in rect: CGRect) {
        
        guard highlight else { return super.drawText(in: rect) }
        
        let c = UIGraphicsGetCurrentContext()
        
        highlightColor.set()
        
        c?.setLineJoin(.round)
        c?.setLineWidth(1)
        c?.stroke(rect.insetBy(dx: 3, dy: 3))
        
        super.drawText(in: rect)
        
    }
    
}
