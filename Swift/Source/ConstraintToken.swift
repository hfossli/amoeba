//
//  ConstraintToken.swift
//  Pods
//
//  Created by Maria Fossli on 13.12.2016.
//
//

import Foundation

public enum ConstraintToken {
    case value(Double)
    case variable(Variable)
    case term(Term)
    case expression(Expression)
    
    public func downgraded() -> Expression {
        switch self {
        case .value(let value):
            return Expression(value)
        case .variable(let value):
            return Expression(value)
        case .term(let value):
            return Expression(value)
        case .expression(let expression):
            return expression
        }
    }
}

public enum ConstraintTokenOperator: String {
    case add = "+"
    case subtract = "-"
    case multiply = "*"
    case divide = "/"
}

public enum ConstraintTokenError: Error {
    case notPossible
}

public extension ConstraintToken {
    
    public func apply(_ op: ConstraintTokenOperator, with: ConstraintToken) throws -> ConstraintToken {
        
        switch op {
        case .add:
            switch self {
            case .value(let lhsDouble):
                switch with {
                case .value(let rhsDouble):
                    return .value(lhsDouble + rhsDouble)
                case .variable(let rhsVariable):
                    return .expression(lhsDouble + rhsVariable)
                case .term(let rhsTerm):
                    return .expression(lhsDouble + rhsTerm)
                case .expression(let rhsExpression):
                    return .expression(lhsDouble + rhsExpression)
                }
            case .variable(let lhsVariable):
                switch with {
                case .value(let rhsDouble):
                    return .expression(lhsVariable + rhsDouble)
                case .variable(let rhsVariable):
                    return .expression(lhsVariable + rhsVariable)
                case .term(let rhsTerm):
                    return .expression(lhsVariable + rhsTerm)
                case .expression(let rhsExpression):
                    return .expression(lhsVariable + rhsExpression)
                }
            case .term(let lhsTerm):
                switch with {
                case .value(let rhsDouble):
                    return .expression(lhsTerm + rhsDouble)
                case .variable(let rhsVariable):
                    return .expression(lhsTerm + rhsVariable)
                case .term(let rhsTerm):
                    return .expression(lhsTerm + rhsTerm)
                case .expression(let rhsExpression):
                    return .expression(lhsTerm + rhsExpression)
                }
            case .expression(let lhsExpression):
                switch with {
                case .value(let rhsDouble):
                    return .expression(lhsExpression + rhsDouble)
                case .variable(let rhsVariable):
                    return .expression(lhsExpression + rhsVariable)
                case .term(let rhsTerm):
                    return .expression(lhsExpression + rhsTerm)
                case .expression(let rhsExpression):
                    return .expression(lhsExpression + rhsExpression)
                }
            }
        case .subtract:
            switch self {
            case .value(let lhsDouble):
                switch with {
                case .value(let rhsDouble):
                    return .value(lhsDouble - rhsDouble)
                case .variable(let rhsVariable):
                    return .expression(lhsDouble - rhsVariable)
                case .term(let rhsTerm):
                    return .expression(lhsDouble - rhsTerm)
                case .expression(let rhsExpression):
                    return .expression(lhsDouble - rhsExpression)
                }
            case .variable(let lhsVariable):
                switch with {
                case .value(let rhsDouble):
                    return .expression(lhsVariable - rhsDouble)
                case .variable(let rhsVariable):
                    return .expression(lhsVariable - rhsVariable)
                case .term(let rhsTerm):
                    return .expression(lhsVariable - rhsTerm)
                case .expression(let rhsExpression):
                    return .expression(lhsVariable - rhsExpression)
                }
            case .term(let lhsTerm):
                switch with {
                case .value(let rhsDouble):
                    return .expression(lhsTerm - rhsDouble)
                case .variable(let rhsVariable):
                    return .expression(lhsTerm - rhsVariable)
                case .term(let rhsTerm):
                    return .expression(lhsTerm - rhsTerm)
                case .expression(let rhsExpression):
                    return .expression(lhsTerm - rhsExpression)
                }
            case .expression(let lhsExpression):
                switch with {
                case .value(let rhsDouble):
                    return .expression(lhsExpression - rhsDouble)
                case .variable(let rhsVariable):
                    return .expression(lhsExpression - rhsVariable)
                case .term(let rhsTerm):
                    return .expression(lhsExpression - rhsTerm)
                case .expression(let rhsExpression):
                    return .expression(lhsExpression - rhsExpression)
                }
            }
        case .multiply:
            switch self {
            case .value(let lhsDouble):
                switch with {
                case .value(let rhsDouble):
                    return .value(lhsDouble * rhsDouble)
                case .variable(let rhsVariable):
                    return .term(lhsDouble * rhsVariable)
                case .term(let rhsTerm):
                    return .term(lhsDouble * rhsTerm)
                case .expression(let rhsExpression):
                    return .expression(lhsDouble * rhsExpression)
                }
            case .variable(let lhsVariable):
                switch with {
                case .value(let rhsDouble):
                    return .term(lhsVariable * rhsDouble)
                default:
                    throw ConstraintTokenError.notPossible
                }
            case .term(let lhsTerm):
                switch with {
                case .value(let rhsDouble):
                    return .term(lhsTerm * rhsDouble)
                default:
                    throw ConstraintTokenError.notPossible
                }
            case .expression(let lhsExpression):
                switch with {
                case .value(let rhsDouble):
                    return .expression(lhsExpression * rhsDouble)
                default:
                    throw ConstraintTokenError.notPossible
                }
            }
        case .divide:
            switch self {
            case .value(let lhsDouble):
                switch with {
                case .value(let rhsDouble):
                    return .value(lhsDouble / rhsDouble)
                case .variable(let rhsVariable):
                    return .term(lhsDouble / rhsVariable)
                case .term(let rhsTerm):
                    return .term(lhsDouble / rhsTerm)
                case .expression(let rhsExpression):
                    return .expression(lhsDouble / rhsExpression)
                }
            case .variable(let lhsVariable):
                switch with {
                case .value(let rhsDouble):
                    return .term(lhsVariable / rhsDouble)
                default:
                    throw ConstraintTokenError.notPossible
                }
            case .term(let lhsTerm):
                switch with {
                case .value(let rhsDouble):
                    return .term(lhsTerm / rhsDouble)
                default:
                    throw ConstraintTokenError.notPossible
                }
            case .expression(let lhsExpression):
                switch with {
                case .value(let rhsDouble):
                    return .expression(lhsExpression / rhsDouble)
                default:
                    throw ConstraintTokenError.notPossible
                }
            }
        }
    }
}
