//
//  Constraint.swift
//  Pods
//
//  Created by Maria Fossli on 20.11.2016.
//
//

public final class Constraint: UniqueId {
    
    public let relation: Relation
    public let strength: Double
    
    private static var index: Int32 = 0
    public let id: Int = Int(OSAtomicIncrement32(&Constraint.index))
    
    public let expression: Expression
    
    public init(_ lhs: Expression, _ relation: Relation, _ rhs: Expression, strength: Double = Strength.required) {
        self.relation = relation
        self.expression = lhs.added(rhs.flipped())
        self.strength = strength
    }
    
    public func withStrength(_ strength: Double) -> Constraint {
        return Constraint(self.expression, self.relation, Expression(), strength: strength)
    }
    
    public func weak() -> Constraint {
        return withStrength(Strength.weak)
    }
    
    public func medium() -> Constraint {
        return withStrength(Strength.medium)
    }
    
    public func strong() -> Constraint {
        return withStrength(Strength.strong)
    }
    
    public func required() -> Constraint {
        return withStrength(Strength.required)
    }
    
    public func equals(_ other: Constraint) -> Bool {
        if relation != other.relation {
            return false
        }
        if strength != other.strength {
            return false
        }
        if !expression.equals(other.expression) {
            return false
        }
        return true
    }
}
