//
//  OperatorsGeneratingTerms.swift
//  Pods
//
//  Created by Maria Fossli on 20.11.2016.
//
//


public prefix func -(variable: Variable) -> Term {
    return Term(variable).inverted()
}

public prefix func -(term: Term) -> Term {
    return term.inverted()
}

public prefix func +(term: Term) -> Term {
    return term
}

public func *(lhs: Term, rhs: Double) -> Term {
    return lhs.multiplied(rhs)
}

public func *(lhs: Double, rhs: Term) -> Term {
    return rhs.multiplied(lhs)
}

public func /(lhs: Term, rhs: Double) -> Term {
    return lhs.multiplied(1.0/rhs)
}

public func /(lhs: Double, rhs: Term) -> Term {
    return Term(rhs.variable, lhs/rhs.multiplier)
}

public func *(lhs: Variable, rhs: Double) -> Term {
    return Term(lhs) * rhs
}

public func *(lhs: Double, rhs: Variable) -> Term {
    return lhs * Term(rhs)
}

public func /(lhs: Variable, rhs: Double) -> Term {
    return Term(lhs) / rhs
}

public func /(lhs: Double, rhs: Variable) -> Term {
    return lhs / Term(rhs)
}
