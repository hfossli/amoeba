//
//  OperatorsGeneratingExpressions.swift
//  Pods
//
//  Created by Maria Fossli on 20.11.2016.
//
//

// expression

public prefix func -(expr: Expression) -> Expression {
    return expr.flipped()
}

public prefix func +(expr: Expression) -> Expression {
    return expr
}

// expression & expression

public func +(lhs: Expression, rhs: Expression) -> Expression {
    return lhs.added(rhs)
}

public func -(lhs: Expression, rhs: Expression) -> Expression {
    return lhs.added(rhs.flipped())
}

// term & expression

public func +(lhs: Term, rhs: Expression) -> Expression {
    return rhs.added(lhs)
}

public func +(lhs: Expression, rhs: Term) -> Expression {
    return lhs.added(rhs)
}

public func -(lhs: Term, rhs: Expression) -> Expression {
    return Expression(lhs).added(rhs.flipped())
}

public func -(lhs: Expression, rhs: Term) -> Expression {
    return lhs.added(rhs.flipped())
}

// variable & expression

public func +(lhs: Variable, rhs: Expression) -> Expression {
    return rhs.added(lhs)
}

public func +(lhs: Expression, rhs: Variable) -> Expression {
    return lhs.added(rhs)
}

public func -(lhs: Variable, rhs: Expression) -> Expression {
    return Expression(lhs).added(rhs.flipped())
}

public func -(lhs: Expression, rhs: Variable) -> Expression {
    return lhs.added(Term(rhs).flipped())
}

// term & term

public func +(lhs: Term, rhs: Term) -> Expression {
    return Expression(terms: [lhs, rhs])
}

public func -(lhs: Term, rhs: Term) -> Expression {
    return Expression(terms: [lhs, rhs.flipped()])
}

// double & expression

public func +(lhs: Expression, rhs: Double) -> Expression {
    return lhs.added(rhs)
}

public func +(lhs: Double, rhs: Expression) -> Expression {
    return rhs.added(lhs)
}

public func -(lhs: Expression, rhs: Double) -> Expression {
    return lhs.added(-rhs)
}

public func -(lhs: Double, rhs: Expression) -> Expression {
    return rhs.flipped().added(lhs)
}

public func *(lhs: Expression, rhs: Double) -> Expression {
    return lhs.multiplied(rhs)
}

public func *(lhs: Double, rhs: Expression) -> Expression {
    return rhs.multiplied(lhs)
}

public func /(lhs: Expression, rhs: Double) -> Expression {
    return lhs.multiplied(1.0/rhs)
}

public func /(lhs: Double, rhs: Expression) -> Expression {
    return rhs.inverted().multiplied(lhs)
}

// double & term

public func +(lhs: Term, rhs: Double) -> Expression {
    return Expression(terms: [lhs], constants: [rhs])
}

public func +(lhs: Double, rhs: Term) -> Expression {
    return Expression(terms: [rhs], constants: [lhs])
}

public func -(lhs: Term, rhs: Double) -> Expression {
    return lhs + -rhs
}

public func -(lhs: Double, rhs: Term) -> Expression {
    return lhs + -rhs
}

// variable & term

public func +(lhs: Term, rhs: Variable) -> Expression {
    return Expression(terms: [lhs, Term(rhs)])
}

public func +(lhs: Variable, rhs: Term) -> Expression {
    return Expression(terms: [rhs, Term(lhs)])
}

public func -(lhs: Term, rhs: Variable) -> Expression {
    return Expression(terms: [lhs, Term(rhs).flipped()])
}

public func -(lhs: Variable, rhs: Term) -> Expression {
    return Expression(terms: [Term(lhs), rhs.flipped()])
}

// variable & variable

public func -(lhs: Variable, rhs: Variable) -> Expression {
    return Expression(terms: [Term(lhs), Term(rhs).flipped()])
}

public func +(lhs: Variable, rhs: Variable) -> Expression {
    return Expression(terms: [Term(lhs), Term(rhs)])
}

// double & variable

public func +(lhs: Variable, rhs: Double) -> Expression {
    return Term(lhs) + rhs
}

public func +(lhs: Double, rhs: Variable) -> Expression {
    return lhs + Term(rhs)
}

public func -(lhs: Variable, rhs: Double) -> Expression {
    return Term(lhs) - rhs
}

public func -(lhs: Double, rhs: Variable) -> Expression {
    return lhs - Term(rhs)
}
