//
//  ViewController.swift
//  Games
//
//  Created by Jo Albright on 2/3/16.
//  Copyright © 2016 Jo Albright. All rights reserved.
//

import UIKit

enum Direction: UInt {
    
    case right = 1
    case left = 2
    case down = 8
    case up = 4
    
    var name: String {
        
        switch self {
        case .down: return "Down"
        case .up: return "Up"
        case .left: return "Left"
        case .right: return "Right"
        }
        
    }
    
}

class BoardViewController: UIViewController {
    
    @IBOutlet weak var boardView: BoardView!
    @IBOutlet weak var playerLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        boardView?.board?.playerChange = { p in self.playerLabel?.text = "Player \(p)" }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        guard let square = boardView?.coordinate(touch) else { return }
        
        boardView?.selectSquare(square)
        
    }
    
    @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
    
        guard let direction = Direction(rawValue: sender.direction.rawValue) else { return }

        boardView?.swipe(direction)
    
    }
    
//    @IBAction func chooseDifficulty(sender: UISegmentedControl) {
//
//        boardView?.board?.difficulty = Difficulty(sender.selectedSegmentIndex)
//        boardView?.updateBoard()
//
//    }
    
    @IBAction func resetBoard(sender: Any) {
        
        boardView?.board?.reset()
        boardView?.updateBoard()
        
    }
    
}

@IBDesignable class GradientView: UIView {
    
    @IBInspectable var startColor: UIColor = .white
    @IBInspectable var endColor: UIColor = .black
    
    override func draw(_ rect: CGRect) {
        
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x: 1, y: 1)
        
        let context = UIGraphicsGetCurrentContext()
        
        
        let colors: CFArray = [startColor.cgColor,endColor.cgColor] as CFArray
        
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: [0, 1]) else { return }
        
        let s = CGPoint(x: frame.width * startPoint.x, y: frame.height * startPoint.y)
        let e = CGPoint(x: frame.width * endPoint.x, y: frame.height * endPoint.y)
        
        context?.drawLinearGradient(gradient, start: s, end: e, options: .drawsAfterEndLocation)
        
    }
    
}

@IBDesignable class BoardView : UIView {
    
    var board: Gameboard!
    var boardView: UIView?
    
    @IBInspectable var padding: CGFloat = 0
    
    @IBInspectable var bgColor: UIColor = .white
    @IBInspectable var fgColor: UIColor = .black
    
    @IBInspectable var player1Color: UIColor = .red
    @IBInspectable var player2Color: UIColor = .blue
    
    @IBInspectable var selectedColor: UIColor = .white
    @IBInspectable var highlightColor: UIColor = .white
    
    override func prepareForInterfaceBuilder() { updateBoard() }
    override func didMoveToWindow() { updateBoard() }
    override func layoutSubviews() { updateBoard() }
    
    func updateBoard() {
        
        board?.padding = padding
        board?.colors.background = bgColor
        board?.colors.foreground = fgColor
        board?.colors.player1 = player1Color
        board?.colors.player2 = player2Color
        board?.colors.selected = selectedColor
        board?.colors.highlight = highlightColor
        
        boardView?.removeFromSuperview()
        boardView = board?.visualize(bounds)
        guard let boardView = boardView else { return }
        addSubview(boardView)
        
    }
    
    func coordinate(_ touch: UITouch) -> Square? {
        
        guard let board = board else { return nil }
        
        let w = (frame.width - board.padding * 2) / board.gridSize
        let h = (frame.height - board.padding * 2) / board.gridSize
        
        let loc = touch.location(in: self)
        
        let c = Int((loc.x - board.padding) / w)
        let r = Int((loc.y - board.padding) / h)
        
        return (r,c)
        
    }
    
    func selectSquare(_ square: Square) { }
    func swipe(_ direction: Direction) { }
    
}
