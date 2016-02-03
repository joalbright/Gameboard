import UIKit

public typealias Square = (c: Int, r: Int)
public typealias ChessSquare = (c: String, r: Int)

public typealias Piece = String
public typealias Guess = String


public extension String {
    
    public func array() -> [String] {
        
        return self.characters.map { "\($0)" }
        
    }
    
}

public extension Int {
    
    public func within(r: Range<Int>) -> Bool {
        
        return self >= r.startIndex && self < r.endIndex
        
    }
    
}

public extension Array {
    
    public func randomize() -> [Element] {
    
        return self.sort { _,_ in arc4random() % 2 == 0 }
    
    }
    
}