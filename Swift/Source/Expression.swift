//
//  Expression.swift
//  Pods
//
//  Created by Maria Fossli on 20.11.2016.
//
//

public final class Expression: UniqueId {
    
    private static var index: Int32 = 0
    public let id: Int = Int(OSAtomicIncrement32(&Expression.index))
    
    public let terms: [Term]
    public let constants: [Double]
    
    public init() {
        self.terms = []
        self.constants = []
    }
    
    public init(terms: [Term] = [], constants: [Double] = []) {
        self.terms = terms
        self.constants = constants
    }
    
    public init(_ term: Term) {
        self.terms = [term]
        self.constants = []
    }
    
    public init(_ variable: Variable) {
        self.terms = [Term(variable)]
        self.constants = []
    }
    
    public init(_ constant: Double) {
        self.terms = []
        self.constants = [constant]
    }
    
    public func flipped() -> Expression {
        var terms:[Term] = []
        for term in self.terms {
            terms.append(term.flipped())
        }
        var constants:[Double] = []
        for constant in self.constants {
            constants.append(-constant)
        }
        return Expression(terms: terms, constants: constants)
    }
    
    public func inverted() -> Expression {
        var terms:[Term] = []
        for term in self.terms {
            terms.append(term.inverted())
        }
        var constants:[Double] = []
        for constant in self.constants {
            constants.append(1.0 / constant)
        }
        return Expression(terms: terms, constants: constants)
    }
    
    public func multiplied(_ factor: Double) -> Expression {
        var terms:[Term] = []
        for term in self.terms {
            terms.append(term.multiplied(factor))
        }
        var constants:[Double] = []
        for constant in self.constants {
            constants.append(constant * factor)
        }
        return Expression(terms: terms, constants: constants)
    }
    
    public func added(_ expression: Expression) -> Expression {
        return Expression(terms: terms + expression.terms, constants: constants + expression.constants)
    }
    
    public func added(_ term: Term) -> Expression {
        return Expression(terms: [term] + terms, constants: constants)
    }
    
    public func added(_ variable: Variable) -> Expression {
        return Expression(terms: [Term(variable)] + terms, constants: constants)
    }
    
    public func added(_ constant: Double) -> Expression {
        return Expression(terms: terms, constants: constants + [constant])
    }
    
    public func added(_ terms: [Term]) -> Expression {
        return Expression(terms: terms + terms, constants: constants)
    }
    
    public func added(_ variables: [Variable]) -> Expression {
        var terms:[Term] = []
        for variable in variables {
            terms.append(Term(variable))
        }
        return added(terms)
    }
    
    public func added(_ constants: [Double]) -> Expression {
        return Expression(terms: terms, constants: constants + constants)
    }
    
    public func asVariable() -> Variable? {
        guard constants.count == 0 else {
            return nil
        }
        guard terms.count == 1 else {
            return nil
        }
        guard let firstTerm = terms.first else {
            return nil
        }
        guard firstTerm.multiplier == 1 else {
            return nil
        }
        return firstTerm.variable
    }
    
    public func equals(_ other: Expression) -> Bool {
        
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
