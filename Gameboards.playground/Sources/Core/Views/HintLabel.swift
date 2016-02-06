import UIKit

class HintLabel: UILabel {
    
    var highlight: Bool = false { didSet { setNeedsDisplay() } }
    
    override func drawTextInRect(rect: CGRect) {
        
        guard highlight else { return super.drawTextInRect(rect) }
        
        let ctx = UIGraphicsGetCurrentContext()
        
        UIColor.redColor().set()
        
        CGContextSetLineJoin(ctx, .Round)
        CGContextSetLineWidth(ctx, 1)
        
        CGContextStrokeRect(ctx, CGRectInset(rect, 3, 3))
        
        super.drawTextInRect(rect)
        
    }
    
}

