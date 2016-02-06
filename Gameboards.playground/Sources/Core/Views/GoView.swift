import UIKit

public class GoView: UIView {
    
    public var p: CGFloat = 20
    public var lineColor = UIColor.blackColor()
    
    public override func drawRect(rect: CGRect) {
        
        let c = UIGraphicsGetCurrentContext()
        
        CGContextSetLineCap(c, .Round)
        CGContextSetLineJoin(c, .Round)
        
        lineColor.set()
        
        let w8 = (rect.width - p * 2) / 8
        let h8 = (rect.height - p * 2) / 8
        
        for row in 0...8 {
            
            for col in 0...8 {
                
                CGContextMoveToPoint(c, w8 * col + p, p)
                CGContextAddLineToPoint(c, w8 * col + p, rect.height - p)
                
                CGContextMoveToPoint(c, p, h8 * row + p)
                CGContextAddLineToPoint(c, rect.width - p, h8 * row + p)
                
            }
            
        }
        
        CGContextStrokePath(c)
        
    }
    
}