//
//  Variable.swift
//  Pods
//
//  Created by Maria Fossli on 20.11.2016.
//
//

public class Variable: UniqueId {
    
    private static var index: Int32 = 0
    internal let id: Int = Int(OSAtomicIncrement32(&Variable.index))
    
    private var observers: [(Double) -> Void] = []
    public internal(set) var value: Double = 0.0 {
        didSet {
            for observer in observers {
                observer(value)
            }
        }
    }
    
    public init() {}
    
    public func onChange(_ closure: @escaping (Double) -> Void) {
        observers.append(closure)
    }
    
    internal func equals(_ other: Variable) -> Bool {
        return id == other.id
    }
}
