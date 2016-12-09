//
//  Utils.swift
//  Pods
//
//  Created by Maria Fossli on 20.11.2016.
//
//

public protocol UniqueId {
    var id: Int { get }
    func equals(_ other: Self) -> Bool
}

public final class Wrapper<T: UniqueId> : Hashable, Equatable {
    
    public let item: T
    
    public init(_ item: T) {
        self.item = item
    }
    
    public var hashValue: Int {
        return item.id
    }
    
    public static func ==(lhs: Wrapper<T>, rhs: Wrapper<T>) -> Bool {
        return lhs.item.equals(rhs.item)
    }
}
