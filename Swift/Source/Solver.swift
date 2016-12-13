
public enum SolverError: Error {
    case notFound
}

public final class Solver {
    
    private static var index: Int32 = 0
    public let id: Int = Int(OSAtomicIncrement32(&Solver.index))
    private let solver: am_SolverRef
    private let debug: Bool
    private var constraintsMap: [Wrapper<Constraint>: am_ConstraintRef] = [:]
    private var variableMap: [Wrapper<Variable>: am_VariableRef] = [:]
    private var observers: [Wrapper<Variable>:Observer<(Double) -> Void>] = [:]
    private var values: [Wrapper<Variable>:Double] = [:]
    private var actions: [String] = []
    
    public init(debug: Bool = false) {
        self.debug = debug
        self.actions = ["am_Solver *s\(id) = am_newsolver(NULL, NULL)"]
        self.solver = am_newsolver(nil, nil)
    }
    
    deinit {
        if debug { log("am_delsolver(s\(id))") }
        am_delsolver(solver)
    }
                                                                                
    public func add(_ constraint: Constraint) throws {
        let underlying = self.underlying(constraint: constraint)
        
        if debug { log("am_add(c\(constraint.id))") }
        let result = am_add(underlying)
        
        cacheAndCallObservers()
        if result != AM_OK {
            throw AmoebaError.fromUnderlying(result)
        }
    }
    
    public func add(_ constraints: [Constraint]) throws {
        var added: [Constraint] = []
        do {
            for constraint in constraints {
                try add(constraint)
                added.append(constraint)
            }
        } catch let error {
            for constraint in added {
                try remove(constraint)
            }
            throw error
        }
    }
    
    public func remove(_ constraint: Constraint) throws {
        let underlying = self.underlying(constraint: constraint)
        if debug { log("am_remove(c\(constraint.id))") }
        am_remove(underlying)
        cacheAndCallObservers()
    }
    
    public func remove(_ constraints: [Constraint]) throws {
        var removed: [Constraint] = []
        do {
            for constraint in constraints {
                try remove(constraint)
                removed.append(constraint)
            }
        } catch let error {
            for constraint in removed {
                try add(constraint)
            }
            throw error
        }
    }
    
    public func value(_ variable: Variable) throws -> Double {
        let underlying = try self.underlying(variable: variable)
        if debug { log("am_value(v\(variable.id))") }
        return am_value(underlying)
    }
    
    public func value(_ expression: Expression) throws -> Double {
        var result = 0.0
        for term in expression.terms {
            result += try value(term.variable) * term.multiplier
        }
        for constant in expression.constants {
            result += constant
        }
        return result
    }
    
    public func observe(_ variable: Variable, _ closure: @escaping (Double) -> Void) -> Int {
        let key = Wrapper(variable)
        if let observer = observers[key] {
            return observer.add(closure)
        } else {
            let observer = Observer<(Double) -> Void>()
            observers[key] = observer
            return observer.add(closure)
        }
    }
    
    public func stopObserve(_ variable: Variable, observerId: Int) throws {
        let key = Wrapper(variable)
        guard let observer = observers[key] else {
            throw SolverError.notFound
        }
        try observer.remove(observerId)
    }
    
    public func variablesAndValues() -> [Wrapper<Variable>:Double] {
        return values
    }
    
    private func cacheAndCallObservers() {
        let changes = cacheValues()
        callObservers(changes: changes)
    }
    
    private func cacheValues() -> [Wrapper<Variable>:Double] {
        var changed: [Wrapper<Variable>:Double] = [:]
        let cache = values
        cache.forEach { (overlying, value) in
            if let underlying = try? self.underlying(variable: overlying.item, autocreate: false) {
                if value != underlying.value {
                    changed[overlying] = value
                }
            }
        }
        return changed
    }
    
    private func callObservers(changes: [Wrapper<Variable>:Double]) {
        changes.forEach { (wrapper, newValue) in
            if let observer = observers[wrapper] {
                observer.items.forEach { (id, closure) in
                    closure(newValue)
                }
            }
        }
    }
    
    private func createConstraint(_ constraint: Constraint) -> am_ConstraintRef {
        
        if debug { log("am_Constraint *c\(constraint.id) = am_newconstraint(s\(id), \(Strength.underlyingConstantName(constraint.strength)))") }
        let underlying = am_newconstraint(solver, constraint.strength)!
        
        for term in constraint.expression.terms {
            let variable = try! self.underlying(variable: term.variable)
            
            if debug { log("am_addterm(c\(constraint.id), v\(term.variable.id), \(term.multiplier))") }
            am_addterm(underlying, variable, term.multiplier)
        }
        for constant in constraint.expression.constants {
            if debug { log("am_addconstant(c\(constraint.id), \(constant))") }
            am_addconstant(underlying, constant)
        }
        
        if debug { log("am_setrelation(c\(constraint.id), \(constraint.relation.underlyingConstantName()))") }
        am_setrelation(underlying, constraint.relation.underlying())
        
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
    
    private func underlying(variable: Variable, autocreate: Bool = true) throws -> am_VariableRef {
        if let underlying = variableMap[Wrapper(variable)] {
            return underlying
        }
        guard autocreate else {
            throw AmoebaError.failed
        }
        
        if debug { log("am_Variable *v\(variable.id) = am_newvariable(s\(id))") }
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
    
    private func log(_ action: String) {
        actions.append(action)
    }
    
    public func allActions() -> [String] {
        return actions
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