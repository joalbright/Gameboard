import UIKit

public struct Dots {

    public static var board: Grid { return Grid(17 ✕ (17 ✕ ("●" %% "0") %% 17 ✕ ("0" %% EmptyPiece))) }
    
//    public static var board: Grid { return Grid(8 ✕ (8 ✕ "00000")) }

    public static let playerPieces = ["1","2"]

    public static func validateMove(_ s1: Square, _ p1: Piece, _ grid: Grid, _ player: Int) throws {

        guard p1 == "0" else { throw MoveError.invalidmove }

        grid[s1.0,s1.1] = playerPieces[player]

        checkSpaces(s1, grid, player: player)

    }

    public static func checkSpaces(_ s1: Square, _ grid: Grid, player: Int) {

        let adjacent2 = [ (-1,0),(0,1),(1,0),(0,-1) ]

        for a in adjacent2 {

            let s = (s1.0 + a.0, s1.1 + a.1)
            guard grid.onBoard(s) else { continue }
            guard grid[s.0,s.1] == EmptyPiece, checkClosed(s, grid) else { continue }

            grid[s.0,s.1] = playerPieces[player]

        }

    }

    public static func checkClosed(_ s1: Square, _ grid: Grid) -> Bool {

        var count = 0

        let adjacent2 = [ (-1,0),(0,1),(1,0),(0,-1) ]

        for a in adjacent2 {

            let s = (s1.0 + a.0, s1.1 + a.1)
            guard grid.onBoard(s) else { continue }
            if grid[s.0,s.1] != "0" { count += 1 }

        }

        return count == 4

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
        
        let w = rect.width / 17
        let h = rect.height / 17

        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {

                let player = "\(item)"

                guard ["1","2"].contains(player) else { continue }

                if (r + c) % 2 == 0 {

                    /// Space

                    let dotView = DotsSquareView(frame: CGRect(x: c * w - padding / 2, y: r * h - padding / 2, width: w, height: h).insetBy(dx: -5, dy: -5))

                    dotView.backgroundColor = .clear
                    dotView.playerColor = player == "1" ? colors.player1 : colors.player2

                    view.addSubview(dotView)

                } else {

                    /// Line

//                    let (dx,dy) = sp[s]
//
//                    let width = dx == 0 ? w + 14 : 14
//                    let height = dy == 0 ? h + 14 : 14
//                    let x = c * w + padding + w / 2 + (dx * w / 2)
//                    let y = r * h + padding + w / 2 + (dy * h / 2)
//
//                    let lineView = DotsLineView(frame: CGRect(x: 0, y: 0, width: width, height: height))
//
//                    lineView.backgroundColor = .clear
//                    lineView.center = CGPoint(x: x, y: y)
//                    lineView.playerColor = side == "1" ? colors.player1 : colors.player2
//                    lineView.lineColor = colors.foreground
//
//                    view.addSubview(lineView)

                }

            }
            
        }
        
        return view
        
    }
    
}
