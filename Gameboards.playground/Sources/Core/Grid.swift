import UIKit

public class Grid {
    
    public var content: [[Any]]
    
    public var rowRange: CountableRange<Int> { return 0..<content.count }
    public var colRange: CountableRange<Int> { return content.count > 0 ? 0..<content[0].count : 0..<0 }
    
    public var padding: CGFloat = 0
    public var colors = BoardColors()
    public var playerPieces: [Piece] = []
    
    public init(_ content: [[Any]]) {
        
        self.content = content
        
    }
    
    public subscript(c: Int, r: Int) -> Any {
        
        get { return content[c][r] }
        set { content[c][r] = newValue }
        
    }
    
    public subscript(c: Int) -> [Any] {
        
        get { return content[c] }
        set { content[c] = newValue }
        
    }
    
    public func matrix(_ rect: CGRect) -> UIView {
        
        let view = MatrixView(frame: rect)
        
        view.p = padding
        view.backgroundColor = colors.background
        view.lineColor = colors.foreground
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let w = (rect.width - padding * 2) / content.count
        let h = (rect.height - padding * 2) / content.count
        
        for (c,col) in content.enumerated() {
            
            for (r,item) in col.enumerated() {
                
                let label = UILabel(frame: CGRect(x: c * w + padding, y: r * h + padding, width: w, height: h))
                
                label.text = "\(item)"
                label.textAlignment = .center
                label.font = .systemFont(ofSize: (w + h) / 2 - 10, weight: .thin)
                
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
