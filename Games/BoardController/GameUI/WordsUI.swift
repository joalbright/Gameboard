//
//  WordsUI.swift
//  Games
//
//  Created by Jo Albright on 4/15/21.
//  Copyright © 2021 Jo Albright. All rights reserved.
//

import SwiftUI

struct WordsBoardUI: View {

    var body: some View {

        GeometryReader { g in

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct WordsPiecesUI: View {

    var grid: Grid

    var body: some View {

        GeometryReader { g in

//            extension Grid {
//
//                public func words(_ rect: CGRect) -> UIView {
//
//                    let view = WordsView(frame: rect)
//
//                    view.p = padding
//                    view.backgroundColor = colors.background
//                    view.lineColor = colors.foreground
//
//                    view.layer.cornerRadius = 6
//                    view.layer.masksToBounds = true
//
//                    let w = (rect.width - padding * 2) / content.count
//                    let h = (rect.height - padding * 2) / content.count
//
//                    for (r,row) in content.enumerated() {
//
//                        for (c,item) in row.enumerated() {
//
//                            let label = UILabel(frame: CGRect(x: c * w + padding, y: r * h + padding, width: w, height: h).insetBy(dx: 1, dy: 1))
//                            let piece = Words.PieceType(rawValue: "\(item)")
//
//                            label.text = "\(item)"
//                            label.textAlignment = .center
//                            label.font = .systemFont(ofSize: (w + h) / ("\(item)".count > 1 ? 3 : 2) - 5, weight: .black)
//                            label.textColor = piece?.textColor ?? colors.player1
//                            label.backgroundColor = piece?.backgroundColor ?? colors.player2
//                            label.layer.cornerRadius = 4
//                            label.layer.masksToBounds = true
//
//                            view.addSubview(label)
//
//                        }
//
//                    }
//
//                    return view
//
//                }
//
//            }

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct WordsLayoutUI: View {

    var grid: Grid

    var body: some View {

        ZStack {

            Color("Background").edgesIgnoringSafeArea(.bottom)

            VStack {

                ZStack {

                    WordsBoardUI()

                    WordsPiecesUI(grid: grid)

                }
                .padding(32)

            }

        }
        .navigationTitle("Words")

    }

}

struct WordsUI_Previews: PreviewProvider {

    static var previews: some View {

        NavigationView {

            WordsLayoutUI(grid: Grid([], playerPieces: ["◉","◎"]))

        }
        .preferredColorScheme(.dark)

    }

}

//class WordsView: UIView {
//
//    public var p: CGFloat = 2
//    var lineColor: UIColor = .black
//
//    public override func draw(_ rect: CGRect) {
//
//        let context = UIGraphicsGetCurrentContext()
//
//        context?.setLineCap(.round)
//        context?.setLineJoin(.round)
//        context?.setLineWidth(1)
//
//        lineColor.set()
//
//        let w = (rect.width - p * 2) / 15
//        let h = (rect.height - p * 2) / 15
//
//        for r in 0..<15 {
//
//            for c in 0..<15 {
//
//                context?.addPath(UIBezierPath(roundedRect: CGRect(x: w * c + p, y: h * r + p, width: w, height: h).insetBy(dx: 1, dy: 1), cornerRadius: 4).cgPath)
//                context?.fillPath()
//
//            }
//
//        }
//
//    }
//
//}
//
//class TileView: UIView {
//
//    var color: UIColor = .lightGray { didSet { setNeedsDisplay() } }
//    var selectedColor: UIColor = .lightGray
//
//    var letterLabel: UILabel!
//    var valueLabel: UILabel!
//
//    var tile: Words.Letter = .none {
//
//        didSet {
//
//            letterLabel?.removeFromSuperview()
//            valueLabel?.removeFromSuperview()
//
//            guard tile != .none else { return }
//
//            letterLabel = UILabel()
//            letterLabel.text = tile == .blank ? "" : tile.rawValue.uppercased()
//            letterLabel.textAlignment = .center
//            letterLabel.font = .systemFont(ofSize: 18, weight: .heavy)
//            addSubview(letterLabel)
//
//            valueLabel = UILabel()
//            valueLabel.text = tile.point == 0 ? "" : "\(tile.point)"
//            valueLabel.textAlignment = .right
//            valueLabel.font = .systemFont(ofSize: 10, weight: .heavy)
//            addSubview(valueLabel)
//
//        }
//
//    }
//
//    var selected: (Words.Letter) -> Void = { _ in }
//
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//
//        letterLabel?.frame = rect
//        valueLabel?.frame = CGRect(x: 0, y: 4, width: frame.width - 4, height: 10)
//
//        let context = UIGraphicsGetCurrentContext()
//
//        context?.clear(rect)
//
//        guard tile != .none else { return }
//
//        color.set()
//
//        context?.addPath(UIBezierPath(roundedRect: rect.insetBy(dx: 1, dy: 1), cornerRadius: 6).cgPath)
//        context?.fillPath()
//
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        guard tile != .none else { return }
//
//        selected(tile)
//        color = selectedColor
//
//    }
//
//}


//(boardView as? WordsBoardView)?.rackUpdated = { rack in
//
//    for view in self.rackHolder.arrangedSubviews { self.rackHolder.removeArrangedSubview(view) }
//
//    for tile in rack {
//
//        let tileView = TileView()
//        tileView.tile = tile
//        tileView.color = self.boardView.player2Color
//        tileView.selectedColor = self.boardView.selectedColor
//        tileView.backgroundColor = .clear
//        tileView.letterLabel?.textColor = self.boardView.player1Color
//        tileView.valueLabel?.textColor = self.boardView.highlightColor
//        tileView.selected = { tile in
//
//            (self.boardView as? WordsBoardView)?.selectedTile = tile
//            for view in self.rackHolder.arrangedSubviews {
//                guard let tileView = view as? TileView else { continue }
//                tileView.color = self.boardView.player2Color
//            }
//
//        }
//
//        self.rackHolder.addArrangedSubview(tileView)
//
//    }
//
//}
//
//(boardView as? WordsBoardView)?.fillRack()

//@IBAction func fillRack() {
//
//    rack = rack.filter { $0 != .none }
//
//    let tiles = 7 - rack.count
//
//    print(rack.count,tiles,bag.count)
//
//    rack += bag.prefix(tiles)
//    bag.removeFirst(tiles)
//
//    print(rack.count,bag.count)
//
//}
