import UIKit

public struct Words {
    
    public enum PieceType: String {
        
        static var all: [PieceType] { return [.start,.doubleword,.doubleletter,.tripleword,.tripleletter] }
        static var names: [String] { return all.map { $0.rawValue } }
        
        case empty = " "
        case start = "★"
        case doubleword = "DW"
        case tripleword = "TW"
        case doubleletter = "DL"
        case tripleletter = "TL"
        
        var backgroundColor: UIColor {
            
            switch self {
            case .empty: return .clear
            case .start: return #colorLiteral(red: 0.4582899487, green: 0.1780638536, blue: 0.4886863426, alpha: 1)
            case .doubleletter: return #colorLiteral(red: 0.0121835285, green: 0.524357516, blue: 0.8901960784, alpha: 1)
            case .tripleletter: return #colorLiteral(red: 0.1972305775, green: 0.7161869407, blue: 0.3783127069, alpha: 1)
            case .doubleword: return #colorLiteral(red: 0.8, green: 0, blue: 0.2666666667, alpha: 1)
            case .tripleword: return #colorLiteral(red: 0.968627451, green: 0.5960784314, blue: 0.2666666667, alpha: 1)
            }
            
        }
        
        var textColor: UIColor { return .white }
        
    }
    
    public enum Letter: String {
        
        static var all: [Letter] { return [.a,.b,.c,.d,.e,.f,.g,.h,.i,.j,.k,.l,.m,.n,.o,.p,.q,.r,.s,.t,.u,.v,.w,.x,.y,.z,.blank,.none] }
        
        static var bag: [Letter] {

            return all.reduce([]) { $0 + Array(repeating: $1, count: $1.count) }.randomize().randomize()

        }

        case a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z
        case blank = "_"
        case none = " "
        
        var count: Int {
            
            switch self {
            case .none: return 0
            case .j, .k, .q, .x, .z: return 1
            case .blank, .b, .c, .f, .m, .p, .v, .w, .y: return 2
            case .g: return 3
            case .h, .l, .u: return 4
            case .d, .n, .s: return 5
            case .r: return 6
            case .t: return 7
            case .i, .o: return 8
            case .a: return 9
            case .e: return 13
            }
            
        }
        
        var point: Int {
            
            switch self {
            case .blank, .none: return 0
            case .a, .e, .i, .o, .r, .s, .t: return 1
            case .d, .l, .n, .u: return 2
            case .g, .h, .y: return 3
            case .b, .c, .f, .m, .p, .w: return 4
            case .k, .v: return 5
            case .x: return 8
            case .j, .q, .z: return 10
            }
            
        }
        
    }
    
    public static var board: Grid {
        
        let grid = Grid([
        
            [" "," "," ","TW"," "," ","TL"," ","TL"," "," ","TW"," "," "," "],
            [" "," ","DL"," "," ","DW"," "," "," ","DW"," "," ","DL"," "," "],
            [" ","DL"," "," ","DL"," "," "," "," "," ","DL"," "," ","DL"," "],
            ["TW"," "," ","TL"," "," "," ","DW"," "," "," ","TL"," "," ","TW"],
            [" "," ","DL"," "," "," ","DL"," ","DL"," "," "," ","DL"," "," "],
            [" ","DW"," "," "," ","TL"," "," "," ","TL"," "," "," ","DW"," "],
            ["TL"," "," "," ","DL"," "," "," "," "," ","DL"," "," "," ","TL"],
            [" "," "," ","DW"," "," "," ","★"," "," "," ","DW"," "," "," "],
            ["TL"," "," "," ","DL"," "," "," "," "," ","DL"," "," "," ","TL"],
            [" ","DW"," "," "," ","TL"," "," "," ","TL"," "," "," ","DW"," "],
            [" "," ","DL"," "," "," ","DL"," ","DL"," "," "," ","DL"," "," "],
            ["TW"," "," ","TL"," "," "," ","DW"," "," "," ","TL"," "," ","TW"],
            [" ","DL"," "," ","DL"," "," "," "," "," ","DL"," "," ","DL"," "],
            [" "," ","DL"," "," ","DW"," "," "," ","DW"," "," ","DL"," "," "],
            [" "," "," ","TW"," "," ","TL"," ","TL"," "," ","TW"," "," "," "]
        
        ])
        
        
        return grid
        
    }
    
    public static let playerPieces = ["ABCDEFGHIJKLMNOPQRSTUVWXYZ_"]
    
    public static func validate(_ tile: Letter, _ s1: Square, _ grid: Grid) throws {
        
        guard PieceType(rawValue: grid[s1.0,s1.1]) != nil else { throw MoveError.invalidmove }
        
        grid[s1.0,s1.1] = tile.rawValue.uppercased()
        
    }

}

extension Grid {
    
    public func words(_ rect: CGRect) -> UIView {
        
        let view = WordsView(frame: rect)
        
        view.p = padding
        view.backgroundColor = colors.background
        view.lineColor = colors.foreground
        
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        
        let w = (rect.width - padding * 2) / content.count
        let h = (rect.height - padding * 2) / content.count
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {

                let piece = Words.PieceType(rawValue: "\(item)")

                let holder = UIView(frame: CGRect(x: c * w + padding, y: r * h + padding, width: w, height: h).insetBy(dx: 1, dy: 1))
                holder.backgroundColor = piece?.backgroundColor ?? colors.player2
                holder.layer.cornerRadius = 4
                holder.layer.masksToBounds = true

                let label = UILabel(frame: CGRect(x: 0, y: 0, width: w - 2, height: h - 2))
                label.text = "\(item)"
                label.textAlignment = .center
                label.font = .systemFont(ofSize: (w + h) / ("\(item)".count > 1 ? 3 : 2) - 5, weight: .black)
                label.textColor = piece?.textColor ?? colors.player1
                label.backgroundColor = .clear
                
                holder.addSubview(label)
                view.addSubview(holder)
                
            }
            
        }
        
        return view
        
    }
    
}
