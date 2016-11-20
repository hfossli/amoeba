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
    
    public init() {}
    
    internal func equals(_ other: Variable) -> Bool {
        return id == other.id
    }
}
