import UIKit

public class TicTacToeView: UIView {
    
    public var p: CGFloat = 10
    
    public override func draw(_ rect: CGRect) {
        
        let c = UIGraphicsGetCurrentContext()
        
        c?.setLineCap(.round)
        c?.setLineJoin(.round)
        c?.setLineWidth(2)
        
        let w3 = (rect.width - p * 2) / 3
        let h3 = (rect.height - p * 2) / 3
        
        c?.move(to: CGPoint(x: w3 + p, y: p))
        c?.addLine(to: CGPoint(x: w3 + p, y: rect.height - p))

        c?.move(to: CGPoint(x: w3 * 2 + p, y: p))
        c?.addLine(to: CGPoint(x: w3 * 2 + p, y: rect.height - p))

        c?.move(to: CGPoint(x: p, y: h3 + p))
        c?.addLine(to: CGPoint(x: rect.width - p, y: h3 + p))

        c?.move(to: CGPoint(x: p, y: h3 * 2 + p))
        c?.addLine(to: CGPoint(x: rect.width - p, y: h3 * 2 + p))

        c?.strokePath()
        
    }
    
}

