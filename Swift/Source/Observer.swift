//
//  File.swift
//  Pods
//
//  Created by Maria Fossli on 26.11.2016.
//
//

import Foundation

internal final class Observer <T> {
    
    private var index = 0
    internal var items: [Int : T] = [:]
    
    public init() { }
    
    public func add(_ closure: T) -> Int {
        index += 1
        items[index] = closure
        return index
    }
    
    public func remove(_ observerId: Int) throws {
        items[observerId] = nil
    }
    
}
