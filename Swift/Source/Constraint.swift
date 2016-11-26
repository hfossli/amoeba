//
//  Constraint.swift
//  Pods
//
//  Created by Maria Fossli on 20.11.2016.
//
//

public class Constraint: UniqueId {
    
    public let relation: Relation
    public var strength: Double = Strength.required
    
    private static var index: Int32 = 0
    public let id: Int = Int(OSAtomicIncrement32(&Constraint.index))
    
    public let expression: Expression
    
    public init(_ lhs: Expression, _ relation: Relation, _ rhs: Expression) {
        self.relation = relation
        self.expression = lhs.added(rhs.flipped())
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
