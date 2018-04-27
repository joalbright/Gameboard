import UIKit

public struct Mancala {
    
    public static var board: Grid {
        
        return Grid([
            
            "333333".array(),
            "333333".array(),
            "000000".array(),
            "000000".array(),
            "333333".array(),
            "333333".array()
            
        ])
        
    }
    
    public static let playerPieces = ["123456789","123456789"]
    
    public static var staticboard: Grid {
        
        return Grid([
            
            "341433".array(),
            "345033".array(),
            "000000".array(),
            "000001".array(),
            "333444".array(),
            "330404".array()
            
        ])
        
    }

}

extension Grid {
    
    public func mancala(_ rect: CGRect) -> UIView {
        
        let view = MancalaView(frame: rect)
        
        let w = (rect.width - padding * 2) / 6
        let h = (rect.height - padding * 2) / 6
        
        view.holeColor = colors.foreground
        view.backgroundColor = colors.background
        
        view.p = padding
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        
        for (r,row) in content.enumerated() {
            
            guard r > 3 || r < 2 else { continue }
            
            for (c,item) in row.enumerated() {
                
                let label = MancalaSpotView(frame: CGRect(x: c * w + padding, y: r * h + padding, width: w, height: h))
                
                label.stones = Int("\(item)") ?? 0
                label.textColor = colors.foreground
                label.textAlignment = .center
                label.font = .systemFont(ofSize: (w + h) / 4 - 10, weight: .heavy)
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
}
