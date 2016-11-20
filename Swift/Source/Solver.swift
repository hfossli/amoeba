


public class Solver {
    
    private let solver: am_SolverRef
    private var constraintsMap: [Wrapper<Constraint>: am_ConstraintRef] = [:]
    private var variableMap: [Wrapper<Variable>: am_VariableRef] = [:]
    
    public init() {
        solver = am_newsolver(nil, nil)
    }
    
    deinit {
        am_delsolver(solver)
    }
    
    public func add(_ constraint: Constraint) throws {
        let underlying = self.underlying(constraint: constraint)
        let result = am_add(underlying)
        if result != AM_OK {
            throw AmoebaError.fromUnderlying(result)
        }
    }
    
    public func remove(_ constraint: Constraint) throws {
        let underlying = self.underlying(constraint: constraint)
        am_remove(underlying)
        // todo: throw if not found
    }
    
    public func value(_ variable: Variable) -> Double {
        let underlying = self.underlying(variable: variable)
        return am_value(underlying)
    }
    
    private func createConstraint(_ constraint: Constraint) -> am_ConstraintRef {
        let underlying = am_newconstraint(solver, constraint.strength)!
        am_setstrength(underlying, constraint.strength)
        am_setrelation(underlying, constraint.relation.underlying())
        for expression in constraint.expressions {
            for term in expression.terms {
                let variable = self.underlying(variable: term.variable)
                am_addterm(underlying, variable, term.multiplier)
            }
            for constant in expression.constants {
                am_addconstant(underlying, constant)
            }
        }
        return underlying
    }
    
    private func underlying(constraint: Constraint) -> am_ConstraintRef {
        if let underlying = constraintsMap[Wrapper(constraint)] {
            return underlying
        }
        let underlying = createConstraint(constraint)
        constraintsMap[Wrapper(constraint)] = underlying
        return underlying
    }
    
    private func overlying(constraint: am_ConstraintRef) -> Constraint {
        let overlying = constraintsMap.first { (overlying, underlying) -> Bool in
            return underlying == constraint
        }
        return overlying!.key.item
    }
    
    private func underlying(variable: Variable) -> am_VariableRef {
        if let underlying = variableMap[Wrapper(variable)] {
            return underlying
        }
        let underlying = am_newvariable(solver)!
        variableMap[Wrapper(variable)] = underlying
        return underlying
    }
    
    private func overlying(variable: am_VariableRef) -> Variable {
        let overlying = variableMap.first { (overlying, underlying) -> Bool in
            return underlying == variable
        }
        return overlying!.key.item
    }
}

public extension am_VariableRef {
    
    public var value: Double {
        return am_value(self)
    }
    
}

public extension am_ConstraintRef {
    
    public func addTerm(variable: am_VariableRef, multiplier: Double = 1.0) throws {
        let result = am_addterm(self, variable, multiplier)
        if result != AM_OK {
            throw AmoebaError.fromUnderlying(result)
        }
    }
    
    public func setRelation(_ relation: Relation) throws {
        let result = am_setrelation(self, relation.underlying())
        if result != AM_OK {
            throw AmoebaError.fromUnderlying(result)
        }
    }
    
    public func addConstant(_ constant: Double) throws {
        let result = am_addconstant(self, constant)
        if result != AM_OK {
            throw AmoebaError.fromUnderlying(result)
        }
    }
    
    public func setStrength(_ strength: Double) throws {
        let result = am_setstrength(self, strength)
        if result != AM_OK {
            throw AmoebaError.fromUnderlying(result)
        }
    }
    
    public func mergeIn(_ constraint: am_ConstraintRef, multiplier: Double = 1.0) throws {
        let result = am_mergeconstraint(self, constraint, multiplier)
        if result != AM_OK {
            throw AmoebaError.fromUnderlying(result)
        }
    }
    
    public func addToSolver() throws {
        let result = am_add(self)
        if result != AM_OK {
            throw AmoebaError.fromUnderlying(result)
        }
    }
    
}

public final class AMSolver {
    
    private let solver: am_SolverRef
    
    public init() {
        solver = am_newsolver(nil, nil)
    }
    
    deinit {
        am_delsolver(solver)
    }
    
    public func createConstraint(strength: Double = Strength.required) -> am_ConstraintRef {
        return am_newconstraint(solver, strength)
    }
    
    public func createVariable() -> am_VariableRef {
        return am_newvariable(solver)
    }
    
    public func add(constraint: am_ConstraintRef) throws {
        let result = am_add(constraint)
        if result != AM_OK {
            throw AmoebaError.fromUnderlying(result)
        }
    }
    
    public func remove(constraint: am_ConstraintRef) throws {
        am_remove(constraint)
        // todo: throw if not found
    }
}
