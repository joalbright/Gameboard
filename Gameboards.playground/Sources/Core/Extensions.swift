import UIKit

public typealias Square = (c: Int, r: Int)
public typealias ChessSquare = (c: String, r: Int)

public typealias Piece = String
public typealias Guess = String
public typealias Card = String


extension String {
    
    public func array() -> [String] {
        
        return map { "\($0)" }
        
    }
    
    public func randomize() -> [String] {
        
        return array().sorted { _,_ in arc4random() % 2 == 0 }
        
    }
    
}

extension Int {
    
    public func within(_ r: CountableRange<Int>) -> Bool {
        
        return self >= r.lowerBound && self < r.upperBound
        
    }

    public func set(_ advanced: Int, _ count: Int) -> [Int] {

        var set: [Int] = []

        for i in 0..<count { set += [advanced * i + self] }

        return set

    }

}

extension Array {
    
    public func randomize() -> [Element] {
    
        return sorted { _,_ in arc4random() % 2 == 0 }
    
    }
    
    static func *(lhs: [Element], rhs: Int) -> [Element] {
        
        var multipliedArray = lhs
        for _ in 1..<rhs { multipliedArray += lhs }
        return multipliedArray
        
    }
    
}
