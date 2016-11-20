//
//  Expression.swift
//  Pods
//
//  Created by Maria Fossli on 20.11.2016.
//
//

public class Expression: UniqueId {
    
    private static var index: Int32 = 0
    internal let id: Int = Int(OSAtomicIncrement32(&Expression.index))
    
    internal var terms: [Term] = []
    internal var constants: [Double] = []
    
    public init() {}
    
    public init(_ term: Term) {
        add(term)
    }
    
    public init(_ variable: Variable) {
        add(Term(variable))
    }
    
    public init(_ constant: Double) {
        add(constant)
    }
    
    public func inverted() -> Expression {
        let expr = Expression()
        for term in terms {
            expr.add(term.inverted())
        }
        for constant in constants {
            expr.add(-constant)
        }
        return expr
    }
    
    public func add(_ expression: Expression) {
        terms.append(contentsOf: terms)
        constants.append(contentsOf: constants)
    }
    
    public func add(_ term: Term) {
        terms.append(term)
    }
    
    public func add(_ variable: Variable) {
        terms.append(Term(variable))
    }
    
    public func add(_ constant: Double) {
        constants.append(constant)
    }
    
    public func add(_ terms: [Term]) {
        self.terms.append(contentsOf: terms)
    }
    
    public func add(_ variables: [Variable]) {
        for variable in variables {
            add(variable)
        }
    }
    
    public func add(_ constants: [Double]) {
        self.constants.append(contentsOf: constants)
    }
    
    internal func equals(_ other: Expression) -> Bool {
        
        if constants.count != other.constants.count {
            return false
        }
        
        for (index, constant) in constants.enumerated() {
            let otherConstant = other.constants[index]
            if constant != otherConstant {
                return false
            }
        }
        
        if terms.count != other.terms.count {
            return false
        }
        
        for (index, term) in terms.enumerated() {
            let otherTerm = other.terms[index]
            if !term.equals(otherTerm) {
                return false
            }
        }
        
        return true
    }
}
