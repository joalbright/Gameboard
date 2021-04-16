//
//  WordsBoardView.swift
//  Games
//
//  Created by Jo Albright on 4/23/18.
//  Copyright © 2018 Jo Albright. All rights reserved.
//

import UIKit

@IBDesignable class WordsBoardView : BoardView {
    
    var selectedTile: Words.Letter?
    
    var bag: [Words.Letter] = []
    var rack: [Words.Letter] = [] { didSet { rackUpdated(rack) } }
    
    var rackUpdated: ([Words.Letter]) -> Void = { _ in }
    
    override func prepareForInterfaceBuilder() {
        
        board = Gameboard(.words)
        bag = Words.Letter.bag
        super.prepareForInterfaceBuilder()
        
    }
    
    override func awakeFromNib() {
        
        board = Gameboard(.words)
        bag = Words.Letter.bag
        super.awakeFromNib()
        
    }
    
    override func selectSquare(_ square: Square) {
        
        guard let tile = selectedTile else { return }
        
        do {

            try board.place(tile: tile, at: square)
            
            if let index = rack.firstIndex(of: tile) {
                
                rack.remove(at: index)
                rack.append(.none)
                selectedTile = nil
                
            }

        } catch {

            print(error)

        }
        
        updateBoard()
        
    }
    
    func reset() {
        
        bag = Words.Letter.bag
        rack = []
        fillRack()
        
    }
    
    @IBAction func fillRack() {
        
        rack = rack.filter { $0 != .none }
        
        let tiles = 7 - rack.count
        
        print(rack.count,tiles,bag.count)
        
        rack += bag.prefix(tiles)
        bag.removeFirst(tiles)
        
        print(rack.count,bag.count)
        
    }
    
}

class WordsBoardViewController: BoardViewController {
    
    @IBOutlet var rackHolder: UIStackView!
    
    var selected: Words.Letter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (boardView as? WordsBoardView)?.rackUpdated = { rack in
            
            for view in self.rackHolder.arrangedSubviews { self.rackHolder.removeArrangedSubview(view) }
            
            for tile in rack {
                
                let tileView = TileView()
                tileView.tile = tile
                tileView.color = self.boardView.player2Color
                tileView.selectedColor = self.boardView.selectedColor
                tileView.backgroundColor = .clear
                tileView.letterLabel?.textColor = self.boardView.player1Color
                tileView.valueLabel?.textColor = self.boardView.highlightColor
                tileView.selected = { tile in
                    
                    (self.boardView as? WordsBoardView)?.selectedTile = tile
                    for view in self.rackHolder.arrangedSubviews {
                        guard let tileView = view as? TileView else { continue }
                        tileView.color = self.boardView.player2Color
                    }
                    
                }
                
                self.rackHolder.addArrangedSubview(tileView)
                
            }
            
        }
        
        (boardView as? WordsBoardView)?.fillRack()
        
    }
    
    @IBAction override func resetBoard(sender: Any) {
        super.resetBoard(sender: sender)
        
        (boardView as? WordsBoardView)?.reset()
        
    }
    
}
