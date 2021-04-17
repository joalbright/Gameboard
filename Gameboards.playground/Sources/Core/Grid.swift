import UIKit

public class Grid {

    struct Row: Identifiable {

        var id: Int
        var piece: String

    }

    struct Col: Identifiable {

        var id: Int
        var rows: [Row]
        
    }

    var cols: [Col] { return content.enumerated().map { Col(id: $0.offset, rows: $0.element.enumerated().map { Row(id: $0.offset, piece: $0.element as? String ?? "") }) } }
    
    public var content: [[Any]]
    
    public var rowRange: CountableRange<Int> { return 0..<content.count }
    public var colRange: CountableRange<Int> { return content.count > 0 ? 0..<content[0].count : 0..<0 }
    
    public var padding: CGFloat = 0
    public var colors = BoardColors()
    public var playerPieces: [Piece] = []
    
    public init(_ content: [[Any]], playerPieces: [Piece] = []) {
        
        self.content = content
        self.playerPieces = playerPieces
        
    }
    
    public subscript(c: Int, r: Int) -> Any {
        
        get { return content[c][r] }
        set { content[c][r] = newValue }
        
    }
    
    public subscript(c: Int) -> [Any] {
        
        get { return content[c] }
        set { content[c] = newValue }
        
    }

    public subscript(c: Int) -> Any {

        get { return content[c / colRange.endIndex][c % colRange.endIndex] }
        set { content[c / colRange.endIndex][c % colRange.endIndex] = newValue }

    }
    
    public func onBoard(_ s1: Square, _ s2: Square) -> Bool {
        
        return s1.0.within(rowRange) && s1.1.within(colRange) && s2.0.within(rowRange) && s2.1.within(colRange)
        
    }
    
    public func onBoard(_ s1: Square) -> Bool {
        
        return s1.0.within(rowRange) && s1.1.within(colRange)
        
    }
    
    func player(_ piece: Piece) -> Int {
        
        for (p,player) in playerPieces.enumerated() {
            
            if player.contains(piece) { return p }
            
        }
        
        return -1
        
    }

    func solid(_ piece: Piece) -> Piece {

        guard playerPieces.count > 1 else { return piece }
        guard let index = playerPieces[1].array().firstIndex(of: piece) else { return piece }
        return playerPieces[0].array()[index]

    }
    
}

class HintLabel: UILabel {
    
    var highlight: Bool = false { didSet { setNeedsDisplay() } }
    var highlightColor: UIColor = .systemRed
    
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
