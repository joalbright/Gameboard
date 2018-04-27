import UIKit

public struct Doubles {
    
    public static var board: Grid { return Grid(4 ✕ (4 ✕ " ")) }
    
    public static let playerPieces = [""]

}

extension Grid {
    
    public func doubles(_ rect: CGRect) -> UIView {
        
        let view = CheckerView(frame: rect)
        
        view.backgroundColor = colors.background
        view.lineColor = colors.foreground
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let w = rect.width / content.count
        let h = rect.height / content.count
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {
                
                let label = UILabel(frame: CGRect(x: c * w, y: r * h, width: w, height: h))
                
                label.text = "\(item)"
                label.textAlignment = .center
                label.font = .systemFont(ofSize: (w + h) / 2 - 15, weight: .regular)
                label.textColor = colors.foreground
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
}
