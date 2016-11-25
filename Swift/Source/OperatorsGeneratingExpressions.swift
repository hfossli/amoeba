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
    let expr = Expression()
    expr.add(lhs)
    expr.add(rhs)
    return expr
}

public func -(lhs: Expression, rhs: Expression) -> Expression {
    let expr = Expression()
    expr.add(lhs)
    expr.add(rhs.flipped())
    return expr
}

// term & expression

public func +(lhs: Term, rhs: Expression) -> Expression {
    let expr = Expression()
    expr.add(lhs)
    expr.add(rhs)
    return expr
}

public func +(lhs: Expression, rhs: Term) -> Expression {
    let expr = Expression()
    expr.add(lhs)
    expr.add(rhs)
    return expr
}

public func -(lhs: Term, rhs: Expression) -> Expression {
    let expr = Expression()
    expr.add(lhs)
    expr.add(rhs.flipped())
    return expr
}

public func -(lhs: Expression, rhs: Term) -> Expression {
    let expr = Expression()
    expr.add(lhs)
    expr.add(rhs.flipped())
    return expr
}

// variable & expression

public func +(lhs: Variable, rhs: Expression) -> Expression {
    let expr = Expression()
    expr.add(lhs)
    expr.add(rhs)
    return expr
}

public func +(lhs: Expression, rhs: Variable) -> Expression {
    let expr = Expression()
    expr.add(lhs)
    expr.add(rhs)
    return expr
}

public func -(lhs: Variable, rhs: Expression) -> Expression {
    let expr = Expression()
    expr.add(lhs)
    expr.add(rhs.flipped())
    return expr
}

public func -(lhs: Expression, rhs: Variable) -> Expression {
    let expr = Expression()
    expr.add(lhs)
    expr.add(Term(rhs, -1.0))
    return expr
}

// term & term

public func +(lhs: Term, rhs: Term) -> Expression {
    return Expression(lhs) + Expression(rhs)
}

public func -(lhs: Term, rhs: Term) -> Expression {
    return lhs + -rhs
}

// double & expression

public func +(lhs: Expression, rhs: Double) -> Expression {
    let expr = Expression()
    expr.add(lhs)
    expr.add(rhs)
    return expr
}

public func +(lhs: Double, rhs: Expression) -> Expression {
    let expr = Expression()
    expr.add(lhs)
    expr.add(rhs)
    return expr
}

public func -(lhs: Expression, rhs: Double) -> Expression {
    let expr = Expression()
    expr.add(lhs)
    expr.add(-rhs)
    return expr
}

public func -(lhs: Double, rhs: Expression) -> Expression {
    let expr = Expression()
    expr.add(lhs)
    expr.add(-rhs)
    return expr
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
    let expr = Expression(lhs)
    expr.add(rhs)
    return expr
}

public func +(lhs: Double, rhs: Term) -> Expression {
    let expr = Expression(lhs)
    expr.add(rhs)
    return expr
}

public func -(lhs: Term, rhs: Double) -> Expression {
    return lhs + -rhs
}

public func -(lhs: Double, rhs: Term) -> Expression {
    return lhs + -rhs
}

// variable & term

public func +(lhs: Term, rhs: Variable) -> Expression {
    let expr = Expression(lhs)
    expr.add(rhs)
    return expr
}

public func +(lhs: Variable, rhs: Term) -> Expression {
    let expr = Expression(lhs)
    expr.add(rhs)
    return expr
}

public func -(lhs: Term, rhs: Variable) -> Expression {
    return lhs + -rhs
}

public func -(lhs: Variable, rhs: Term) -> Expression {
    return lhs + -rhs
}

// variable & variable

public func -(lhs: Variable, rhs: Variable) -> Expression {
    let expr = Expression()
    expr.add(lhs)
    expr.add(-rhs)
    return expr
}

public func +(lhs: Variable, rhs: Variable) -> Expression {
    return lhs + -rhs
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
