//
//  Defines.swift
//  Pods
//
//  Created by Maria Fossli on 20.11.2016.
//
//

public class Strength {
    public static let required: Double = 1000*1000*1000
    public static let strong: Double   = 1000*1000
    public static let medium: Double   = 1000
    public static let weak: Double     = 1
}

public enum AmoebaError: Error {
    case failed
    case unsatisfied
    case unbound
    
    internal static func fromUnderlying(_ underlying: Int32) -> AmoebaError {
        switch underlying {
        case AM_FAILED:
            return .failed
        case AM_UNSATISFIED:
            return .unsatisfied
        case AM_UNBOUND:
            return .unbound
        default:
            return .failed
        }
    }
}

public enum Relation {
    case leq
    case eq
    case geq
    
    internal func underlying() -> Int32 {
        switch(self) {
        case .leq:
            return AM_LESSEQUAL
        case .eq:
            return AM_EQUAL
        case .geq:
            return AM_GREATEQUAL
        }
    }
}
