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

public func - (lhs: CGFloat, rhs: Int) -> CGFloat {
    
    return lhs - CGFloat(rhs)
    
}

public func - (lhs: Int, rhs: CGFloat) -> CGFloat {
    
    return CGFloat(lhs) - rhs
    
}

// MATRIX

infix operator ✕: AdditionPrecedence

public func ✕ <T: Any>(lhs: Int, rhs: (Int) -> T) -> [T] {
    
    var a: [T] = []
    
    for i in 0..<lhs { let r = rhs(i); a.append(r) }
    
    return a
    
}

public func ✕ <T: Any>(lhs: Int, rhs: T) -> [T] {
    
    return [T](repeating: rhs, count: lhs)
    
}

public func ✕ <T: Any>(lhs: Int, rhs: [T]) -> [[T]] {
    
    return [[T]](repeating: rhs, count: lhs)
    
}

public func ✕ <T: Any>(lhs: Int, rhs: T.Type) -> [T?] {
    
    return [T?](repeating: nil, count: lhs)
    
}

infix operator %% : AssignmentPrecedence

public func %% <T: Any>(lhs: T, rhs: T) -> (Int) -> Any {
    
    return { $0 % 2 == 0 ? lhs : rhs }
    
}
