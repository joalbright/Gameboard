import UIKit

public class SudokuView: UIView {
    
    public override func drawRect(rect: CGRect) {
        
        let c = UIGraphicsGetCurrentContext()
        
        CGContextSetLineCap(c, .Round)
        CGContextSetLineJoin(c, .Round)
        
        let w9 = rect.width / 9
        let h9 = rect.height / 9
        
        for row in 1...8 {
            
            for col in 1...8 {
                
                CGContextSetLineWidth(c, col % 3 == 0 ? 3 : 1)
                
                CGContextMoveToPoint(c, w9 * col, 0)
                CGContextAddLineToPoint(c, w9 * col, rect.height)
                
                CGContextStrokePath(c)
                
                CGContextSetLineWidth(c, row % 3 == 0 ? 3 : 1)
                
                CGContextMoveToPoint(c, 0, h9 * row)
                CGContextAddLineToPoint(c, rect.width, h9 * row)
                
                CGContextStrokePath(c)
                
            }
            
        }
        
    }
    
}