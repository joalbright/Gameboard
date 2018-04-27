import UIKit

public class TicTacToeView: UIView {
    
    public var p: CGFloat = 10
    
    public override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineCap(.round)
        context?.setLineJoin(.round)
        context?.setLineWidth(2)
        
        let w = (rect.width - p * 2) / 3
        let h = (rect.height - p * 2) / 3
        
        context?.move(to: CGPoint(x: w + p, y: p))
        context?.addLine(to: CGPoint(x: w + p, y: rect.height - p))

        context?.move(to: CGPoint(x: w * 2 + p, y: p))
        context?.addLine(to: CGPoint(x: w * 2 + p, y: rect.height - p))

        context?.move(to: CGPoint(x: p, y: h + p))
        context?.addLine(to: CGPoint(x: rect.width - p, y: h + p))

        context?.move(to: CGPoint(x: p, y: h * 2 + p))
        context?.addLine(to: CGPoint(x: rect.width - p, y: h * 2 + p))

        context?.strokePath()
        
    }
    
}

