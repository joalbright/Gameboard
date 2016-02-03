import UIKit

public class Grid {
    
    public var content: [[AnyObject]]
    
    public var rowRange: Range<Int> { return 0..<content.count }
    public var colRange: Range<Int> { return 0..<content[0].count }
//    
//    public init(_ content: [[Any]]) {
//        
////        self.content = content
//        
//    }
    
    public init(_ content: [[AnyObject]]) {
        
        self.content = content
        
    }
    
    public func checker(rect: CGRect, highlights: [Square], selected: Square?) -> UIView {
        
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
                
                for highlight in highlights {
                    
                    guard highlight.0 == r && highlight.1 == c else { continue }
                    label.backgroundColor = UIColor.magentaColor()
                    
                }
                
                if let selected = selected where selected.0 == r && selected.1 == c {
                    
                    label.backgroundColor = UIColor.cyanColor()
                
                }
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
    public func ttt(rect: CGRect) -> UIView {
        
        let view = TicTacToeView(frame: rect)
        
        view.p = 20
        view.backgroundColor = UIColor.whiteColor()
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let p = 20
        let w = (rect.width - p * 2) / content.count
        let h = (rect.height - p * 2) / content[0].count
        
        for (r,row) in content.enumerate() {
            
            for (c,item) in row.enumerate() {
                
                let label = UILabel(frame: CGRect(x: c * w + p, y: r * h + p, width: w, height: h))
                
                label.text = "\(item)"
                label.textAlignment = .Center
                label.font = UIFont(name: "HelveticaNeue-Thin", size: (w + h) / 2 - 10)
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
    public func sudoku(rect: CGRect, highlights: [Square]) -> UIView {
        
        let view = SudokuView(frame: rect)
        
        view.backgroundColor = UIColor.whiteColor()
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let w = rect.width / content.count
        let h = rect.height / content[0].count
        
        for (r,row) in content.enumerate() {
            
            for (c,item) in row.enumerate() {
                
                let label = UILabel(frame: CGRect(x: c * w, y: r * h, width: w, height: h))
                
                label.text = "\(item)"
                label.textAlignment = .Center
                label.font = UIFont(name: "HelveticaNeue", size: (w + h) / 2 - 10)
                
                for highlight in highlights {
                    
                    guard highlight.0 == r && highlight.1 == c else { continue }
                    label.textColor = UIColor.whiteColor()
                    label.backgroundColor = UIColor.blackColor()
                    
                }
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
    public func mine(rect: CGRect) -> UIView {
        
        let view = UIView(frame: rect)
        
        view.backgroundColor = UIColor.whiteColor()
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let w = (rect.width - content.count + 1) / content.count
        let h = (rect.height - content[0].count + 1) / content[0].count
        
        for (r,row) in content.enumerate() {
            
            for (c,item) in row.enumerate() {
                
                let label = UILabel(frame: CGRect(x: c * w + c, y: r * h + r, width: w, height: h))
                
                label.text = "\(item)"
                label.textAlignment = .Center
                label.font = UIFont(name: "HelveticaNeue", size: (w + h) / 2 - 5)
                
                if "\(item)" == "•" {
                    
                    label.backgroundColor = UIColor.blackColor()
                    label.textColor = UIColor.blackColor()
                    
                }
                
                if let num = Int("\(item)") {
                    
                    label.textColor = UIColor(white: 1 - num * 0.3, alpha: 1)
                    
                }
                
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
    
    public func onBoard(s1: Square) -> Bool {
        
        return s1.0.within(rowRange) && s1.1.within(colRange)
        
    }
    
    public subscript ( c: Int, r: Int) -> AnyObject {
        
        get { return content[c][r] }
        set { content[c][r] = newValue }
        
    }
    
    public subscript ( c: Int) -> [AnyObject] {
        
        get { return content[c] }
        set { content[c] = newValue }
        
    }
    
}
