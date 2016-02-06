import UIKit

class HintLabel: UILabel {
    
    var highlight: Bool = false { didSet { setNeedsDisplay() } }
    var highlightColor: UIColor = UIColor.redColor()
    
    override func drawTextInRect(rect: CGRect) {
        
        guard highlight else { return super.drawTextInRect(rect) }
        
        let ctx = UIGraphicsGetCurrentContext()
        
        highlightColor.set()
        
        CGContextSetLineJoin(ctx, .Round)
        CGContextSetLineWidth(ctx, 1)
        
        CGContextStrokeRect(ctx, CGRectInset(rect, 3, 3))
        
        super.drawTextInRect(rect)
        
    }
    
}

