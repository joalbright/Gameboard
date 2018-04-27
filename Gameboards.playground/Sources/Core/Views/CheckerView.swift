import UIKit

public class CheckerView: UIView {
    
    public var p: CGFloat = 10
    
    var lineColor: UIColor = .black
    
    public override func draw(_ rect: CGRect) {
        
        let c = UIGraphicsGetCurrentContext()
        
        c?.setLineCap(.round)
        c?.setLineJoin(.round)
        c?.setLineWidth(2)
        
        lineColor.set()
        
        c?.move(to: CGPoint(x: p * 2, y: p))
        c?.addLine(to: CGPoint(x: p, y: p))
        c?.addLine(to: CGPoint(x: p, y: rect.height - p))
        c?.addLine(to: CGPoint(x: p * 2, y: rect.height - p))
        
        c?.move(to: CGPoint(x: rect.width - p * 2, y: p))
        c?.addLine(to: CGPoint(x: rect.width - p, y: p))
        c?.addLine(to: CGPoint(x: rect.width - p, y: rect.height - p))
        c?.addLine(to: CGPoint(x: rect.width - p * 2, y: rect.height - p))
        
        c?.strokePath()
        
    }
    
}
