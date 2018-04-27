import UIKit

public class SudokuView: UIView {
    
    var lineColor: UIColor = .black
    
    public override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineCap(.round)
        context?.setLineJoin(.round)
        
        lineColor.set()
        
        let w9 = rect.width / 9
        let h9 = rect.height / 9
        
        for row in 1...8 {
            
            for col in 1...8 {
                
                context?.setLineWidth(col % 3 == 0 ? 3 : 1)

                context?.move(to: CGPoint(x: w9 * col, y: 0))
                context?.addLine(to: CGPoint(x: w9 * col, y: rect.height))
                context?.strokePath()
                
                context?.setLineWidth(row % 3 == 0 ? 3 : 1)

                context?.move(to: CGPoint(x: 0, y: h9 * row))
                context?.addLine(to: CGPoint(x: rect.width, y: h9 * row))
                context?.strokePath()
                
            }
            
        }
        
    }
    
}
