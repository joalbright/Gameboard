import UIKit

public func * (lhs: CGFloat, rhs: Int) -> CGFloat {
    
    return lhs * CGFloat(rhs)
    
}

public func * (lhs: Int, rhs: CGFloat) -> CGFloat {
    
    return CGFloat(lhs) * rhs
    
}

public func / (lhs: CGFloat, rhs: Int) -> CGFloat {
    
    return lhs / CGFloat(rhs)
    
}

public func / (lhs: Int, rhs: CGFloat) -> CGFloat {
    
    return CGFloat(lhs) / rhs
    
}

public func + (lhs: CGFloat, rhs: Int) -> CGFloat {
    
    return lhs + CGFloat(rhs)
    
}

public func + (lhs: Int, rhs: CGFloat) -> CGFloat {
    
    return CGFloat(lhs) + rhs
    
}

// MATRIX

infix operator ✕ { associativity left precedence 100 }

public func ✕ <T: AnyObject>(lhs: Int, rhs: Int -> T) -> [T] {
    
    var a: [T] = []
    
    for i in 0..<lhs { let r = rhs(i); a.append(r) }
    
    return a
    
}

public func ✕ <T: AnyObject>(lhs: Int, rhs: T) -> [T] {
    
    return [T](count: lhs, repeatedValue: rhs)
    
}

public func ✕ <T: AnyObject>(lhs: Int, rhs: [T]) -> [[T]] {
    
    return [[T]](count: lhs, repeatedValue: rhs)
    
}

public func ✕ <T: AnyObject>(lhs: Int, rhs: T.Type) -> [T?] {
    
    return [T?](count: lhs, repeatedValue: nil)
    
}

infix operator %% { associativity left precedence 150 }

public func %% <T: AnyObject>(lhs: T, rhs: T) -> Int -> AnyObject {
    
    return { $0 % 2 == 0 ? lhs : rhs }
    
}
