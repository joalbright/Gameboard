import UIKit

public struct Backgammon {
    
    public static var board: Grid {
        
        return Grid([
        
            "●   ○ ○    ●".array(),
            "●   ○ ○    ●".array(),
            "●   ○ ○     ".array(),
            "●     ○     ".array(),
            "●     ○     ".array(),
            "○     ●     ".array(),
            "○     ●     ".array(),
            "○   ● ●     ".array(),
            "○   ● ●    ○".array(),
            "○   ● ●    ○".array()
            
        ])
                
    }
    
    public static let playerPieces = ["●","○"]
    
}

extension Grid {
    
    public func backgammon(_ rect: CGRect) -> UIView {
        
        let view = BackgammonView(frame: rect)
        
        let w = (rect.width - 50.0) / 12
        let h = (rect.height - 110.0) / 10

        view.backgroundColor = colors.background
        view.backgroundColor2 = colors.foreground

        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true

        for (r,row) in content.enumerated() {

            for (c,item) in row.enumerated() {

                let y = r > 4 ? 95 : 15
                let x = c > 5 ? 35 : 15

                let label = UILabel(frame: CGRect(x: c * w + x, y: r * h + y, width: w, height: h))
                var piece = "\(item)"

                label.textColor = player(piece) == 0 ? colors.player1 : colors.player2

                if player(piece) == 1 {

                    if let index = playerPieces[1].array().index(of: piece) { piece = playerPieces[0].array()[index] }

                }

                label.text = piece
                label.textAlignment = .center
                label.font = .systemFont(ofSize: (w + h) / 2, weight: .regular)

                view.addSubview(label)

            }

        }
        
        return view
        
    }
    
}
