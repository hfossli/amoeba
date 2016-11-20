//
//  Term.swift
//  Pods
//
//  Created by Maria Fossli on 20.11.2016.
//
//

public class Term: UniqueId {

    let variable: Variable
    let multiplier: Double
    
    private static var index: Int32 = 0
    internal let id: Int = Int(OSAtomicIncrement32(&Term.index))
    
    public init(_ variable: Variable, _ multiplier: Double = 1.0) {
        self.variable = variable
        self.multiplier = multiplier
    }
    
    public func multiplied(_ factor: Double) -> Term {
        return Term(variable, multiplier * factor)
    }
    
    public func inverted() -> Term {
        return multiplied(-1.0)
    }
    
    internal func equals(_ other: Term) -> Bool {
        if multiplier != other.multiplier {
            return false
        }
        if !variable.equals(other.variable) {
            return false
        }
        return true
    }
}
