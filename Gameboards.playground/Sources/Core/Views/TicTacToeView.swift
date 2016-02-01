import UIKit

public class TicTacToeView: UIView {
    
    public var p: CGFloat = 10
    
    public override func drawRect(rect: CGRect) {
        
        let c = UIGraphicsGetCurrentContext()
        
        CGContextSetLineCap(c, .Round)
        CGContextSetLineJoin(c, .Round)
        CGContextSetLineWidth(c, 2)
        
        let w3 = (rect.width - p * 2) / 3
        let h3 = (rect.height - p * 2) / 3
        
        CGContextMoveToPoint(c, w3 + p, p)
        CGContextAddLineToPoint(c, w3 + p, rect.height - p)
        
        CGContextMoveToPoint(c, w3 * 2 + p, p)
        CGContextAddLineToPoint(c, w3 * 2 + p, rect.height - p)
        
        CGContextMoveToPoint(c, p, h3 + p)
        CGContextAddLineToPoint(c, rect.width - p, h3 + p)
        
        CGContextMoveToPoint(c, p, h3 * 2 + p)
        CGContextAddLineToPoint(c, rect.width - p, h3 * 2 + p)
        
        CGContextStrokePath(c)
        
    }
    
}

