import UIKit

public class GoView: UIView {
    
    public var p: CGFloat = 20
    public var lineColor: UIColor = .black
    
    public override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineCap(.round)
        context?.setLineJoin(.round)
        
        lineColor.set()
        
        let w = (rect.width - p * 2) / 8
        let h = (rect.height - p * 2) / 8
        
        for r in 0...8 {
            
            for c in 0...8 {
                
                context?.move(to: CGPoint(x: w * c + p, y: p))
                context?.addLine(to: CGPoint(x: w * c + p, y: rect.height - p))

                context?.move(to: CGPoint(x: p, y: h * r + p))
                context?.addLine(to: CGPoint(x: rect.width - p, y: h * r + p))
                
            }
            
        }
        
        context?.strokePath()
        
    }
    
}
