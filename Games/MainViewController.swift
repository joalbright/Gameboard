//
//  MainViewController.swift
//  Games
//
//  Created by Jo Albright on 4/20/18.
//  Copyright © 2018 Jo Albright. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard UIDevice.current.userInterfaceIdiom == .pad, let vc = Gameboard.BoardType.playable.first?.controller else { return }
        
        splitViewController?.showDetailViewController(vc, sender: nil)
        tableView?.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
        
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Gameboard.BoardType.playable.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameCell else { fatalError() }
        
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        cell.selectedBackgroundView = view
        cell.game = Gameboard.BoardType.playable[indexPath.item]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let game = Gameboard.BoardType.playable[indexPath.item]
        
        guard let vc = game.controller else { return }
        
        splitViewController?.showDetailViewController(vc, sender: nil)
        
        guard UIDevice.current.userInterfaceIdiom != .pad else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

class GameCell: UITableViewCell {
    
    var game: Gameboard.BoardType! {
        
        didSet {
            
            emblem.text = game.emblem
            name.text = game.name
            
        }
        
    }
    
    @IBOutlet weak var emblem: UILabel!
    @IBOutlet weak var name: UILabel!
    
}

@IBDesignable class SimpleButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        
    }
    
}

@IBDesignable class SimpleView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        
    }
    
}
