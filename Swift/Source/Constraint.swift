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
    internal let id: Int = Int(OSAtomicIncrement32(&Constraint.index))
    
    internal var expressions: [Expression] = []
    
    public init(_ lhs: Expression, _ relation: Relation, _ rhs: Expression) {
        self.relation = relation
        expressions.append(lhs)
        expressions.append(rhs.inverted())
    }
    
    internal func equals(_ other: Constraint) -> Bool {
        if relation != other.relation {
            return false
        }
        if strength != other.strength {
            return false
        }
        if expressions.count != other.expressions.count {
            return false
        }
        
        for (index, expression) in expressions.enumerated() {
            let otherExpression = other.expressions[index]
            if !expression.equals(otherExpression) {
                return false
            }
        }
        return true
    }
}
