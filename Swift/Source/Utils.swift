//
//  Utils.swift
//  Pods
//
//  Created by Maria Fossli on 20.11.2016.
//
//

protocol UniqueId {
    var id: Int { get }
    func equals(_ other: Self) -> Bool
}

internal class Wrapper<T: UniqueId> : Hashable, Equatable {
    
    let item: T
    
    init(_ item: T) {
        self.item = item
    }
    
    var hashValue: Int {
        return item.id
    }
    
    public static func ==(lhs: Wrapper<T>, rhs: Wrapper<T>) -> Bool {
        return lhs.item.equals(rhs.item)
    }
}
