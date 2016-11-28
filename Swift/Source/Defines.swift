//
//  Defines.swift
//  Pods
//
//  Created by Maria Fossli on 20.11.2016.
//
//

public final class Strength {
    public static let required: Double = 1000*1000*1000
    public static let strong: Double   = 1000*1000
    public static let medium: Double   = 1000
    public static let weak: Double     = 1
    
    internal static func underlyingConstantName(_ value: Double) -> String {
        if value == Strength.required {
            return "AM_REQUIRED"
        }
        if value == Strength.strong {
            return "AM_STRONG"
        }
        if value == Strength.medium {
            return "AM_MEDIUM"
        }
        if value == Strength.weak {
            return "AM_WEAK"
        }
        else {
            return String(value)
        }
    }
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
    
    internal func underlyingConstantName() -> String {
        switch(self) {
        case .leq:
            return "AM_LESSEQUAL"
        case .eq:
            return "AM_EQUAL"
        case .geq:
            return "AM_GREATEQUAL"
        }
    }
}
