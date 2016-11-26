//
//  Variable.swift
//  Pods
//
//  Created by Maria Fossli on 20.11.2016.
//
//

public class Variable: UniqueId {
    
    private static var index: Int32 = 0
    public let id: Int = Int(OSAtomicIncrement32(&Variable.index))
    
    public init() {}
    
    public func equals(_ other: Variable) -> Bool {
        return id == other.id
    }
}
