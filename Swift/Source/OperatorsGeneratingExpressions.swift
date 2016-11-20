//
//  OperatorsGeneratingExpressions.swift
//  Pods
//
//  Created by Maria Fossli on 20.11.2016.
//
//

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
    expr.add(rhs.inverted())
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
    expr.add(rhs.inverted())
    return expr
}

public func -(lhs: Expression, rhs: Term) -> Expression {
    let expr = Expression()
    expr.add(lhs)
    expr.add(rhs.inverted())
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
    expr.add(rhs.inverted())
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
    return rhs + -lhs
}

public func -(lhs: Double, rhs: Term) -> Expression {
    let expr = Expression()
    expr.add(lhs)
    expr.add(rhs.inverted())
    return expr
}

// variable & variable

public func +(lhs: Variable, rhs: Variable) -> Expression {
    let expr = Expression()
    expr.add(lhs)
    expr.add(rhs)
    return expr
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
