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

public func ✕ (lhs: Int, rhs: (Int) -> String) -> [String] {
    
    var a: [String] = []
    
    for i in 0..<lhs { let r = rhs(i); a.append(r) }
    
    return a
    
}

public func ✕ (lhs: Int, rhs: (Int) -> [String]) -> [[String]] {

    var a: [[String]] = []

    for i in 0..<lhs { let r = rhs(i); a.append(r) }

    return a

}

public func ✕ (lhs: Int, rhs: String) -> [String] {
    
    return [String](repeating: rhs, count: lhs)
    
}

public func ✕ (lhs: Int, rhs: [String]) -> [[String]] {
    
    return [[String]](repeating: rhs, count: lhs)
    
}

infix operator %% : AssignmentPrecedence

public func %% (lhs: String, rhs: String) -> (Int) -> String {
    
    return { $0 % 2 == 0 ? lhs : rhs }
    
}

public func %% (lhs: [String], rhs: [String]) -> (Int) -> [String] {

    return { $0 % 2 == 0 ? lhs : rhs }

}
