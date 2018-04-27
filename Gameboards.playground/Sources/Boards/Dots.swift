import UIKit

public struct Dots {
    
    public static var board: Grid { return Grid(8 ✕ (8 ✕ "00000")) }
    
    public static let playerPieces = ["1","2"]
    
    public static var staticboard: Grid {
        
        let grid = Grid(8 ✕ (8 ✕ "00000"))
        
        grid[1][1] = "00100"
        grid[1][2] = "10010"
        grid[2][2] = "21122"
        grid[2][3] = "12121"
        grid[3][3] = "22112"
        grid[3][4] = "10000"
        
        return grid
        
    }

}

extension Grid {
    
    public func dots(_ rect: CGRect) -> UIView {
        
        let view = DotsView(frame: rect)
        
        view.p = padding
        view.backgroundColor = colors.background
        view.lineColor = colors.foreground
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let w = (rect.width - padding * 2) / 8
        let h = (rect.height - padding * 2) / 8
        
        let sp: [(CGFloat,CGFloat)] = [(-1,0),(0,-1),(1,0),(0,1)]
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {
                
                var sides = "\(item)".array()
                let owner = sides.removeLast()
                
                for (s,side) in sides.enumerated() {
                    
                    guard side != "0" else { continue }
                    
                    let (dx,dy) = sp[s]
                    
                    let width = dx == 0 ? w + 14 : 14
                    let height = dy == 0 ? h + 14 : 14
                    let x = c * w + padding + w / 2 + (dx * w / 2)
                    let y = r * h + padding + w / 2 + (dy * h / 2)
                    
                    let lineView = DotsLineView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                    
                    lineView.backgroundColor = .clear
                    lineView.center = CGPoint(x: x, y: y)
                    lineView.playerColor = side == "1" ? colors.player1 : colors.player2
                    lineView.lineColor = colors.foreground
                    
                    view.addSubview(lineView)
                    
                }
                
                guard owner != "0" else { continue }
                
                let dotView = DotsSquareView(frame: CGRect(x: c * w + padding, y: r * h + padding, width: w, height: h).insetBy(dx: 5, dy: 5))
                
                dotView.backgroundColor = .clear
                dotView.playerColor = owner == "1" ? colors.player1 : colors.player2
                
                view.addSubview(dotView)
                
            }
            
        }
        
        return view
        
    }
    
}
