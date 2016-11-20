//
//  OperatorsGeneratingConstraints.swift
//  Pods
//
//  Created by Maria Fossli on 20.11.2016.
//
//

// expression & expression

public func ==(lhs: Expression, rhs: Expression) -> Constraint {
    return Constraint(lhs, .eq, rhs)
}

public func >=(lhs: Expression, rhs: Expression) -> Constraint {
    return Constraint(lhs, .geq, rhs)
}

public func <=(lhs: Expression, rhs: Expression) -> Constraint {
    return Constraint(lhs, .leq, rhs)
}

// term & expression

public func ==(lhs: Expression, rhs: Term) -> Constraint {
    return Constraint(lhs, .eq, Expression(rhs))
}

public func >=(lhs: Expression, rhs: Term) -> Constraint {
    return Constraint(lhs, .geq, Expression(rhs))
}

public func <=(lhs: Expression, rhs: Term) -> Constraint {
    return Constraint(lhs, .leq, Expression(rhs))
}

public func ==(lhs: Term, rhs: Expression) -> Constraint {
    return Constraint(Expression(lhs), .eq, rhs)
}

public func >=(lhs: Term, rhs: Expression) -> Constraint {
    return Constraint(Expression(lhs), .geq, rhs)
}

public func <=(lhs: Term, rhs: Expression) -> Constraint {
    return Constraint(Expression(lhs), .leq, rhs)
}

// variable & expression

public func ==(lhs: Expression, rhs: Variable) -> Constraint {
    return Constraint(lhs, .eq, Expression(rhs))
}

public func >=(lhs: Expression, rhs: Variable) -> Constraint {
    return Constraint(lhs, .geq, Expression(rhs))
}

public func <=(lhs: Expression, rhs: Variable) -> Constraint {
    return Constraint(lhs, .leq, Expression(rhs))
}

public func ==(lhs: Variable, rhs: Expression) -> Constraint {
    return Constraint(Expression(lhs), .eq, rhs)
}

public func >=(lhs: Variable, rhs: Expression) -> Constraint {
    return Constraint(Expression(lhs), .geq, rhs)
}

public func <=(lhs: Variable, rhs: Expression) -> Constraint {
    return Constraint(Expression(lhs), .leq, rhs)
}

// double & expression

public func ==(lhs: Expression, rhs: Double) -> Constraint {
    return Constraint(lhs, .eq, Expression(rhs))
}

public func >=(lhs: Expression, rhs: Double) -> Constraint {
    return Constraint(lhs, .geq, Expression(rhs))
}

public func <=(lhs: Expression, rhs: Double) -> Constraint {
    return Constraint(lhs, .leq, Expression(rhs))
}

public func ==(lhs: Double, rhs: Expression) -> Constraint {
    return Constraint(Expression(lhs), .eq, rhs)
}

public func >=(lhs: Double, rhs: Expression) -> Constraint {
    return Constraint(Expression(lhs), .geq, rhs)
}

public func <=(lhs: Double, rhs: Expression) -> Constraint {
    return Constraint(Expression(lhs), .leq, rhs)
}

// term & term

public func ==(lhs: Term, rhs: Term) -> Constraint {
    return Constraint(Expression(lhs), .eq, Expression(rhs))
}

public func >=(lhs: Term, rhs: Term) -> Constraint {
    return Constraint(Expression(lhs), .geq, Expression(rhs))
}

public func <=(lhs: Term, rhs: Term) -> Constraint {
    return Constraint(Expression(lhs), .leq, Expression(rhs))
}

// double & term

public func ==(lhs: Term, rhs: Double) -> Constraint {
    return Constraint(Expression(lhs), .eq, Expression(rhs))
}

public func >=(lhs: Term, rhs: Double) -> Constraint {
    return Constraint(Expression(lhs), .geq, Expression(rhs))
}

public func <=(lhs: Term, rhs: Double) -> Constraint {
    return Constraint(Expression(lhs), .leq, Expression(rhs))
}

public func ==(lhs: Double, rhs: Term) -> Constraint {
    return Constraint(Expression(lhs), .eq, Expression(rhs))
}

public func >=(lhs: Double, rhs: Term) -> Constraint {
    return Constraint(Expression(lhs), .geq, Expression(rhs))
}

public func <=(lhs: Double, rhs: Term) -> Constraint {
    return Constraint(Expression(lhs), .leq, Expression(rhs))
}

// variable & term

public func ==(lhs: Term, rhs: Variable) -> Constraint {
    return Constraint(Expression(lhs), .eq, Expression(rhs))
}

public func >=(lhs: Term, rhs: Variable) -> Constraint {
    return Constraint(Expression(lhs), .geq, Expression(rhs))
}

public func <=(lhs: Term, rhs: Variable) -> Constraint {
    return Constraint(Expression(lhs), .leq, Expression(rhs))
}

public func ==(lhs: Variable, rhs: Term) -> Constraint {
    return Constraint(Expression(lhs), .eq, Expression(rhs))
}

public func >=(lhs: Variable, rhs: Term) -> Constraint {
    return Constraint(Expression(lhs), .geq, Expression(rhs))
}

public func <=(lhs: Variable, rhs: Term) -> Constraint {
    return Constraint(Expression(lhs), .leq, Expression(rhs))
}

// variable & variable

public func ==(lhs: Variable, rhs: Variable) -> Constraint {
    return Constraint(Expression(lhs), .eq, Expression(rhs))
}

public func >=(lhs: Variable, rhs: Variable) -> Constraint {
    return Constraint(Expression(lhs), .geq, Expression(rhs))
}

public func <=(lhs: Variable, rhs: Variable) -> Constraint {
    return Constraint(Expression(lhs), .leq, Expression(rhs))
}

// double & variable

public func ==(lhs: Variable, rhs: Double) -> Constraint {
    return Constraint(Expression(lhs), .eq, Expression(rhs))
}

public func >=(lhs: Variable, rhs: Double) -> Constraint {
    return Constraint(Expression(lhs), .geq, Expression(rhs))
}

public func <=(lhs: Variable, rhs: Double) -> Constraint {
    return Constraint(Expression(lhs), .leq, Expression(rhs))
}

public func ==(lhs: Double, rhs: Variable) -> Constraint {
    return Constraint(Expression(lhs), .eq, Expression(rhs))
}

public func >=(lhs: Double, rhs: Variable) -> Constraint {
    return Constraint(Expression(lhs), .geq, Expression(rhs))
}

public func <=(lhs: Double, rhs: Variable) -> Constraint {
    return Constraint(Expression(lhs), .leq, Expression(rhs))
}
