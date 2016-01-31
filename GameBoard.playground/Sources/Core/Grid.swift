import UIKit

public class Grid {
    
    public var content: [[Any]]
    
    public var rowRange: Range<Int> { return 0..<content.count }
    public var colRange: Range<Int> { return 0..<content[0].count }
    
    public init(_ content: [[Any]]) {
        
        self.content = content
        
    }
    
    public func checker(rect: CGRect) -> UIView {
        
        let view = UIView(frame: rect)
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let w = rect.width / content.count
        let h = rect.height / content[0].count
        
        for (r,row) in content.enumerate() {
            
            for (c,item) in row.enumerate() {
                
                let label = UILabel(frame: CGRect(x: c * w, y: r * h, width: w, height: h))
                
                label.backgroundColor = (c + r) % 2 == 0 ? UIColor.whiteColor() : UIColor.blackColor()
                label.textColor = (c + r) % 2 == 0 ? UIColor.blackColor() : UIColor.whiteColor()
                
                label.text = "\(item)"
                label.textAlignment = .Center
                label.font = UIFont(name: "HelveticaNeue-Thin", size: (w + h) / 2 - 10)
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
    public func matrix(rect: CGRect) -> UIView {
        
        let view = MatrixView(frame: rect)
        
        view.p = 15
        view.backgroundColor = UIColor.whiteColor()
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let p = 20
        let w = (rect.width - p * 2) / content.count
        let h = (rect.height - p * 2) / content[0].count
        
        for (c,col) in content.enumerate() {
            
            for (r,item) in col.enumerate() {
                
                let label = UILabel(frame: CGRect(x: c * w + p, y: r * h + p, width: w, height: h))
                
                label.text = "\(item)"
                label.textAlignment = .Center
                label.font = UIFont(name: "HelveticaNeue-Thin", size: (w + h) / 2 - 10)
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
    public func onBoard(s1: Square, _ s2: Square) -> Bool {
        
        return s1.0.within(rowRange) && s1.1.within(colRange) && s2.0.within(rowRange) && s2.1.within(colRange)
        
    }
    
    public subscript ( c: Int, r: Int) -> Any {
        
        get { return content[c][r] }
        set { content[c][r] = newValue }
        
    }
    
    public subscript ( c: Int) -> [Any] {
        
        get { return content[c] }
        set { content[c] = newValue }
        
    }
    
}

extension Int {
    
    func within(r: Range<Int>) -> Bool {
        
        return self >= r.startIndex && self <= r.endIndex
        
    }
    
}
